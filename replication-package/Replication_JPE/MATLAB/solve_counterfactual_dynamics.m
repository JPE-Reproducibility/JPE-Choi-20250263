function [lmd,CR3_vec,GDP_vec,k_until_ss,C_vec,L_vec,agg_result,result_final,warm]...
    = solve_counterfactual_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,E_t,C_base,L_base,k_until_ss,warm_start)
% Faster version of solve_counterfactual_dynamics.
% It preserves the model equations while caching period data and static
% model objects, warm-starting the terminal path, and adapting damping.
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

Par.sigma = est_result.sigma;
Par.rho = Par.rho_base;
Par.gamma_L = est_result.gl;
Par.gamma_K = est_result.gk;
Par.gamma_M = est_result.gm;

E_star = E_t(end); % Average value of E_t from t=1,... 38 (This is not affected by convergence part)
r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state

%% Cache all objects that are fixed within a calendar year.
fprintf('[fast] Building period caches for %d observed years...\n',length(year_vec));
period_cache = cell(length(year_vec),1);
total_firm_vec = zeros(length(year_vec),1);
for i=1:length(year_vec)
    period_cache{i} = build_period_cache(...
        i,year_vec,balance,result,intsh,pop_data,secid_full,secid_service,...
        secid_manu,result_agg,hour_data,alpha_j_mat,Par);
    total_firm_vec(i) = period_cache{i}.total_firm;
end
warm_is_compatible = counterfactual_warm_is_compatible(...
    warm_start,year_vec,secid_full,period_cache,markup,markdown);
if warm_is_compatible
    fprintf('[fast] Using structurally compatible counterfactual warm start.\n');
end

terminal_cache = period_cache{end};
fprintf('[fast] Period caches ready. Solving counterfactual steady state...\n');
mom = terminal_cache.mom;
shock_firm = terminal_cache.shock_firm;
shock_agg = terminal_cache.shock_agg;
Par.alpha_j = terminal_cache.alpha_j;

x_guess_year = x_guess_cell{end};
x_guess = [x_guess_year(1:2*total_firm_vec(end)+2*num_sector);1];
if warm_is_compatible
    x_guess = counterfactual_warm_state_or_default(...
        warm_start,'x_guess_steady_state',[],numel(x_guess),x_guess);
end

shock_agg.r_over_p = r_over_p;
phi_bar = result_agg.phi_bar_vec;

year_converge=100;
total_period = length(year_vec)-1+year_converge;
A_j_entire = zeros(total_period+1,num_sector);

% Solve steady state
iter = 0;
diff = 1;
dmp=0.05;
dmp_small = 0.025;
diff_previous = Inf;

while diff > 1e-4 && iter<1e+5
    [x_next,Y_star,P_star,K_star,R_star,L_star,tau_k_wtd_avg_ss,tau_l_wtd_avg_ss,A_j_ss] = model_solve_ss(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff = relative_residual(x_next,x_guess);
    [dmp,dmp_small] = adapt_damping(dmp,dmp_small,diff,diff_previous);
    x_guess = [x_next(1:total_firm_vec(end)).*dmp_small+x_guess(1:total_firm_vec(end)).*(1-dmp_small);...
               x_next(total_firm_vec(end)+1:end).*dmp+x_guess(total_firm_vec(end)+1:end).*(1-dmp) ];
    diff_previous = diff;
    iter = iter+1;
    if mod(iter,inner_progress_interval)==0
        fprintf('[fast:ss] iteration=%d residual=%.3e damping=(%.3f, %.3f)\n',...
            iter,diff,dmp,dmp_small);
    end
end
fprintf('[fast:ss] converged=%d iterations=%d residual=%.3e K*=%.6g\n',...
    diff<=1e-4,iter,diff,K_star);
if iter==1e+5
    warning('solve_counterfactual_dynamics:SteadyStateNoConvergence',...
        'Steady-state iteration reached the maximum iteration count.');
end
x_guess_steady_state = x_next;

A_j_entire(end,:) = A_j_ss';

if numel(k_until_ss)<total_period
    error('solve_counterfactual_dynamics:CapitalGuessTooShort',...
        'k_until_ss must contain at least %d elements.',total_period);
end
k_until_ss = k_until_ss(:);
tail_start = length(year_vec);
k_until_ss(tail_start:total_period) = linspace(...
    k_until_ss(tail_start),K_star,total_period-tail_start+1)';
if warm_is_compatible
    k_until_ss = counterfactual_warm_vector_or_default(...
        warm_start,'k_path',total_period,k_until_ss);
end

E_t = [E_t;repmat(E_t(end),year_converge-1,1)];
p_vec_until_ss = zeros(total_period,1);
y_vec_until_ss = zeros(total_period,1);
r_vec_until_ss = zeros(total_period,1);
L_vec_until_ss = zeros(total_period,1);
phi_bar_vec = zeros(total_period,1);
tau_k_wtd_avg_mat = zeros(total_period,num_sector);
tau_l_wtd_avg_mat = zeros(total_period,num_sector);

x_guess_ss=cell(total_period,1);
for i=1:total_period
    if i<length(year_vec)
        x_guess_ss{i} = [x_guess_cell{i}(1:2*total_firm_vec(i)+2*num_sector);1];
    else
        x_guess_ss{i} = [x_guess_cell{end}(1:2*total_firm_vec(end)+2*num_sector);1];
    end
    if warm_is_compatible
        x_guess_ss{i} = counterfactual_warm_state_or_default(...
            warm_start,'x_guess_transition',i,numel(x_guess_ss{i}),x_guess_ss{i});
    end
end

diff_outer=100;
outer_iter=0;
max_outer_iter=1000;
dmp_outer=0.025;
diff_outer_previous=Inf;
transition_iterations_total=0;
transition_iterations_max=0;

while diff_outer>1e-2 && outer_iter<max_outer_iter
    outer_iter = outer_iter+1;
    fprintf('[fast:capital] iteration=%d solving %d transition periods...\n',...
        outer_iter,total_period);
    for i=1:total_period
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

        x_guess = x_guess_ss{i};

        inner_iter = 0;
        diff = 1;
        dmp=0.05;
        dmp_small = 0.025;
        diff_previous = Inf;
        while diff > 1e-4 && inner_iter<1e+5
            x_next = model_until_ss(x_guess, k_until_ss(i), Par, mom, shock_firm, shock_agg, markup,markdown);
            diff = relative_residual(x_next,x_guess);
            [dmp,dmp_small] = adapt_damping(dmp,dmp_small,diff,diff_previous);
            x_guess = [x_next(1:total_firm).*dmp_small+x_guess(1:total_firm).*(1-dmp_small);...
                       x_next(total_firm+1:end).*dmp+x_guess(total_firm+1:end).*(1-dmp) ];
            diff_previous = diff;
            inner_iter = inner_iter+1;
            if mod(inner_iter,inner_progress_interval)==0
                display_year = year_vec(end)+max(0,i-length(year_vec));
                fprintf(['[fast:transition] capital_iter=%d period=%d/%d '...
                    'year=%d inner_iter=%d residual=%.3e\n'],...
                    outer_iter,i,total_period,display_year,inner_iter,diff);
            end
        end
        if inner_iter==1e+5
            warning('solve_counterfactual_dynamics:TransitionNoConvergence',...
                'Transition solve reached its iteration limit in period %d.',i);
        end
        transition_iterations_total = transition_iterations_total+inner_iter;
        transition_iterations_max = max(transition_iterations_max,inner_iter);
        if i==1 || i==length(year_vec) || i==total_period...
                || (i<length(year_vec) && mod(i,5)==0)...
                || (i>length(year_vec) && mod(i-length(year_vec),10)==0)
            display_year = year_vec(end)+max(0,i-length(year_vec));
            fprintf(['[fast:transition] capital_iter=%d period=%d/%d '...
                'year=%d iterations=%d residual=%.3e\n'],...
                outer_iter,i,total_period,display_year,inner_iter,diff);
        end
                
        [~,y_vec_until_ss(i),p_vec_until_ss(i),r_vec_until_ss(i),L_vec_until_ss(i),tau_k_wtd_avg,tau_l_wtd_avg,A_j_computed]=...
            model_until_ss(x_next, k_until_ss(i), Par, mom, shock_firm, shock_agg, markup, markdown);
        phi_bar_vec(i) = shock_agg.phi_bar;
        x_guess_ss{i} = x_next;
        if outer_iter==1 && i>=length(year_vec) && i<total_period
            x_guess_ss{i+1} = x_next;
        end
        tau_k_wtd_avg_mat(i,:) = tau_k_wtd_avg';
        tau_l_wtd_avg_mat(i,:) = tau_l_wtd_avg';
        A_j_entire(i,:) = A_j_computed';
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
        if phi==0
            c_guess_until_ss(i) = 1/beta*E_t(i+1)/E_t(i)*(c_guess_until_ss(i+1) )...
                                  /(E_t(i+1)*r_vec_until_ss(i+1)/p_vec_until_ss(i+1)+(1-delta));
        else
            c_guess_until_ss(i) = 1/beta*E_t(i+1)/E_t(i)*(c_guess_until_ss(i+1)-phi_bar(year_next)*L_vec_until_ss(i+1)^(1+1/phi)/(1+1/phi) )...
                                  /(E_t(i+1)*r_vec_until_ss(i+1)/p_vec_until_ss(i+1)+(1-delta))...
                                  + phi_bar(year)*L_vec_until_ss(i)^(1+1/phi)/(1+1/phi);
        end
    end
    i_vec_until_ss = y_vec_until_ss - c_guess_until_ss;
    i_vec_until_ss = max(i_vec_until_ss,0);

    K_implied=zeros(total_period,1);
    K_implied(1)=K_hat(1);

    for i=1:total_period
        K_implied(i+1) = K_implied(i)*(1-delta) + i_vec_until_ss(i)*E_t(i);
    end

    diff_outer = max(abs(k_until_ss(1:total_period)-K_implied(1:total_period))...
        ./max(abs(k_until_ss(1:total_period)),eps));
    [dmp_outer,~] = adapt_damping(...
        dmp_outer,dmp_outer,diff_outer,diff_outer_previous);
    k_until_ss = (1-dmp_outer)*k_until_ss(1:total_period)...
        +dmp_outer*K_implied(1:total_period);
    diff_outer_previous = diff_outer;
    fprintf('[fast:capital] iteration=%d residual=%.3e damping=%.3f\n',...
        outer_iter,diff_outer,dmp_outer);
end
if outer_iter==max_outer_iter && diff_outer>1e-2
    warning('solve_counterfactual_dynamics:CapitalPathNoConvergence',...
        'Capital-path iteration reached the maximum iteration count.');
end

% Welfare
beta = 0.97;
discount_vec = beta.^(0:1:length(year_vec)-1);
welfare = discount_vec * log(c_guess_until_ss(1:length(year_vec))-phi_bar_vec(1:length(year_vec)).*L_vec_until_ss(1:length(year_vec)).^(1+1/phi)/(1+1/phi));
if phi==0
    welfare=discount_vec * log(c_guess_until_ss(1:length(year_vec)));
end

C_vec = c_guess_until_ss;
L_vec = L_vec_until_ss;
% Consumption equivalent welfare measure
if phi==0
    f = @(lmd) discount_vec* log( (1+lmd)*C_base) ...
        - welfare;
else
    f = @(lmd) discount_vec* log( (1+lmd)*C_base - phi_bar_vec(1:length(year_vec)).*(L_base).^(1+1/phi)/(1+1/phi)) ...
        - welfare;
end

lmd = fsolve(f,0);
lmd = lmd*100;

%%
% Then, we run the solve_counterfactual; only difference is that we take
% K_implied as K_hat and calculate C differently..
K_hat = k_until_ss(1:length(year_vec));

intsh = data.intsh;
pop_data = data.pop_data;
balance = data.balance;
% fcons = data.fcons;
num_sector = data.num_sector;
secid_service = data.secid_service;
secid_full = data.secid_full;
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
        fprintf('[fast:observed] solving year=%d (%d/%d)\n',...
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

        x_guess = x_guess_ss{i};
        if warm_is_compatible
            x_guess = counterfactual_warm_state_or_default(...
                warm_start,'x_guess_observed',i,numel(x_guess),x_guess);
        end
        if i==1
            result_final = array2table(zeros(1,21), 'VariableNames',...
                {'firmid','p_d','y_d','p_x','y_x','p_m','m','A_fj','k','l','w_vec','tau_l','tau_k','mu_l','mu_y','DF','DF_real','R','year','secid','pi'});
            result_pre = [];
        end
        inner_iter = 0;
        diff = 10;
        dmp=0.05;
        dmp_small = 0.025;
        diff_previous = Inf;
        while diff > 1e-4 && inner_iter<1e+5
            x_next = model_given_shock(x_guess, Par, mom, shock_firm, shock_agg, year, result_pre, 0, markup, markdown);
            diff = relative_residual(x_next,x_guess);
            [dmp,dmp_small] = adapt_damping(dmp,dmp_small,diff,diff_previous);
            x_guess = [x_next(1:total_firm).*dmp_small+x_guess(1:total_firm).*(1-dmp_small);...
                       x_next(total_firm+1:end).*dmp+x_guess(total_firm+1:end).*(1-dmp) ];
            diff_previous = diff;
            inner_iter = inner_iter+1;
            if mod(inner_iter,inner_progress_interval)==0
                fprintf('[fast:observed] year=%d inner_iter=%d residual=%.3e\n',...
                    year,inner_iter,diff);
            end
        end
        if inner_iter==1e+5
            warning('solve_counterfactual_dynamics:ObservedYearNoConvergence',...
                'Observed-year solve reached its iteration limit in %d.',year);
        end
        observed_iterations_total = observed_iterations_total+inner_iter;
        observed_iterations_max = max(observed_iterations_max,inner_iter);
        fprintf('[fast:observed] year=%d iterations=%d residual=%.3e\n',...
            year,inner_iter,diff);

        [x_next,norm_factor,P_j_F, phi_bar, GDP, sale_vec, to_append,util,real_wage,Y,L,P,...
            GDP_nominal,def,profit_sum,P_j_H,RER,result_next,R,tau_k_wtd_avg,tau_l_wtd_avg,pi_H,exsh,K_j,L_j] =...
            model_given_shock(x_next, Par, mom, shock_firm, shock_agg, year, result_pre, 1, markup, markdown);
        result_final = [result_final;to_append];
        x_guess_observed{i} = x_next;
        result_pre = result_next; % This contains previous period domar weight, etc.

        GDP_vec(i) = GDP;
        R_vec(i) = R;

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
CR4_vec = zeros(length(year_vec),1);
CR10_vec = zeros(length(year_vec),1);
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
A_top3_only_avg_from_sector = zeros(length(year_vec),1); 
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
A_top3_only_sector = zeros(length(year_vec),length(secid_manu));

for i=1:length(year_vec)
    GO_share(i,:) = GO.GO(GO.year==year_vec(i) & ismember(GO.secid,secid_manu))...
        ./sum(GO.GO(GO.year==year_vec(i) & ismember(GO.secid,secid_manu)));

    GO_all_share(i,:) = GO.GO(GO.year==year_vec(i))./sum(GO.GO(GO.year==year_vec(i)));

    result_all = result_final(result_final.year==year_vec(i),:);
    result_all.minus_sale = -result_all.sale;
    result_all.fringe = (result_all.firmid<0);
    result_all.top3 = zeros(height(result_all),1);
    result_all.top4 = zeros(height(result_all),1);
    result_all.top10 = zeros(height(result_all),1);
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
        num_top4 = min(4,sum(result_all.secid_check==0 & result_all.fringe==0));
        result_all.top4(1:num_top4) = 1;
        num_top10 = min(10,sum(result_all.secid_check==0 & result_all.fringe==0));
        result_all.top10(1:num_top10) = 1;
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
    CR4_vec(i) =  sum(result_all.sale(result_all.top4==1)) ...
        / sum(result_all.sale(ismember(result_all.secid,secid_manu) ));
    CR10_vec(i) =  sum(result_all.sale(result_all.top10==1)) ...
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
            A_top3_only_sector(i,j) = mean(result_top3.A_fj(result_top3.secid==j));
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
    A_top3_only_avg_from_sector(i) = wmean(A_top3_only_sector(i,:),GO_share(i,:));
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
agg_result.CR3_vec = CR3_vec;
agg_result.CR3_dom_vec = CR3_dom_vec;
agg_result.CR4_vec = CR4_vec;
agg_result.CR10_vec = CR10_vec;
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
agg_result.A_top3_only_avg_from_sector=A_top3_only_avg_from_sector;
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

agg_result.tau_k_wtd_avg_ss = tau_k_wtd_avg_ss;
agg_result.tau_l_wtd_avg_ss = tau_l_wtd_avg_ss;

agg_result.mu_y_agg_dom_sector = mu_y_agg_dom_sector;
agg_result.HHI_sector = HHI_sector;
agg_result.mu_y_agg_dom_sector_nofringe = mu_y_agg_dom_sector_nofringe;
agg_result.HHI_year = HHI_year;
agg_result.pi_H_year = pi_H_year;

agg_result.A_j = A_j;
agg_result.K_j_mat = K_j_mat;
agg_result.L_j_mat = L_j_mat;

agg_result.CR3_vec_fix = CR3_vec_fix;
agg_result.A_j_entire = A_j_entire;
agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
agg_result.fast_stats.steady_state_iterations = iter;
agg_result.fast_stats.capital_path_iterations = outer_iter;
agg_result.fast_stats.capital_path_residual = diff_outer;
agg_result.fast_stats.transition_iterations_total = transition_iterations_total;
agg_result.fast_stats.transition_iterations_max = transition_iterations_max;
agg_result.fast_stats.observed_iterations_total = observed_iterations_total;
agg_result.fast_stats.observed_iterations_max = observed_iterations_max;

firmid_by_year = cell(length(year_vec),1);
state_length_by_year = zeros(length(year_vec),1);
for i=1:length(year_vec)
    firmid_by_year{i} = period_cache{i}.shock_firm.firmid;
    state_length_by_year(i) = 2*period_cache{i}.total_firm+2*num_sector+1;
end
warm = struct();
warm.metadata.version = 1;
warm.metadata.year_vec = year_vec;
warm.metadata.secid_full = secid_full;
warm.metadata.firmid_by_year = firmid_by_year;
warm.metadata.state_length_by_year = state_length_by_year;
warm.metadata.markup = markup;
warm.metadata.markdown = markdown;
warm.x_guess_steady_state = x_guess_steady_state;
warm.x_guess_transition = x_guess_ss;
warm.x_guess_observed = x_guess_observed;
warm.k_path = k_until_ss;
fprintf('[fast] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
    agg_result.fast_stats.elapsed_seconds,lmd);

end

function is_compatible = counterfactual_warm_is_compatible(...
    warm_start,year_vec,secid_full,period_cache,markup,markdown)

is_compatible = false;
required_fields = {'metadata','x_guess_steady_state','x_guess_transition',...
    'x_guess_observed','k_path'};
if ~isstruct(warm_start) || ~all(isfield(warm_start,required_fields))
    return
end

meta = warm_start.metadata;
if ~isfield(meta,'version') || ~isfield(meta,'year_vec') || ...
        ~isfield(meta,'secid_full') || ~isfield(meta,'firmid_by_year') || ...
        ~isfield(meta,'markup') || ~isfield(meta,'markdown')
    return
end
if meta.version~=1 || ~isequal(meta.year_vec(:),year_vec(:)) || ...
        ~isequal(meta.secid_full(:),secid_full(:)) || ...
        meta.markup~=markup || meta.markdown~=markdown || ...
        numel(meta.firmid_by_year)~=length(year_vec)
    return
end

for i=1:length(year_vec)
    if ~isequal(meta.firmid_by_year{i}(:),period_cache{i}.shock_firm.firmid(:))
        return
    end
end
is_compatible = true;

end

function state = counterfactual_warm_state_or_default(...
    warm_start,field,index,expected_length,default_state)

state = default_state;
if ~isfield(warm_start,field)
    return
end

candidate = warm_start.(field);
if ~isempty(index)
    if ~iscell(candidate) || numel(candidate)<index
        return
    end
    candidate = candidate{index};
end
if isnumeric(candidate) && numel(candidate)==expected_length && ...
        all(isfinite(candidate(:)))
    state = candidate(:);
end

end

function value = counterfactual_warm_vector_or_default(...
    warm_start,field,expected_length,default_value)

value = default_value;
if ~isfield(warm_start,field)
    return
end

candidate = warm_start.(field);
if isnumeric(candidate) && numel(candidate)==expected_length && ...
        all(isfinite(candidate(:)))
    value = candidate(:);
end

end

function period = build_period_cache(...
    year_index,year_vec,balance,result,intsh,pop_data,secid_full,...
    secid_service,secid_manu,result_agg,hour_data,alpha_j_mat,Par)

year_value = year_vec(year_index);
num_sector = length(secid_full);

balance_index = balance.year==year_value;
[is_present,loc] = ismember(balance.secid(balance_index),secid_full);
if any(~is_present)
    error('solve_counterfactual_dynamics:UnknownSector',...
        'The balance data contain an unknown sector in year %d.',year_value);
end

firm_counts = accumarray(loc,1,[length(secid_manu),1]);
firm_num = [firm_counts+1;ones(length(secid_service),1)];
total_firm = sum(firm_num);

gamma_j_i_mat = zeros(num_sector,num_sector);
for j=1:num_sector
    for k=1:num_sector
        value_index = intsh.dsecid==secid_full(j)...
            & intsh.osecid==secid_full(k)...
            & intsh.year==year_value;
        values = intsh.intsh(value_index);
        if numel(values)~=1
            error('solve_counterfactual_dynamics:InputOutputMatch',...
                'Expected one input-output observation for sectors %d/%d in year %d.',...
                secid_full(j),secid_full(k),year_value);
        end
        gamma_j_i_mat(k,j) = values;
    end
    column_sum = sum(gamma_j_i_mat(:,j));
    if column_sum<=0
        error('solve_counterfactual_dynamics:InputOutputSum',...
            'Input-output shares have a nonpositive sum in sector %d, year %d.',...
            secid_full(j),year_value);
    end
    gamma_j_i_mat(:,j) = gamma_j_i_mat(:,j)/column_sum;
end

result_index = result.year==year_value;
if sum(result_index)~=total_firm
    error('solve_counterfactual_dynamics:FirmCountMismatch',...
        'Cached firm count does not match result rows in year %d.',year_value);
end

period.mom.pop = pop_data.Lhat(pop_data.year==year_value);
period.mom.secid_full = secid_full;
period.mom.gamma_j_i_vec = gamma_j_i_mat(:);
period.mom.firm_num = firm_num;
period.mom.model_cache = build_model_static_cache(...
    firm_num,secid_full,gamma_j_i_mat,Par);

period.shock_firm.tau_l_vec = result.tau_l(result_index);
period.shock_firm.tau_k_vec = result.tau_k(result_index);
period.shock_firm.A_fj_vec = result.A_fj(result_index);
period.shock_firm.DF_vec = result.DF(result_index);
period.shock_firm.DF_real = result.DF_real(result_index);
period.shock_firm.firmid = result.firmid(result_index);
period.shock_firm.top3_vec = result.top3(result_index);
period.shock_firm.fringe_vec = result.firmid(result_index)<0 ...
    & result.secid(result_index)<=max(secid_manu);

period.shock_agg.P_j_F = result_agg.P_j_F_vec(year_index,:)';
period.shock_agg.def_vec = result_agg.def_vec(year_index,:)';
period.shock_agg.phi_bar = result_agg.phi_bar_vec(year_index);
period.shock_agg.hour_data = hour_data(year_index);
period.alpha_j = alpha_j_mat(year_index,:)';
period.total_firm = total_firm;
end

function residual = relative_residual(x_next,x_current)
if any(~isfinite(x_next)) || any(~isfinite(x_current))
    error('solve_counterfactual_dynamics:NonfiniteIterate',...
        'A fixed-point iteration produced a nonfinite value.');
end
residual = max(abs(x_next-x_current)./max(1,abs(x_current)));
end

function [dmp,dmp_small] = adapt_damping(...
    dmp,dmp_small,current_residual,previous_residual)
if ~isfinite(previous_residual)
    return
end

if current_residual<0.9*previous_residual
    dmp = min(1.15*dmp,0.25);
    dmp_small = min(1.15*dmp_small,0.15);
elseif current_residual>1.05*previous_residual
    dmp = max(0.5*dmp,0.005);
    dmp_small = max(0.5*dmp_small,0.0025);
end
end
