function [lmd,CR3_vec,GDP_vec,k_until_ss,C_vec,L_vec,agg_result,result_final,warm]...
    = solve_counterfactual_dynamics_A_j_fix(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,E_t,C_base,L_base,k_until_ss,warm_start)
% Faster deterministic solver that holds sector productivity fixed.
if nargin < 13 || isempty(warm_start)
    warm_start = struct();
end
fast_timer = tic;
inner_progress_interval = 500;

delta = Par.delta;
beta = Par.beta;
phi = Par.phi;

intsh = data.intsh;
pop_data = data.pop_data;
balance = data.balance;

K_hat = data.K_hat;
num_sector = data.num_sector;
secid_service = data.secid_service;
secid_full = data.secid_full;
alpha_j_mat = data.alpha_j_mat;
secid_manu = data.secid_manu;
hour_data = data.hour_data;

year_vec = (min(balance.year):1:max(balance.year))';

Y_vec = zeros(length(year_vec),1);
P_vec = zeros(length(year_vec),1);
R_vec = zeros(length(year_vec),1);

firm_num_mat = zeros(length(year_vec),num_sector);

year_converge=100;
total_period = length(year_vec)-1+year_converge;
% A_j_level_mat = zeros(total_period+1,num_sector);
A_j_level_mat = zeros(length(year_vec)+1,num_sector);
cached_A_j_level_mat = counterfactual_warm_value_or_default(...
    warm_start,'A_j_level_mat',[],size(A_j_level_mat),nan(size(A_j_level_mat)));
has_cached_A_j_levels = all(isfinite(cached_A_j_level_mat(:)));
if has_cached_A_j_levels
    A_j_level_mat = cached_A_j_level_mat;
end

Par.sigma = est_result.sigma;
Par.rho = Par.rho_base;
Par.gamma_L = est_result.gl;
Par.gamma_K = est_result.gk;
Par.gamma_M = est_result.gm;

E_star = E_t(end); % Average value of E_t from t=1,... 38 (This is not affected by convergence part)
r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
phi_bar = result_agg.phi_bar_vec;

%% Cache all inputs that are fixed within an observed year.
fprintf('[fast:A_j] Building period caches for %d observed years...\n',...
    length(year_vec));
period_cache = build_counterfactual_period_cache(...
    year_vec,balance,result,intsh,pop_data,secid_full,secid_service,...
    secid_manu,result_agg,hour_data,alpha_j_mat,Par);
total_firm_vec = cellfun(@(period) period.total_firm,period_cache);

terminal_cache = period_cache{end};
mom = terminal_cache.mom;
shock_firm = terminal_cache.shock_firm;
shock_agg = terminal_cache.shock_agg;
Par.alpha_j = terminal_cache.alpha_j;
fprintf('[fast:A_j] Period caches ready. Solving terminal productivity target...\n');
A_j_given = result_agg.A_j_given;

x_guess_year = x_guess_cell{end};
x_guess = [x_guess_year(1:2*total_firm_vec(end)+2*num_sector);1];
x_guess = counterfactual_warm_value_or_default(...
    warm_start,'x_guess_steady_state',[],size(x_guess),x_guess);

shock_agg.r_over_p = r_over_p;

% Solve steady state of the model
shock_agg.A_j_given = A_j_given(end,:)';

iter = 0;
diff = 10;
dmp=0.2;
diff_previous = Inf;
A_j_level_target_ss = A_j_given(end,:)';
A_j_level_guess = counterfactual_warm_value_or_default(...
    warm_start,'A_j_level_steady_state',[],size(A_j_level_target_ss),...
    ones(length(A_j_level_target_ss),1));
while diff>1e-4 && iter<1e+3
    [diff,A_j_level_next,x_guess] = model_solve_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target_ss,Par, mom, shock_firm, shock_agg, markup, markdown);
    [dmp,~] = model_adapt_damping(dmp,dmp,diff,diff_previous);
    A_j_level_guess = dmp*A_j_level_next+(1-dmp)*A_j_level_guess;
    diff_previous = diff;
    iter = iter+1;
    if mod(iter,25)==0
        fprintf('[fast:A_j:ss] target_iter=%d residual=%.3e damping=%.3f\n',...
            iter,diff,dmp);
    end
end
steady_target_iterations = iter;
fprintf('[fast:A_j:ss] converged=%d target_iterations=%d residual=%.3e\n',...
    diff<=1e-4,iter,diff);
if iter==1e3 && diff>1e-4
    warning('solve_counterfactual_dynamics_A_j_fix:TargetNoConvergence',...
        'The terminal productivity-target iteration reached its limit.');
end
A_j_level_mat(end,:) = A_j_level_guess';

[~,~,x_next,Y_star,P_star,K_star,R_star] = model_solve_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target_ss,Par, mom, shock_firm, shock_agg, markup, markdown);
x_guess_steady_state = x_next;


% k_guess_until_ss = [K_hat(1:end-1);linspace(K_hat(end),K_star,year_converge)']; % Assume that it takes 100 years to converge
k_until_ss(1) = K_hat(1);
if numel(k_until_ss)<total_period
    error('solve_counterfactual_dynamics_A_j_fix:CapitalGuessTooShort',...
        'k_until_ss must contain at least %d elements.',total_period);
end
k_until_ss = k_until_ss(:);
tail_start = length(year_vec);
k_until_ss(tail_start:total_period) = linspace(...
    k_until_ss(tail_start),K_star,total_period-tail_start+1)';
k_until_ss = counterfactual_warm_value_or_default(...
    warm_start,'k_path',[],size(k_until_ss),k_until_ss);

E_t = [E_t;repmat(E_t(end),year_converge-1,1)];
p_vec_until_ss = zeros(total_period,1);
y_vec_until_ss = zeros(total_period,1);
r_vec_until_ss = zeros(total_period,1);
L_vec_until_ss = zeros(total_period,1);
phi_bar_vec = zeros(total_period,1);


x_guess_ss=cell(total_period,1);
for i=1:total_period
    if i<length(year_vec)
        x_guess_ss{i} = [x_guess_cell{i}(1:2*total_firm_vec(i)+2*num_sector);1];
    else
        x_guess_ss{i} = [x_guess_cell{end}(1:2*total_firm_vec(end)+2*num_sector);1];
    end
    x_guess_ss{i} = counterfactual_warm_value_or_default(...
        warm_start,'x_guess_transition',i,size(x_guess_ss{i}),x_guess_ss{i});
end

diff_outer=100;
iter_outer=0;
max_outer_iter=1000;
dmp_outer=0.025;
diff_outer_previous=Inf;
target_iterations_total=0;

while diff_outer>1e-2 && iter_outer<max_outer_iter
    iter_outer = iter_outer+1;
    fprintf('[fast:A_j:capital] iteration=%d solving %d periods...\n',...
        iter_outer,total_period);
    for i=1:total_period
        if iter_outer==1 && has_cached_A_j_levels
            if i<=length(year_vec)
                A_j_level_guess = A_j_level_mat(i,:)';
            else
                A_j_level_guess = A_j_level_mat(end,:)';
            end
        elseif iter_outer==1
            A_j_level_guess = ones(num_sector,1);
        elseif iter_outer>1 && i<=length(year_vec)
            A_j_level_guess = A_j_level_mat(i,:)';
        elseif iter_outer>1 && i>length(year_vec)
            A_j_level_guess = A_j_level_mat(end,:)';
        end
        if i<length(year_vec)
            year=i;
            year_next = i+1;
        else
            year=length(year_vec);
            year_next = length(year_vec);
        end

        current_cache = period_cache{year};
        mom = current_cache.mom;
        shock_firm = current_cache.shock_firm;
        shock_agg = current_cache.shock_agg;
        Par.alpha_j = current_cache.alpha_j;
        total_firm = current_cache.total_firm;

        expected_state_length = 2*total_firm+2*num_sector+1;
        x_guess = normalize_model_warm_start(...
            x_guess_ss{i},expected_state_length,...
            sprintf('A_j transition period %d',i));

        target_iter = 0;
        diff = 1;
        dmp=0.015;
        dmp_small = 0.025;
        diff_previous = Inf;
        A_j_level_target_ss = A_j_given(year,:)';

        if i>1 && i<=length(year_vec)
        while diff>1e-4 && target_iter<1e+3
            [diff,A_j_level_next,x_guess] = model_until_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target_ss, k_until_ss(i), Par, mom, shock_firm, shock_agg, markup, markdown);
            [dmp,~] = model_adapt_damping(...
                dmp,dmp,diff,diff_previous);
            A_j_level_guess = dmp*A_j_level_next+(1-dmp)*A_j_level_guess;
            diff_previous = diff;
            target_iter = target_iter+1;
            if mod(target_iter,25)==0
                fprintf(['[fast:A_j:target] capital_iter=%d period=%d/%d '...
                    'target_iter=%d residual=%.3e\n'],...
                    iter_outer,i,total_period,target_iter,diff);
            end
        end        
        [~,~,x_next,y_vec_until_ss(i),p_vec_until_ss(i),r_vec_until_ss(i),L_vec_until_ss(i)] =...
            model_until_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target_ss, k_until_ss(i) ,Par, mom, shock_firm, shock_agg, markup, markdown);
        A_j_level_mat(i,:) = A_j_level_guess';
        elseif i>length(year_vec)
            A_j_level_guess = A_j_level_mat(end,:)';
            % while diff > 1e-8 && iter<1e+3
                % [~,~,x_guess] = model_until_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target_ss, k_guess_until_ss(i), Par, mom, shock_firm, shock_agg, markup, markdown);
                % iter = iter+1;
            % end
            [~,~,x_next,y_vec_until_ss(i),p_vec_until_ss(i),r_vec_until_ss(i),L_vec_until_ss(i)] =...
                model_until_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target_ss, k_until_ss(i) ,Par, mom, shock_firm, shock_agg, markup, markdown);
        elseif i==1
            dmp = 0.05;
            while diff > 1e-8 && target_iter<1e+3
                x_next = model_until_ss(x_guess,k_until_ss(i),Par,...
                    mom,shock_firm,shock_agg,markup,markdown);
                diff = model_relative_residual(x_next,x_guess);
                [dmp,dmp_small] = model_adapt_damping(...
                    dmp,dmp_small,diff,diff_previous);
                x_guess = model_damped_update(x_next,x_guess,total_firm,...
                    dmp,dmp_small,'A_j initial transition');
                diff_previous = diff;
                target_iter = target_iter+1;
            end
            [~,y_vec_until_ss(i),p_vec_until_ss(i),r_vec_until_ss(i),L_vec_until_ss(i)] =...
            model_until_ss(x_guess, k_until_ss(i), Par,  mom, shock_firm, shock_agg, markup, markdown);
            A_j_level_mat(1,:) = ones(num_sector,1)';
        end
        target_iterations_total = target_iterations_total+target_iter;
        if target_iter==1e3
            warning('solve_counterfactual_dynamics_A_j_fix:TransitionTargetNoConvergence',...
                'The target solve reached its iteration limit in period %d.',i);
        end

        phi_bar_vec(i) = shock_agg.phi_bar;
        x_guess_ss{i} = x_next;
        if iter_outer==1 && i>=length(year_vec) && i<total_period
            x_guess_ss{i+1} = x_next;
        end
        if i==1 || i==length(year_vec) || i==total_period...
                || (i<length(year_vec) && mod(i,5)==0)...
                || (i>length(year_vec) && mod(i-length(year_vec),10)==0)
            display_year = year_vec(end)+max(0,i-length(year_vec));
            fprintf(['[fast:A_j:transition] capital_iter=%d period=%d/%d '...
                'year=%d target_iterations=%d residual=%.3e\n'],...
                iter_outer,i,total_period,display_year,target_iter,diff);
        end
    end
    % Get investment and consumption using K and E
    k_until_ss(total_period+1)=K_star;
    I_star = K_star*delta/E_star;
    C_star = Y_star-I_star;

    c_guess_until_ss = zeros(total_period,1);
    c_guess_until_ss(total_period) = C_star;

    % from EE
    for i=total_period-1:-1:1
        if i<length(year_vec)
            year=i;
            year_next = i+1;
        else
            year=length(year_vec);
            year_next = length(year_vec);
        end
        c_guess_until_ss(i) = 1/beta*E_t(i+1)/E_t(i)*(c_guess_until_ss(i+1)-phi_bar(year_next)*L_vec_until_ss(i+1)^(1+1/phi)/(1+1/phi) )...
                      /(E_t(i+1)*r_vec_until_ss(i+1)/p_vec_until_ss(i+1)+(1-delta))...
                      + phi_bar(year)*L_vec_until_ss(i)^(1+1/phi)/(1+1/phi);
        % c_guess_until_ss(i) = 1/beta*E_t(i+1)/E_t(i)*c_guess_until_ss(i+1)/(E_t(i+1)*r_vec_until_ss(i+1)/p_vec_until_ss(i+1)+(1-delta));
    end
    i_vec_until_ss = max(y_vec_until_ss - c_guess_until_ss,0);

    K_implied=zeros(total_period,1);
    K_implied(1)=K_hat(1);

    for i=1:total_period
        K_implied(i+1) = K_implied(i)*(1-delta) + i_vec_until_ss(i)*E_t(i);
    end

    diff_outer = max(abs(k_until_ss(1:total_period)-K_implied(1:total_period))...
        ./max(abs(k_until_ss(1:total_period)),eps));
    [dmp_outer,~] = model_adapt_damping(...
        dmp_outer,dmp_outer,diff_outer,diff_outer_previous);
    k_until_ss = (1-dmp_outer)*k_until_ss(1:total_period)...
        +dmp_outer*K_implied(1:total_period);
    diff_outer_previous = diff_outer;
    fprintf('[fast:A_j:capital] iteration=%d residual=%.3e damping=%.3f\n',...
        iter_outer,diff_outer,dmp_outer);
end
if iter_outer==max_outer_iter && diff_outer>1e-2
    warning('solve_counterfactual_dynamics_A_j_fix:CapitalPathNoConvergence',...
        'The capital-path iteration reached its limit.');
end

% Welfare
beta = 0.97;
discount_vec = beta.^(0:1:length(year_vec)-1);
welfare = discount_vec * log(c_guess_until_ss(1:length(year_vec))-phi_bar_vec(1:length(year_vec)).*L_vec_until_ss(1:length(year_vec)).^(1+1/phi)/(1+1/phi));

C_vec = c_guess_until_ss;
L_vec = L_vec_until_ss;
% Consumption equivalent welfare measure
f = @(lmd) discount_vec* log( (1+lmd)*C_base - phi_bar_vec(1:length(year_vec)).*(L_base).^(1+1/phi)/(1+1/phi)) ...
        - welfare; 
lmd = fsolve(f,0);
lmd = lmd*100;

%%
% Then, we run the solve_counterfactual; only difference is that we take
% K_implied as K_hat and calculate C differently.. + here, productivity
% shocks are different
K_hat = k_until_ss(1:length(year_vec));

intsh = data.intsh;
pop_data = data.pop_data;
balance = data.balance;
% fcons = data.fcons;
num_sector = data.num_sector;
secid_service = data.secid_service;
secid_full = data.secid_full;
secid_manu = data.secid_manu;
eta = Par.eta;
GO = data.GO;
alpha_j_mat = data.alpha_j_mat;
% top3_list_base = data.top3_list;

year_vec = (min(balance.year):1:max(balance.year))';

util_vec = zeros(length(year_vec),1);
Y_vec = zeros(length(year_vec),1);
L_vec = zeros(length(year_vec),1);
pop_vec = zeros(length(year_vec),1);
HHI_vec = zeros(length(year_vec),1);
def_test = zeros(length(year_vec),num_sector);
real_wage_vec = zeros(length(year_vec),1);
profit_vec = zeros(length(year_vec),1);
RER_vec = zeros(length(year_vec),1); 
P_vec = zeros(length(year_vec),1);
GDP_nominal_vec = zeros(length(year_vec),1);
P_j_H_mat = zeros(length(year_vec),num_sector);
R_vec = zeros(length(year_vec),1);
domar_weight = zeros(length(year_vec),num_sector);
pi_H_vec = zeros(length(year_vec),num_sector);
exsh_vec  = zeros(length(year_vec),num_sector); 
s_M_mat = zeros(length(year_vec),num_sector);
real_output_sector_hat_mat = zeros(length(year_vec),num_sector);
M_vec_hat_mat = zeros(length(year_vec),num_sector);
GDP_growth = zeros(length(year_vec),1);

L_j_mat = zeros(length(year_vec),num_sector);
K_j_mat = zeros(length(year_vec),num_sector); 

firm_num_mat = zeros(length(year_vec),num_sector);

% A_avg_sector = zeros(length(year_vec),num_sector);

phi_bar_vec = zeros(length(year_vec),1);
GDP_vec = zeros(length(year_vec),1);

phi = Par.phi;
Par.sigma = est_result.sigma;
Par.rho = Par.rho_base;
Par.gamma_L = est_result.gl;
Par.gamma_K = est_result.gk;
Par.gamma_M = est_result.gm;
gamma_j = est_result.gl + est_result.gk + est_result.gm;
observed_iterations_total = 0;
observed_iterations_max = 0;
x_guess_observed = cell(length(year_vec),1);

for i=1:length(year_vec)
        year=year_vec(i);
        fprintf('[fast:A_j:observed] solving year=%d (%d/%d)\n',...
            year,i,length(year_vec));
        current_cache = period_cache{i};
        mom = current_cache.mom;
        shock_firm = current_cache.shock_firm;
        shock_agg = current_cache.shock_agg;
        Par.alpha_j = current_cache.alpha_j;
        firm_num = mom.firm_num;
        firm_num_mat(i,:) = firm_num';
        total_firm = current_cache.total_firm;
        mom.K = K_hat(i);
        mom.L = L_base(i);
        A_j_level_guess = A_j_level_mat(i,:)';
        shock_firm.A_fj_vec(~shock_firm.top3_vec) = repelem(A_j_level_guess,[firm_num(secid_manu)-3 ...
            ;ones(num_sector-length(secid_manu),1)]).*shock_firm.A_fj_vec(~shock_firm.top3_vec);
        expected_state_length = 2*total_firm+2*num_sector+1;
        x_guess = normalize_model_warm_start(...
            x_guess_ss{i},expected_state_length,...
            sprintf('A_j observed year %d',year));
        x_guess = counterfactual_warm_value_or_default(...
            warm_start,'x_guess_observed',i,size(x_guess),x_guess);
        if i==1
            result_final = array2table(zeros(1,21), 'VariableNames',...
                {'firmid','p_d','y_d','p_x','y_x','p_m','m','A_fj','k','l','w_vec','tau_l','tau_k','mu_l','mu_y','DF','DF_real','R','year','secid','pi'});
            result_pre = [];
        end
        A_fj_vec = shock_firm.A_fj_vec;

        inner_iter = 0;
        diff = 10;
        dmp=0.05;
        dmp_small = 0.025;
        diff_previous = Inf;
        while diff > 1e-4 && inner_iter<1e+5
            x_next = model_given_shock(x_guess,Par,mom,shock_firm,...
                shock_agg,year,result_pre,0,markup,markdown);
            diff = model_relative_residual(x_next,x_guess);
            [dmp,dmp_small] = model_adapt_damping(...
                dmp,dmp_small,diff,diff_previous);
            x_guess = model_damped_update(x_next,x_guess,total_firm,...
                dmp,dmp_small,'A_j observed year');
            diff_previous = diff;
            inner_iter = inner_iter+1;
            if mod(inner_iter,inner_progress_interval)==0
                fprintf('[fast:A_j:observed] year=%d inner_iter=%d residual=%.3e\n',...
                    year,inner_iter,diff);
            end
        end
        if inner_iter==1e+5 && diff>1e-4
            warning('solve_counterfactual_dynamics_A_j_fix:ObservedYearNoConvergence',...
                'The observed-year solve reached its iteration limit in %d.',year);
        end
        observed_iterations_total = observed_iterations_total+inner_iter;
        observed_iterations_max = max(observed_iterations_max,inner_iter);
        fprintf('[fast:A_j:observed] year=%d iterations=%d residual=%.3e\n',...
            year,inner_iter,diff);


%         [x_next,norm_factor] = model_given_shock(x_guess, Par, mom, shock_firm, shock_agg, year, 0, markup, markdown);
%         x_next(1:total_firm) = x_next(1:total_firm) * norm_factor;
%         x_next(2*total_firm+1:2*total_firm + num_sector) = x_next(2*total_firm+1:2*total_firm + num_sector) * norm_factor;

        [x_next,norm_factor,P_j_F, phi_bar, GDP, sale_vec, to_append,util,real_wage,Y,L,P,...
            GDP_nominal,def,profit_sum,P_j_H,RER,result_next,R,tau_k_wtd_avg,tau_l_wtd_avg,pi_H,exsh,K_j,L_j] =...
            model_given_shock(x_next, Par, mom, shock_firm, shock_agg, year, result_pre, 1, markup, markdown);
        x_guess_observed{i} = x_next;
        result_final = [result_final;to_append];
        result_pre = result_next; % This contains previous period domar weight, etc.

        % p = x_next(1:total_firm); % price level
        % l_vec_share = x_next(total_firm+1:2*total_firm); % wage
        % E_j_vec = x_next( 2*total_firm+1:2*total_firm+num_sector); % E_j
        % h = x_next(end); % labor hour

        GDP_vec(i) = GDP;
        R_vec(i) = R;
        % if ~isreal(GDP)
        %     disp("GDP is imaginery number");
        %     break
        % end

        % P_j_F_vec(i,:) = P_j_F';
        % D_j_F_vec(i,:) = D_j_F';
        % phi_bar_vec(i) = phi_bar;
        % def_vec(i) = def;
        % total_firm_vec(i) = total_firm;
%         A_avg_vec(i) = wmean(A_fj_vec,sale_vec);
%         A_avg_vec(i) = mean(A_fj_vec);
        util_vec(i) = util;
        Y_vec(i) = Y;
        L_vec(i) = L;
        phi_bar_vec(i) = phi_bar;
        pop_vec(i) = mom.pop;
        P_vec(i) = P;
        GDP_nominal_vec(i) = GDP_nominal;
        def_test(i,:) = def';
        real_wage_vec(i) = real_wage;
        profit_vec(i) = profit_sum;
        P_j_H_mat(i,:)=P_j_H';
        RER_vec(i) = RER;
        s_M_mat(i,:) = result_next.s_M';
        domar_weight(i,:) = result_next.domar_weight';
        pi_H_vec(i,:) = pi_H;
        exsh_vec(i,:) = exsh;
        tau_k_wtd_avg_mat(i,:) = tau_k_wtd_avg';
        tau_l_wtd_avg_mat(i,:) = tau_l_wtd_avg';
        L_j_mat(i,:) = L_j;
        K_j_mat(i,:) = K_j;

        if i>1
            GDP_growth(i) = result_next.GDP_growth;
        end
        if i>1
            real_output_sector_hat_mat(i,:) = result_next.real_output_sector_hat';
            M_vec_hat_mat(i,:) = result_next.M_vec_hat';
        end
end

result_final.top3_prev = result.top3;



% Excluding fringe firms
result_final.sale = result_final.p_d.*result_final.y_d + result_final.p_x.*result_final.y_x;
result_final.export = result_final.p_x .* result_final.y_x;
result_final.sale_dom = result_final.sale - result_final.export;
result_final.sale_dom = result_final.p_d.*result_final.y_d;
result_final.wage_bill = result_final.w_vec.*result_final.l;
result_nofringe = result_final(result_final.firmid>0,:);
result_nofringe.minus_sale = -1*result_nofringe.sale;
result_nofringe = sortrows(result_nofringe, {'year','minus_sale'});  % Sort data by year, secid, and firmid 

%%
CR3_vec = zeros(length(year_vec),1);
CR3_vec_fix = zeros(length(year_vec),1);
CR3_sector = zeros(length(year_vec),length(secid_manu));
CR3_dom_sector = zeros(length(year_vec),length(secid_manu));

CR3_dom_vec = zeros(length(year_vec),1);
mu_l_others_sector = zeros(length(year_vec),length(secid_manu));
mu_y_others_sector = zeros(length(year_vec),length(secid_manu));
tau_l_top3_sector = zeros(length(year_vec),length(secid_manu));
tau_k_top3_sector = zeros(length(year_vec),length(secid_manu));
DF_top3_sector = zeros(length(year_vec),length(secid_manu));
A_top3_sector = zeros(length(year_vec),length(secid_manu));
A_avg_sector = zeros(length(year_vec),length(secid_manu));
DF_avg_sector = zeros(length(year_vec),length(secid_manu));
tau_l_std_sector = zeros(length(year_vec),length(secid_manu));
tau_k_std_sector = zeros(length(year_vec),length(secid_manu));
A_avg_all_sector = zeros(length(year_vec),length(secid_full));
A_avg_all_kill_variety = zeros(length(year_vec),length(secid_full));

mu_l_avg_all = zeros(length(year_vec),1);
mu_y_avg_all = zeros(length(year_vec),1);

tau_l_avg_top3 = zeros(length(year_vec),1);
tau_k_avg_top3 = zeros(length(year_vec),1);
tau_l_avg_others = zeros(length(year_vec),1);
tau_k_avg_others = zeros(length(year_vec),1);
A_avg_top3 = zeros(length(year_vec),1);
DF_avg_top3 = zeros(length(year_vec),1);
A_avg_others = zeros(length(year_vec),1);
DF_avg_others = zeros(length(year_vec),1);
mu_l_avg_top3 = zeros(length(year_vec),1);
mu_y_avg_top3 = zeros(length(year_vec),1);
mu_l_avg_others = zeros(length(year_vec),1);
mu_y_avg_others = zeros(length(year_vec),1);

tau_l_avg_top3_unweighted = zeros(length(year_vec),1);
tau_k_avg_top3_unweighted = zeros(length(year_vec),1);
tau_l_avg_others_unweighted = zeros(length(year_vec),1);
tau_k_avg_others_unweighted = zeros(length(year_vec),1);
A_avg_top3_unweighted = zeros(length(year_vec),1);
DF_avg_top3_unweighted = zeros(length(year_vec),1);
A_avg_others_unweighted = zeros(length(year_vec),1);
DF_avg_others_unweighted = zeros(length(year_vec),1);
mu_l_avg_top3_unweighted = zeros(length(year_vec),1);
mu_y_avg_top3_unweighted = zeros(length(year_vec),1);
mu_l_avg_others_unweighted = zeros(length(year_vec),1);
mu_y_avg_others_unweighted = zeros(length(year_vec),1);

A_avg_manu = zeros(length(year_vec),1);
A_avg_all = zeros(length(year_vec),1);
DF_avg_manu = zeros(length(year_vec),1);
DF_avg_all = zeros(length(year_vec),1);

DF_top3_avg_from_sector = zeros(length(year_vec),1);
A_top3_avg_from_sector = zeros(length(year_vec),1);
tau_l_top3_avg_from_sector = zeros(length(year_vec),1);
tau_k_top3_avg_from_sector = zeros(length(year_vec),1);

A_avg_from_all_sector = zeros(length(year_vec),1);
A_avg_from_sector = zeros(length(year_vec),1);
A_avg_from_sector_init_share = zeros(length(year_vec),1);
A_avg_from_sector_init_share_kill_variety = zeros(length(year_vec),1);
DF_avg_from_sector = zeros(length(year_vec),1);
tau_l_std_from_sector = zeros(length(year_vec),1);
tau_k_std_from_sector = zeros(length(year_vec),1);


A_top3 = zeros(length(year_vec),1);
A_others = zeros(length(year_vec),1);
A_others_sector = zeros(length(year_vec),length(secid_manu));
DF_top3 = zeros(length(year_vec),1);
DF_others = zeros(length(year_vec),1);
DF_others_sector = zeros(length(year_vec),num_sector);
pi_avg_sector = zeros(length(year_vec),num_sector);
HHI_sector = zeros(length(year_vec),num_sector); 
mu_y_agg_sector = zeros(length(year_vec),num_sector);
mu_y_top3_dom_sector = zeros(length(year_vec),num_sector);  % new
mu_y_top3_sector = zeros(length(year_vec),num_sector);  % new
mu_l_top3_sector = zeros(length(year_vec),num_sector);  % new
mu_y_agg_dom_sector = zeros(length(year_vec),num_sector);
mu_y_agg_dom_sector_nofringe = zeros(length(year_vec),num_sector);
mu_y_agg_dom_check = zeros(length(year_vec),num_sector);

mu_l_agg_sector = zeros(length(year_vec),num_sector);
A_j = zeros(length(year_vec),num_sector);
sale_sector = zeros(length(year_vec),num_sector);
wage_bill_sector = zeros(length(year_vec),num_sector);
pi_avg = zeros(length(year_vec),1);
pi_avg_unweighted = zeros(length(year_vec),1);
mu_y_agg = zeros(length(year_vec),1);
mu_y_agg_fixed_weight = zeros(length(year_vec),1); 
mu_y_dom_agg_top3_fixed_weight = zeros(length(year_vec),1); % new
mu_l_agg_top3 = zeros(length(year_vec),1); % new
mu_y_dom_agg_fixed_weight = zeros(length(year_vec),1);
mu_y_dom_agg = zeros(length(year_vec),1);
HHI_year = zeros(length(year_vec),1);
pi_H_year = zeros(length(year_vec),1);
mu_y_dom_agg_nofringe = zeros(length(year_vec),1);

mu_y_agg_top3 = zeros(length(year_vec),1);
mu_l_agg = zeros(length(year_vec),1);
A_agg = zeros(length(year_vec),1);
s_y_top3_avg = zeros(length(year_vec),1);
num_top = 3;
% num_sector = length(secid_manu);
% secid_top3_year = zeros (length(year_vec),num_top3*num_sector);
s_y_top3_year  = zeros (length(year_vec),num_top*length(secid_manu));
mu_y_top3_year = zeros(length(year_vec),num_top*length(secid_manu));
mu_y_dom_top3_year = zeros(length(year_vec),num_top*length(secid_manu)); 
mu_y_dom_agg_top3 = zeros(length(year_vec),1); % new
firmid_top3_year = zeros(length(year_vec),num_top*length(secid_manu));
export_year = zeros(length(year_vec),1);
dom_sale_year = zeros(length(year_vec),1);
top3_list = zeros(length(year_vec),num_top*length(secid_manu));
sale_sector_year = zeros(length(year_vec),num_sector);
GO_share = zeros(length(year_vec),length(secid_manu));
GO_all_share = zeros(length(year_vec),length(secid_full));
labor_supply_year = zeros(length(year_vec),1); 
sale_sector_share = zeros(length(year_vec),length(secid_manu));
CR3_check = zeros(length(year_vec),1);


% % Define top3 by 10 year rolling average
% result_final = sortrows(result_final,{'firmid','year'});
% for i=1:height(result_final)
%     result_final.sale_10yrs_avg(i) = mean(result_final.sale(result_final.firmid==result_final.firmid(i) & result_final.year<=result_final.year(i)+9 & result_final.year>=result_final.year(i)));
% end
% result_final.top3 = zeros(height(result_final),1);
% top3_list = zeros(length(year_vec),10);
% for i=1:length(year_vec)
%     result_final.minus_sale_10yrs_avg = -result_final.sale_10yrs_avg;
%     result_final.fringe = (result_final.firmid<0);
%     result_final.year_check=(result_final.year~=year_vec(i));
%     result_final = sortrows(result_final, {'year_check','fringe','minus_sale_10yrs_avg'});  
%     result_final.top3(1:10) = 1;
%     result_final = sortrows(result_final,{'firmid'});
%     top3_list(i,:) = result_final.firmid(result_final.top3==1 & result_final.year==year_vec(i))';
% end
% result_final = sortrows(result_final,{'year','secid','firmid'});

for i=1:length(year_vec)
    GO_share(i,:) = GO.GO(GO.year==year_vec(i) & ismember(GO.secid,secid_manu))...
        ./sum(GO.GO(GO.year==year_vec(i) & ismember(GO.secid,secid_manu)));

    GO_all_share(i,:) = GO.GO(GO.year==year_vec(i))./sum(GO.GO(GO.year==year_vec(i)));

    result_all = result_final(result_final.year==year_vec(i),:);
    result_all.minus_sale = -result_all.sale;
    result_all.fringe = (result_all.firmid<0);
    result_all.top3 = zeros(height(result_all),1);
    % Pick top3 3 firms for each sector-year
    for j=1:length(secid_manu)
        sale_sector_share(i,j) = sum(result_all.sale(result_all.secid==j))...
            ./sum(result_all.sale(ismember(result_all.secid,secid_manu)));
        result_all.secid_check = -1*(result_all.secid==j);
        result_all = sortrows(result_all, {'secid_check','fringe','minus_sale'});  
        result_all.top3(1:num_top) = 1;
        CR3_sector(i,j) = sum(result_all.sale(result_all.top3==1 & result_all.secid==j))...
            /sum(result_all.sale(result_all.secid==j));
        CR3_dom_sector(i,j) = sum(result_all.sale_dom(result_all.top3==1 & result_all.secid==j))...
            /sum(result_all.sale_dom(result_all.secid==j));
    end
    CR3_check(i) = GO_share(i,:)*CR3_sector(i,:)';

    result_top3 = result_all(result_all.top3==1,:);
    result_others = result_all(result_all.top3==0,:);

    % If want to fix top3 list in counterfactuals
    % result_all = result_final(result_final.year==year_vec(i),:);
    % result_all.top3 = ismember(result_all.firmid,top3_list_base(i,:));
    % result_top3 = result_all(result_all.top3==1,:);
    % result_others = result_all(result_all.top3==0,:);
    CR3_vec(i) =  sum(result_all.sale(result_all.top3==1)) ...
        / sum(result_all.sale(ismember(result_all.secid,secid_manu) ));
    CR3_vec_fix(i) =  sum(result_all.sale(result_all.top3_prev==1)) ...
        / sum(result_all.sale(ismember(result_all.secid,secid_manu) ));
    CR3_dom_vec(i) =  sum(result_all.sale_dom(result_all.top3==1)) ...
        / sum(result_all.sale_dom(ismember(result_all.secid,secid_manu) ));  
    dom_sale_year(i) = sum(result_all.p_d.*result_all.y_d)/P_vec(i);
    export_year(i) = sum(result_all.export)/P_vec(i);
    % A_top3(i) = wmean(result_top3.A_fj,result_top3.sale);
    % A_others(i) = wmean(result_others.A_fj,result_others.sale);
    % DF_top3(i) = wmean(result_top3.DF_real,result_top3.export);
    % DF_others(i) = wmean(result_others.DF_real,result_others.export);

    % A_top3(i) = mean(result_top3.A_fj);
    % A_others(i) = wmean(result_others.A_fj,result_others.sale);
    % DF_top3(i) = mean(result_top3.DF_real);
    % DF_others(i) = wmean(result_others.DF_real,result_others.export);

    mu_l_top3 = [];
    mu_y_top3 = [];
    mu_y_dom_top3 = [];
    tau_l_top3 = [];
    tau_k_top3 = [];
    A_top3 = [];
    DF_top3 = [];
    sale_top3 = [];
    s_y_top3 = [];
    secid_top3 = [];
    firmid_top3 = [];
    sigma = Par.sigma(1);
    firm_num = firm_num_mat(i,:)';
    for j=1:num_sector
        result_all = sortrows(result_all,{'secid','firmid'});
        sale_vec = result_all.sale(result_all.secid==j);
        sale_dom_vec = result_all.sale_dom(result_all.secid==j);
        wage_bill_vec = result_all.wage_bill(result_all.secid==j);
        export_vec = result_all.export(result_all.secid==j);
        tau_l_vec = result_all.tau_l(result_all.secid==j);
        tau_k_vec = result_all.tau_k(result_all.secid==j);
        a_fj_vec = result_all.A_fj(result_all.secid==j);
        y_d_vec = result_all.y_d(result_all.secid==j);
        y_x_vec = result_all.y_x(result_all.secid==j);
        DF_real_vec = result_all.DF_real(result_all.secid==j);
        top3_vec = (result_all.top3(result_all.secid==j)==1);
        s_y = sale_vec./sum(sale_vec);
        s_d = sale_dom_vec./sum(sale_dom_vec);
        sale_vec_nofringe = result_all.sale_dom(result_all.secid==j & result_all.firmid>0);
        s_y_nofringe = sale_vec_nofringe./sum(sale_dom_vec);
        HHI_sector(i,j) = sum(s_y_nofringe.^2);

        % s_y_dom = sale_dom_vec./ sum(sale_dom_vec);
        s_l = wage_bill_vec./sum(wage_bill_vec);
        mu_y_vec = result_all.mu_y(result_all.secid==j);
        mu_l_vec = result_all.mu_l(result_all.secid==j);
        mu_y_tilde = mu_y_vec.*(y_d_vec./(y_d_vec+y_x_vec))...
            + Par.sigma(j)./(Par.sigma(j)-1)* (y_x_vec./(y_d_vec+y_x_vec));
        mu_y_tilde_top3 = mu_y_tilde(top3_vec);        % mu_y_tilde = mu_y_vec;
        pi_vec = result_all.pi(result_all.secid==j & result_all.top3_prev==0 & result_all.firmid>0);
        pi_avg_sector(i,j) = mean(pi_vec);

        mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
        mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
        % mu_y_agg_dom_check2(i,j) = sum(mu_y_vec.*s_d);
        mu_y_agg_dom_check(i,j) = Par.sigma(j)/(Par.sigma(j)-1)...
            / (1-(1-(Par.sigma(j)/(Par.sigma(j)-1)) / (Par.rho(j)/(Par.rho(j)-1))*(1-pi_H_vec(1,j)) )*HHI_sector(i,j) );

        mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
        % mu_l_tilde = mu_y_tilde.*mu_l_vec./mu_y_agg_sector(i,j);
        % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
        mu_l_agg_sector(i,j) =  1/sum(1./(mu_y_tilde.*mu_l_vec).*s_y) / mu_y_agg_sector(i,j);
        mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );

        % mu_y_dom_top3_temp = mu_y_vec(result_all.top3(result_all.secid==j)==1);
        % mu_y_top3_temp = mu_y_tilde(result_all.top3(result_all.secid==j)==1) ;
        % mu_l_top3_temp = mu_l_vec(result_all.top3(result_all.secid==j)==1) ;
        mu_y_top3_temp = mu_y_tilde(result_all.top3(result_all.secid==j)==1) ./ mu_y_agg_sector_others;
        mu_l_top3_temp = mu_l_vec(result_all.top3(result_all.secid==j)==1) ./ mu_l_agg_sector_others;
        sale_top3_temp = sale_vec(result_all.top3(result_all.secid==j)==1);
        s_y_top3_temp = sale_dom_vec(result_all.top3(result_all.secid==j)==1) / sum(sale_dom_vec);

        sale_sector(i,j) = sum(result_all.sale(result_all.secid==j) );
        wage_bill_sector(i,j) = sum(result_all.wage_bill(result_all.secid==j) );
        mrpl_tilde = mu_y_tilde.*tau_l_vec.*mu_l_vec.*(s_l.^(1/(Par.eta+1)));
        mrpk_tilde = mu_y_tilde.*tau_k_vec;
        mrpm_tilde = mu_y_tilde;
        tfpr = sale_vec.^(1-gamma_j(j)).* ( mrpl_tilde ).^(Par.gamma_L(j))...
                    .*( (mrpk_tilde).^(Par.gamma_K(j)) ).*( (mrpm_tilde).^(Par.gamma_M(j)) );
        MRPL_tilde = (firm_num(j)^(1/eta)*sum( (s_y./ mrpl_tilde).^((eta+1)/eta) ) )^(-eta/(eta+1));
        MRPK_tilde = sum(s_y./ mrpk_tilde)^(-1);
        MRPM_tilde = sum(s_y./mrpm_tilde)^(-1);
        phi_vec = (1+DF_real_vec).^(sigma/(sigma-1)-gamma_j(j)) ./ ((1+DF_real_vec).^(1-gamma_j(j)));
        Phi_vec = (wmean(phi_vec.^(1-sigma),sale_vec)).^(1/(1-sigma));
        prod_villain_vec = ...
            (Par.gamma_L(j).*(MRPL_tilde./mrpl_tilde)+Par.gamma_K(j).*(MRPK_tilde./mrpk_tilde)+Par.gamma_M(j).*(MRPM_tilde./mrpm_tilde))./(sigma/(sigma-1)*(1+((phi_vec./Phi_vec).^(1-sigma)-1)/sigma ) );
        result_final.prod_villain_vec(result_final.secid==j & result_final.year==year_vec(i)) = prod_villain_vec;
        wedge_villain_vec = ...
            (Par.gamma_L(j).*(MRPL_tilde./mrpl_tilde)+Par.gamma_K(j).*(MRPK_tilde./mrpk_tilde)+Par.gamma_M(j).*(MRPM_tilde./mrpm_tilde))./((gamma_j(j)-1)*(1-(phi_vec./Phi_vec).^(1-sigma))+gamma_j(j) );
        result_final.wedge_villain_vec(result_final.secid==j & result_final.year==year_vec(i)) = wedge_villain_vec;
        TFPR_bar = sum(sale_vec)^(1-gamma_j(j)) *MRPL_tilde^(Par.gamma_L(j))...
                             * MRPK_tilde^(Par.gamma_K(j))*MRPM_tilde^(Par.gamma_M(j));
        A_j(i,j) = (sum( (a_fj_vec.*TFPR_bar./tfpr).^(Par.sigma(j)-1) )/firm_num(j) )^(1/(Par.sigma(j)-1));

        mu_l_others_sector(i,j) = wmean(result_others.mu_l(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        % mu_l_top3_temp = result_top3.mu_l(result_top3.secid==j) / mu_l_agg_sector(i,j);
        mu_l_top3 = [mu_l_top3;mu_l_top3_temp];
        mu_y_others_sector(i,j) = wmean(result_others.mu_y(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        mu_y_dom_top3_temp = result_top3.mu_y(result_top3.secid==j) / mu_y_others_sector(i,j);
        mu_y_top3 = [mu_y_top3;mu_y_top3_temp];
        mu_y_dom_top3 = [mu_y_dom_top3;mu_y_dom_top3_temp];

        sale_top3 = [sale_top3; sale_top3_temp];
        s_y_top3 = [s_y_top3; s_y_top3_temp];
        tau_l_top3_temp = result_top3.tau_l(result_top3.secid==j);
        tau_l_top3 = [tau_l_top3;tau_l_top3_temp];

        tau_k_top3_temp = result_top3.tau_k(result_top3.secid==j);
        tau_k_top3 = [tau_k_top3;tau_k_top3_temp];
        A_others_sector(i,j) = wmean(result_others.A_fj(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        A_top3_temp = result_top3.A_fj(result_top3.secid==j) / A_others_sector(i,j);
        A_top3 = [A_top3;A_top3_temp];
        DF_others_sector(i,j) = wmean(result_others.DF_real(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        DF_top3_temp = result_top3.DF_real(result_top3.secid==j) / DF_others_sector(i,j);
        DF_top3 = [DF_top3;DF_top3_temp];
        secid_top3 = [secid_top3;j*ones(length(DF_top3_temp),1)];
        firmid_top3 = [firmid_top3;result_all.firmid(result_all.top3==1 & result_all.secid==j)];
        sale_sector_year(i,j) = sum( result_all.sale(result_all.secid==j) );
        if ismember(j,secid_manu)
            tau_l_top3_sector(i,j) = mean(result_top3.tau_l(result_top3.secid==j))...
            ./mean(result_others.tau_l(result_others.secid==j & result_others.firmid>0));
            tau_k_top3_sector(i,j) = mean(result_top3.tau_k(result_top3.secid==j))...
            ./mean(result_others.tau_k(result_others.secid==j & result_others.firmid>0));
            DF_top3_sector(i,j) = mean(result_top3.DF(result_top3.secid==j))...
            ./mean(result_others.DF(result_others.secid==j & result_others.firmid>0));
            A_top3_sector(i,j) = mean(result_top3.A_fj(result_top3.secid==j))...
            ./mean(result_others.A_fj(result_others.secid==j & result_others.firmid>0));
            A_avg_sector(i,j) = wmean(result_all.A_fj(result_all.secid==j),result_all.sale(result_all.secid==j));
            DF_avg_sector(i,j) = mean(result_all.DF_real(result_all.secid==j));
            tau_l_std_sector(i,j) = std(log(result_all.tau_l(result_all.secid==j)));
            tau_k_std_sector(i,j) = std(log(result_all.tau_k(result_all.secid==j)));
            mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
            mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
            mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
            mu_y_vec_nofringe = result_all.mu_y(result_all.secid==j & result_all.firmid>0 );
            mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);
        end
        A_avg_all_sector(i,j) = wmean(result_all.A_fj(result_all.secid==j),result_all.sale(result_all.secid==j));
        DF_avg_all_sector(i,j) = mean(result_all.DF_real(result_all.secid==j));
        A_avg_all_kill_variety(i,j) = (1/firm_num(j))^(1/(Par.sigma(j)-1))*wmean(result_all.A_fj(result_all.secid==j),result_all.sale(result_all.secid==j));
    end
    tau_k_avg_top3(i) = wmean(result_top3.tau_k,result_top3.sale);
    tau_k_avg_others(i) = wmean(result_others.tau_k(result_others.firmid>0),result_others.sale(result_others.firmid>0));
    tau_l_avg_top3(i) = wmean(result_top3.tau_l,result_top3.sale);
    tau_l_avg_others(i) = wmean(result_others.tau_l(result_others.firmid>0),result_others.sale(result_others.firmid>0));
    A_avg_top3(i) = wmean(result_top3.A_fj,result_top3.sale);
    A_avg_others(i) = wmean(result_others.A_fj(result_others.firmid>0),result_others.sale(result_others.firmid>0));
    A_avg_manu(i) = wmean(result_all.A_fj(ismember(result_all.secid,secid_manu)),result_all.sale(ismember(result_all.secid,secid_manu)));
    A_avg_all(i) = wmean(result_all.A_fj,result_all.sale);


    DF_avg_top3(i) = wmean(result_top3.DF_real,result_top3.export  );
    DF_avg_others(i) = wmean(result_others.DF_real(result_others.firmid>0),result_others.export(result_others.firmid>0));
    DF_avg_manu(i) = wmean(result_all.DF_real(ismember(result_all.secid,secid_manu)),result_all.export(ismember(result_all.secid,secid_manu)));
    DF_avg_all(i) = wmean(result_all.DF_real,result_all.export);

    mu_l_avg_top3(i) = wmean(result_top3.mu_l,result_top3.sale);
    mu_l_avg_others(i) = wmean(result_others.mu_l(result_others.firmid>0),result_others.sale(result_others.firmid>0));
    mu_y_avg_top3(i) = wmean(result_top3.mu_y,result_top3.sale);
    mu_y_avg_others(i) = wmean(result_others.mu_y(result_others.firmid>0),result_others.sale(result_others.firmid>0));

    tau_k_avg_top3_unweighted(i) = mean(result_top3.tau_k);
    tau_k_avg_others_unweighted(i) = mean(result_others.tau_k(result_others.firmid>0));
    tau_l_avg_top3_unweighted(i) = mean(result_top3.tau_l);
    tau_l_avg_others_unweighted(i) = mean(result_others.tau_l(result_others.firmid>0));
    A_avg_top3_unweighted(i) = mean(result_top3.A_fj);
    A_avg_others_unweighted(i) = mean(result_others.A_fj(result_others.firmid>0));
    DF_avg_top3_unweighted(i) = mean(result_top3.DF(result_top3.DF>0) );
    DF_avg_others_unweighted(i) = mean(result_others.DF(result_others.firmid>0 & result_others.DF>0));
    % mu_l_avg_top3_unweighted(i) = mean(result_top3.mu_l);
    mu_l_avg_top3_unweighted(i) = mean(result_all.mu_l(result_all.top3==1));
    mu_l_avg_others_unweighted(i) = mean(result_others.mu_l(result_others.firmid>0));
    % mu_y_avg_top3_unweighted(i) = mean(result_top3.mu_y);
    mu_y_avg_top3_unweighted(i) = mean(result_all.mu_y(result_all.top3==1));
    mu_y_avg_others_unweighted(i) = mean(result_others.mu_y(result_others.firmid>0));


    mu_l_avg_all(i) = wmean(result_all.mu_l,result_all.sale);
    mu_y_avg_all(i) = wmean(result_all.mu_y,result_all.sale);
    if i==1
        pi_avg(i) = wmean( pi_avg_sector(i,secid_manu),domar_weight(1,secid_manu) );
        mu_y_agg(i) = wmean( (mu_y_agg_sector(i,:)).^(-1),domar_weight(1,:))^(-1);
        mu_y_dom_agg(i) = wmean( (mu_y_agg_dom_sector(i,:)).^(-1),domar_weight(1,:))^(-1);
        mu_y_dom_agg_check_vec(i) = wmean( (mu_y_agg_dom_sector(i,:)).^(-1),domar_weight(1,:))^(-1);
        HHI_year(i) = wmean(HHI_sector(i,:),domar_weight(1,:));
        pi_H_year(i) = wmean(pi_H_vec(i,:),domar_weight(1,:)); 
        mu_y_dom_agg_nofringe(i) = wmean( (mu_y_agg_dom_sector_nofringe(i,secid_manu)).^(-1),domar_weight(1,secid_manu))^(-1);
        mu_y_agg_top3(i) = wmean( (mu_y_top3_sector(i,secid_manu)).^(-1),domar_weight(1,secid_manu))^(-1); % new
        mu_y_dom_agg_top3(i) = wmean( (mu_y_top3_dom_sector(i,secid_manu)).^(-1),domar_weight(1,secid_manu))^(-1); % new
        mu_l_agg_top3(i) = wmean( (mu_l_top3_sector(i,secid_manu).*mu_y_agg_sector(i,secid_manu)).^(-1),domar_weight(1,secid_manu))^(-1) / mu_y_agg(i);
        mu_l_agg(i) = wmean( (mu_l_agg_sector(i,:).*mu_y_agg_sector(i,:)).^(-1),domar_weight(1,:))^(-1) / mu_y_agg(i);
        A_agg(i) = sum(A_j(i,:).*domar_weight(1,:));
        % A_agg(i) = wmean(A_j(i,:),sale_sector_year(1,:));
    else
        pi_avg(i) = wmean( pi_avg_sector(i,secid_manu),domar_weight(i-1,secid_manu) );
        mu_y_agg(i) = wmean( (mu_y_agg_sector(i,:)).^(-1),domar_weight(i-1,:))^(-1);
        mu_y_dom_agg(i) = wmean( (mu_y_agg_dom_sector(i,:)).^(-1),domar_weight(i-1,:))^(-1);
        mu_y_dom_agg_check_vec(i) = wmean( (mu_y_agg_dom_sector(i,:)).^(-1),domar_weight(1,:))^(-1);
        HHI_year(i) = wmean(HHI_sector(i,:),domar_weight(i-1,:));
        pi_H_year(i) = wmean(pi_H_vec(i,:),domar_weight(i-1,:)); 
        mu_y_dom_agg_nofringe(i) = wmean( (mu_y_agg_dom_sector_nofringe(i,secid_manu)).^(-1),domar_weight(i-1,secid_manu))^(-1);
        mu_y_agg_top3(i) = wmean( (mu_y_top3_sector(i,secid_manu)).^(-1),domar_weight(i-1,secid_manu))^(-1); % new
        mu_y_dom_agg_top3(i) = wmean( (mu_y_top3_dom_sector(i,secid_manu)).^(-1),domar_weight(i-1,secid_manu))^(-1); % new
        mu_l_agg_top3(i) = wmean( (mu_l_top3_sector(i,secid_manu).*mu_y_agg_sector(i,secid_manu)).^(-1),domar_weight(i-1,secid_manu))^(-1) / mu_y_agg(i);
        mu_l_agg(i) = wmean( (mu_l_agg_sector(i,:).*mu_y_agg_sector(i,:)).^(-1),domar_weight(i-1,:))^(-1) / mu_y_agg(i);
        A_agg(i) = sum(A_j(i,:).*domar_weight(i-1,:));
        % A_agg(i) = wmean(A_j(i,:),sale_sector_year(i-1,:));
    end
    pi_avg_unweighted(i) = mean(result_all.pi(result_all.top3_prev==0));
    DF_top3_avg_from_sector(i) = wmean(DF_top3_sector(i,:),GO_share(i,:));
    A_top3_avg_from_sector(i) = wmean(A_top3_sector(i,:),GO_share(i,:));
    tau_l_top3_avg_from_sector(i) = wmean(tau_l_top3_sector(i,:),GO_share(i,:));
    tau_k_top3_avg_from_sector(i) = wmean(tau_k_top3_sector(i,:),GO_share(i,:));
    A_avg_from_all_sector(i) = wmean(A_avg_all_sector(i,:),GO_all_share(i,:));
    A_avg_from_sector(i) = wmean(A_avg_sector(i,:),GO_share(i,:));
    DF_avg_from_sector(i) = wmean(DF_avg_sector(i,:),GO_share(i,:));
    tau_l_std_from_sector(i) = wmean(tau_l_std_sector(i,:),GO_share(i,:));
    tau_k_std_from_sector(i) = wmean(tau_k_std_sector(i,:),GO_share(i,:));
    s_y_top3_avg(i) = mean(s_y_top3);
    % secid_top3_year(i,:) = secid_top3';
    s_y_top3_year(i,:) = s_y_top3';
    mu_y_top3_year(i,:) = mu_y_top3';
    mu_y_dom_top3_year(i,:) = mu_y_dom_top3';
    firmid_top3_year(i,:) = firmid_top3';
    result_all=sortrows(result_all,'firmid');
    top3_list(i,:) = result_all.firmid(result_all.top3==1)';
    labor_supply_year(i) = sum(result_all.l);
end
%%
agg_result.CR10_vec = CR3_vec;
agg_result.CR10_dom_vec = CR3_dom_vec;
% agg_result.CR10_vec_hyundai = CR10_vec_hyundai;
% agg_result.CR10_vec_sk = CR10_vec_sk;
agg_result.mu_l_others_sector = mu_l_others_sector;
agg_result.mu_y_others_sector = mu_y_others_sector ;

agg_result.tau_l_avg_top3 = tau_l_avg_top3;
agg_result.tau_k_avg_top3 = tau_k_avg_top3;
agg_result.tau_l_avg_others = tau_l_avg_others;
agg_result.tau_k_avg_others = tau_k_avg_others;
agg_result.A_top3 = A_avg_top3;
agg_result.A_others = A_avg_others;
agg_result.DF_top3 = DF_avg_top3;
agg_result.DF_others = DF_avg_others;
agg_result.mu_l_avg_top3 = mu_l_avg_top3;
agg_result.mu_y_avg_top3 = mu_y_avg_top3;
agg_result.mu_l_avg_others = mu_l_avg_others;
agg_result.mu_y_avg_others = mu_y_avg_others;

agg_result.tau_l_avg_top3_unweighted = tau_l_avg_top3_unweighted;
agg_result.tau_k_avg_top3_unweighted = tau_k_avg_top3_unweighted;
agg_result.tau_l_avg_others_unweighted = tau_l_avg_others_unweighted;
agg_result.tau_k_avg_others_unweighted = tau_k_avg_others_unweighted;
agg_result.A_top3_unweighted = A_avg_top3_unweighted;
agg_result.A_others_unweighted = A_avg_others_unweighted;
agg_result.DF_top3_unweighted = DF_avg_top3_unweighted;
agg_result.DF_others_unweighted = DF_avg_others_unweighted;
agg_result.mu_l_avg_top3_unweighted = mu_l_avg_top3_unweighted;
agg_result.mu_y_avg_top3_unweighted = mu_y_avg_top3_unweighted;
agg_result.mu_l_avg_others_unweighted = mu_l_avg_others_unweighted;
agg_result.mu_y_avg_others_unweighted = mu_y_avg_others_unweighted;

agg_result.A_top3_avg_from_sector=A_top3_avg_from_sector;
agg_result.DF_top3_avg_from_sector=DF_top3_avg_from_sector;
agg_result.tau_l_top3_avg_from_sector=tau_l_top3_avg_from_sector;
agg_result.tau_k_top3_avg_from_sector=tau_k_top3_avg_from_sector;
agg_result.A_avg_from_all_sector = A_avg_from_all_sector;
agg_result.A_avg_from_sector=A_avg_from_sector;
agg_result.A_avg_from_sector_init_share=A_avg_from_sector_init_share;
agg_result.A_avg_from_sector_init_share_kill_variety=A_avg_from_sector_init_share_kill_variety;

agg_result.DF_avg_from_sector=DF_avg_from_sector;
agg_result.tau_l_std_from_sector=tau_l_std_from_sector;
agg_result.tau_k_std_from_sector=tau_k_std_from_sector;

agg_result.pi_avg = pi_avg;
agg_result.pi_avg_unweighted = pi_avg_unweighted;
agg_result.mu_l_avg_all = mu_l_avg_all;
agg_result.mu_y_avg_all = mu_y_avg_all;
agg_result.mu_y_agg = mu_y_agg;
agg_result.mu_y_agg_fixed_weight = mu_y_agg_fixed_weight;
agg_result.mu_y_dom_agg_fixed_weight = mu_y_dom_agg_fixed_weight;
agg_result.mu_y_dom_agg = mu_y_dom_agg;
agg_result.mu_y_dom_agg_nofringe = mu_y_dom_agg_nofringe;
agg_result.mu_y_dom_agg_top3 = mu_y_dom_agg_top3; % new
agg_result.mu_y_dom_agg_top3_fixed_weight = mu_y_dom_agg_top3_fixed_weight; % new
agg_result.mu_l_agg_top3 = mu_l_agg_top3; % new 
agg_result.mu_y_agg_top3 = mu_y_agg_top3;

agg_result.mu_l_agg = mu_l_agg;
agg_result.A_agg = A_agg;
agg_result.export_year = export_year;
agg_result.dom_sale_year = dom_sale_year;
agg_result.real_wage_vec = real_wage_vec;
agg_result.top3_list = top3_list;
agg_result.sale_sector_year = sale_sector_year;
agg_result.RER_vec = RER_vec;
agg_result.Y_vec = Y_vec;
agg_result.L_vec = L_vec;
agg_result.R_vec = R_vec;
agg_result.CR3_check = CR3_check;
agg_result.A_avg_manu = A_avg_manu;
agg_result.A_avg_all = A_avg_all;
agg_result.DF_avg_manu = DF_avg_manu;
agg_result.DF_avg_all = DF_avg_all;
agg_result.labor_supply = labor_supply_year;
agg_result.domar_weight = domar_weight;
agg_result.s_M = s_M_mat;
agg_result.pi_avg_sector = pi_avg_sector;

agg_result.pi_H_vec = pi_H_vec;
agg_result.exsh_vec = exsh_vec;

agg_result.tau_k_wtd_avg_mat = tau_k_wtd_avg_mat;
agg_result.tau_l_wtd_avg_mat = tau_l_wtd_avg_mat;

agg_result.mu_y_agg_dom_sector = mu_y_agg_dom_sector;
agg_result.HHI_sector = HHI_sector;
agg_result.mu_y_agg_dom_sector_nofringe = mu_y_agg_dom_sector_nofringe;
agg_result.HHI_year = HHI_year;
agg_result.pi_H_year = pi_H_year;

agg_result.A_j = A_j;
agg_result.K_j_mat = K_j_mat;
agg_result.L_j_mat = L_j_mat;

agg_result.CR3_vec_fix = CR3_vec_fix;
agg_result.A_j_level_mat = A_j_level_mat;
agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
agg_result.fast_stats.steady_target_iterations = steady_target_iterations;
agg_result.fast_stats.capital_path_iterations = iter_outer;
agg_result.fast_stats.capital_path_residual = diff_outer;
agg_result.fast_stats.target_iterations_total = target_iterations_total;
agg_result.fast_stats.observed_iterations_total = observed_iterations_total;
agg_result.fast_stats.observed_iterations_max = observed_iterations_max;
warm = struct();
warm.x_guess_steady_state = x_guess_steady_state;
warm.x_guess_transition = x_guess_ss;
warm.k_path = k_until_ss;
warm.A_j_level_steady_state = A_j_level_mat(end,:)';
warm.A_j_level_mat = A_j_level_mat;
warm.x_guess_observed = x_guess_observed;
fprintf('[fast:A_j] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
    agg_result.fast_stats.elapsed_seconds,lmd);

