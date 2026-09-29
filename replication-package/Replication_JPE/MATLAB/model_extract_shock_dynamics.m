function [E_guess,K_star,P_star,R_star,Y_star,C_star,I_star,k_guess_until_ss,C_vec,L_vec,warm]...
    = model_extract_shock_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,warm_start)
% This code extracts E_t and calculate K^*, P^*, R^*, Y^*, C^*
% Then, solve the model until steady state. In that way, we can calculate C_t

% WARM_START is an optional cache returned by a previous call. It contains
% converged states only, so economic inputs are still recomputed every run.
if nargin < 9 || isempty(warm_start)
    warm_start = struct();
end

% We take micro shocks as inputs
% Note that the outputs such as P or GDP are slightly different from model_extract_shock
% Because there are some discrepancy in terms of treating deficit and alpha_j 
delta = Par.delta;
beta = Par.beta;
phi = Par.phi;

intsh = data.intsh;
pop_data = data.pop_data;
balance = data.balance;
secid_manu = data.secid_manu;

K_hat = data.K_hat;
num_sector = data.num_sector;
secid_service = data.secid_service;
secid_full = data.secid_full;
alpha_j_mat = data.alpha_j_mat;
hour_data = data.hour_data;
year_vec = (min(balance.year):1:max(balance.year))';

warm_is_compatible = warm_cache_is_compatible(...
    warm_start,year_vec,secid_full,result,markup,markdown);
if warm_is_compatible
    fprintf('model_extract_shock_dynamics: using structurally compatible warm start.\n');
end
x_guess_store = cell(length(year_vec),1);
firmid_by_year = cell(length(year_vec),1);
state_length_by_year = zeros(length(year_vec),1);

Y_vec = zeros(length(year_vec),1);
P_vec = zeros(length(year_vec),1);
R_vec = zeros(length(year_vec),1);
L_vec = zeros(length(year_vec),1);

firm_num_mat = zeros(length(year_vec),num_sector);

Par.sigma = est_result.sigma;
Par.rho = Par.rho_base;
Par.gamma_L = est_result.gl;
Par.gamma_K = est_result.gk;
Par.gamma_M = est_result.gm;

for i=1:length(year_vec)
    year=year_vec(i);
    year
    gamma_j_i_vec = [];
    % Sectoral variables (sector_num x 1)
    % Domestic sale / (Domestic + Import)
    mom.pop = pop_data.Lhat(pop_data.year==year_vec(i));
    mom.secid_full = secid_full;

    % Get the number of firms in each sector
    [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
    firm_counts = accumarray(loc, 1);
    firm_num = firm_counts + 1; % Number of firms + fringe firm
    firm_num = [firm_num; ones(length(secid_service),1)]; % Add fringe firms from service sector
    firm_num_mat(i,:) = firm_num';
    total_firm = sum(firm_num);
    
    % Par.alpha_j =  fcons.fcons(fcons.year==year_vec(i)) / sum(fcons.fcons(fcons.year==year_vec(i)));        

    gamma_j_i_vec = [];    
    for j=1:num_sector
                gamma_j_i = zeros(num_sector,1); % Share of int buying from sector j to i
        for k=1:num_sector
            gamma_j_i(k) = intsh.intsh(intsh.dsecid==secid_full(j) & intsh.osecid==secid_full(k) & intsh.year==year_vec(i));
        end
        gamma_j_i  = gamma_j_i / sum(gamma_j_i); % Make it sum up to one (excluding sectors outside manufacturing)
        gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
    end
   
    shock_firm.tau_l_vec = result.tau_l( result.year==year_vec(i));
    shock_firm.tau_k_vec = result.tau_k( result.year==year_vec(i));
    shock_firm.A_fj_vec = result.A_fj( result.year==year_vec(i));
    shock_firm.DF_vec = result.DF(result.year==year_vec(i));
    shock_firm.DF_real = result.DF_real(result.year==year_vec(i));
    shock_firm.firmid = result.firmid( result.year==year_vec(i)); 
    firmid_by_year{i} = shock_firm.firmid;
    
    shock_agg.P_j_F = result_agg.P_j_F_vec(i,:)';
    shock_agg.def_vec = result_agg.def_vec(i,:)';
    shock_agg.phi_bar = result_agg.phi_bar_vec(i);
    shock_agg.hour_data = hour_data(i);
    
    mom.gamma_j_i_vec = gamma_j_i_vec;
    mom.firm_num = firm_num;
    mom.K = K_hat(i);
    Par.alpha_j = alpha_j_mat(i,:)';
    
    expected_state_length = 2*total_firm+2*num_sector+1;
    state_length_by_year(i) = expected_state_length;
    x_guess_year = x_guess_cell{i};
    x_guess = [x_guess_year(1:expected_state_length-1);1];
    if warm_is_compatible
        x_guess = warm_state_or_default(...
            warm_start,'x_guess_by_year',i,expected_state_length,x_guess);
    end
    
    iter = 0;
    diff = 10;
    dmp=0.15;
    dmp_small = 0.025;
    while diff > 1e-6 && iter<1e+5
        [x_next] = model_given_shock_dynamics(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);
        diff = norm(x_next-x_guess);
        x_guess = [x_next(1:total_firm).*dmp_small+x_guess(1:total_firm).*(1-dmp_small);...
        x_next(total_firm+1:end).*dmp+x_guess(total_firm+1:end).*(1-dmp) ];
        iter = iter+1;
    end
    if iter>=1e+4
        disp("maximum iteration reached")
    end

    [~,Y_vec(i),P_vec(i),R_vec(i),L_vec(i)] =...
        model_given_shock_dynamics(x_next, Par, mom, shock_firm, shock_agg, markup, markdown);

    x_guess_store{i} = x_next;
end


E_star = 1;
r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state

%%
% Sectoral variables (sector_num x 1)
% Domestic sale / (Domestic + Import)
mom.pop = pop_data.Lhat(pop_data.year==year_vec(end));
mom.secid_full = secid_full;

% Get the number of firms in each sector
[~, loc] = ismember(balance.secid(balance.year==year_vec(end)), secid_full);
firm_counts = accumarray(loc, 1);
firm_num = firm_counts + 1; % Number of firms + fringe firm
firm_num = [firm_num; ones(length(secid_service),1)]; % Add fringe firms from service sector
total_firm = sum(firm_num);

gamma_j_i_vec = [];    
for j=1:num_sector
    gamma_j_i = zeros(num_sector,1); % Share of int buying from sector j to i
    for k=1:num_sector
        gamma_j_i(k) = intsh.intsh(intsh.dsecid==secid_full(j) & intsh.osecid==secid_full(k) & intsh.year==year_vec(end));
    end
    gamma_j_i  = gamma_j_i / sum(gamma_j_i); % Make it sum up to one (excluding sectors outside manufacturing)
    gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
end

shock_firm.tau_l_vec = result.tau_l( result.year==year_vec(end));
shock_firm.tau_k_vec = result.tau_k( result.year==year_vec(end));
shock_firm.A_fj_vec = result.A_fj( result.year==year_vec(end));
shock_firm.DF_vec = result.DF(result.year==year_vec(end));
shock_firm.DF_real = result.DF_real(result.year==year_vec(end));
shock_firm.firmid = result.firmid( result.year==year_vec(end)); 
shock_firm.top3_vec = result.top3(result.year==year_vec(end));
shock_firm.fringe_vec = (result.firmid(result.year==year_vec(end))<0 & result.secid(result.year==year_vec(end))<=max(secid_manu));

shock_agg.P_j_F = result_agg.P_j_F_vec(end,:)';
shock_agg.def_vec = result_agg.def_vec(end,:)';
shock_agg.phi_bar = result_agg.phi_bar_vec(end);
phi_bar = result_agg.phi_bar_vec;
mom.gamma_j_i_vec = gamma_j_i_vec;
mom.firm_num = firm_num;
Par.alpha_j = alpha_j_mat(end,:)';

x_guess = x_guess_store{end};
if warm_is_compatible
    x_guess = warm_state_or_default(...
        warm_start,'x_guess_steady_state',[],2*total_firm+2*num_sector+1,x_guess);
end

shock_agg.r_over_p = r_over_p;
shock_agg.hour_data = hour_data(end);
mom.model_cache = build_model_static_cache(...
    firm_num,secid_full,reshape(gamma_j_i_vec,num_sector,num_sector),Par);

iter = 0;
diff = 1;
dmp=0.1;
dmp_small = 0.025;

%%% Here, we solve steady state Y,P,K,R,L
while diff > 1e-4 && iter<1e+5
    [x_next,Y_star,P_star,K_star,R_star,L_star] = model_solve_ss(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff = norm(x_next-x_guess)
    x_guess = [x_next(1:total_firm).*dmp_small+x_guess(1:total_firm).*(1-dmp_small);...
               x_next(total_firm+1:end).*dmp+x_guess(total_firm+1:end).*(1-dmp) ];
    iter = iter+1;
end
x_guess_steady_state = x_next;

year_converge=100;
k_guess_until_ss = linspace(K_hat(end),K_star,year_converge)'; % Assume that it takes 100 years to converge
if warm_is_compatible
    k_guess_until_ss = warm_vector_or_default(...
        warm_start,'k_path_transition',year_converge,k_guess_until_ss);
end

p_vec_until_ss = zeros(year_converge,1);
y_vec_until_ss = zeros(year_converge,1);
r_vec_until_ss = zeros(year_converge,1);
L_vec_until_ss = zeros(year_converge,1);

for i=1:year_converge
    x_guess_ss{i} = x_guess_store{end};
    if warm_is_compatible
        x_guess_ss{i} = warm_state_or_default(...
            warm_start,'x_guess_transition',i,2*total_firm+2*num_sector+1,x_guess_ss{i});
    end
end

diff=1;
diff_outer=1;
iter=0;

%%% Here, we solve transition until it converges to steady state.
while diff_outer>5e-4
    iter = iter+1;
    for i=1:year_converge
        % i
        x_guess = x_guess_ss{i};
        shock_firm.top3_vec = result.top3(result.year==year_vec(end));
        shock_firm.fringe_vec = (result.firmid(result.year==year_vec(end))<0 & result.secid(result.year==year_vec(end))<=max(secid_manu));
        shock_agg.hour_data = hour_data(end);

        iter = 0;
        diff = 1;
        dmp=0.15;
        dmp_small = 0.025;
        while diff > 1e-4 && iter<1e+5
            [x_next,block] = model_until_ss(x_guess, k_guess_until_ss(i), Par, mom, shock_firm, shock_agg, markup,markdown);
            % [diff,idx] = max(abs(x_next-x_guess) ./ abs(x_guess) )
            diff = norm(x_next-x_guess);
            x_guess = [x_next(1:total_firm).*dmp_small+x_guess(1:total_firm).*(1-dmp_small);...
                       x_next(total_firm+1:end).*dmp+x_guess(total_firm+1:end).*(1-dmp) ];
            iter = iter+1;
        end

        [~,y_vec_until_ss(i),p_vec_until_ss(i),r_vec_until_ss(i),L_vec_until_ss(i)]=...
            model_until_ss(x_next, k_guess_until_ss(i), Par, mom, shock_firm, shock_agg, markup, markdown);

        x_guess_ss{i} = x_next;
    end
    % Get investment and consumption using K and E
    k_guess_until_ss(year_converge+1)=K_star;
    I_star = K_star*delta/E_star;
    C_star = Y_star-I_star;

    c_guess_until_ss = zeros(year_converge,1);
    c_guess_until_ss(year_converge) = C_star;

    % from EE
    for i=year_converge-1:-1:1
        if phi==0
            c_guess_until_ss(i) = 1/beta*(c_guess_until_ss(i+1))/(E_star*r_vec_until_ss(i+1)/p_vec_until_ss(i+1)+(1-delta));
        else
            c_guess_until_ss(i) = 1/beta*(c_guess_until_ss(i+1)-phi_bar(end)*L_vec_until_ss(i+1)^(1+1/phi)/(1+1/phi) )/(E_star*r_vec_until_ss(i+1)/p_vec_until_ss(i+1)+(1-delta))...
                                  + phi_bar(end)*L_vec_until_ss(i)^(1+1/phi)/(1+1/phi);
        end

    end
    i_vec_until_ss = y_vec_until_ss - c_guess_until_ss;


    K_implied=zeros(year_converge,1);
    K_implied(1)=K_hat(end);

    for i=1:year_converge
        K_implied(i+1) = K_implied(i)*(1-delta) + i_vec_until_ss(i)*E_star;
    end

    dmp=0.05;


    diff_outer = max(abs((k_guess_until_ss(1:year_converge)-K_implied(1:year_converge))./k_guess_until_ss(1:year_converge)))
    k_guess_until_ss = (1-dmp)*k_guess_until_ss(1:year_converge)+dmp*K_implied(1:year_converge);
end

%%% Lastly, extract E_t for t=1, ... 40
K_guess = K_hat;

K_guess(length(year_vec)+1,1)=k_guess_until_ss(2);

E_guess = ones(length(year_vec),1);
if warm_is_compatible
    E_guess = warm_vector_or_default(...
        warm_start,'E_guess',length(year_vec),E_guess);
end
E_implied = ones(length(year_vec),1);
E_implied(end) = E_star;

diff=1;
iter=0;
dmp = 0.05;

while diff>1e-8
    iter=iter+1;
    I_vec = zeros(length(year_vec),1);
    for i=1:length(year_vec)
        I_vec(i) = (K_guess(i+1)-(1-delta)*K_guess(i))/E_guess(i);
    end
    C_vec = Y_vec - I_vec;
        
    for i=length(year_vec)-1:-1:1
        if phi==0
            E_implied(i) = 1/beta*(C_vec(i+1))/...
                              (C_vec(i))*E_implied(i+1)/(E_implied(i+1)*R_vec(i+1)/P_vec(i+1)+(1-delta));
        else
            E_implied(i) = 1/beta*(C_vec(i+1)-phi_bar(i+1)*L_vec(i+1)^(1+1/phi)/(1+1/phi))/...
                                  (C_vec(i)-phi_bar(i)*L_vec(i)^(1+1/phi)/(1+1/phi))*E_implied(i+1)/(E_implied(i+1)*R_vec(i+1)/P_vec(i+1)+(1-delta));
        end
    end
    diff = max(abs(E_guess-E_implied))
    E_guess = (1-dmp)*E_guess + dmp*E_implied;
end

% Keep the transition path before it is joined to the observed capital path.
warm = struct();
warm.metadata.version = 1;
warm.metadata.year_vec = year_vec;
warm.metadata.secid_full = secid_full;
warm.metadata.firmid_by_year = firmid_by_year;
warm.metadata.state_length_by_year = state_length_by_year;
warm.metadata.markup = markup;
warm.metadata.markdown = markdown;
warm.x_guess_by_year = x_guess_store;
warm.x_guess_steady_state = x_guess_steady_state;
warm.x_guess_transition = x_guess_ss;
warm.k_path_transition = k_guess_until_ss;
warm.E_guess = E_guess;

k_guess_until_ss = [K_hat;k_guess_until_ss(2:end)];

end

function is_compatible = warm_cache_is_compatible(...
    warm_start,year_vec,secid_full,result,markup,markdown)

is_compatible = false;
required_fields = {'metadata','x_guess_by_year','x_guess_transition',...
    'x_guess_steady_state','k_path_transition','E_guess'};
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
    current_firmid = result.firmid(result.year==year_vec(i));
    if ~isequal(meta.firmid_by_year{i}(:),current_firmid(:))
        return
    end
end
is_compatible = true;

end

function state = warm_state_or_default(warm_start,field,index,expected_length,default_state)

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

function value = warm_vector_or_default(warm_start,field,expected_length,default_value)

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
