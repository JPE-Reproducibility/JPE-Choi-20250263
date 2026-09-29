function [x_next, norm_factor,P_j_F, phi_bar, GDP, sale_vec, to_append,util,...
    real_wage,C,L_next,P,GDP_nominal,def,profit_sum,P_j_H,RER,result_next,R, tau_k_wtd_avg, tau_l_wtd_avg, pi_H, exsh, K_j, L_j]=...
    model_given_shock(x, Par, mom, shock_firm, shock_agg, year, result_pre, final, markup,markdown)

% Parameters
rho = Par.rho;
sigma = Par.sigma;
eta = Par.eta;
theta = Par.theta;
gamma_L = Par.gamma_L;
gamma_K = Par.gamma_K;
gamma_M = Par.gamma_M;
gamma_j = gamma_L + gamma_K + gamma_M;
phi = Par.phi;
% gamma_j = ones(length(gamma_j),1);
chi = Par.chi; % The ratio from wedge to government ratio

% Variables from data
firm_num = mom.firm_num(:);
K = mom.K;
pop = mom.pop;

if isfield(mom,'model_cache') && isfield(mom.model_cache,'sigma')
    cache = mom.model_cache;
else
    cache = build_model_static_cache(...
        firm_num,mom.secid_full,...
        reshape(mom.gamma_j_i_vec,length(firm_num),length(firm_num)),Par);
end
total_firm = cache.total_firm;
num_sector = cache.num_sector;
firm_num = cache.firm_num;
sigma = cache.sigma;
rho = cache.rho;
gamma_L = cache.gamma_L;
gamma_K = cache.gamma_K;
gamma_M = cache.gamma_M;
gamma_j = cache.gamma_j;
alpha_j = Par.alpha_j(:); % Will be changed later
if numel(alpha_j)~=num_sector
    error('model_given_shock:AlphaSizeMismatch',...
        'Par.alpha_j must contain %d sector values.',num_sector);
end
x = x(:);

sigma_vec = cache.sigma_vec;
rho_vec = cache.rho_vec;
gamma_L_vec = cache.gamma_L_vec;
gamma_K_vec = cache.gamma_K_vec;
gamma_M_vec = cache.gamma_M_vec;
gamma_j_vec = cache.gamma_j_vec;

% Results from previous steps
tau_l_vec = shock_firm.tau_l_vec(:);
tau_k_vec = shock_firm.tau_k_vec(:);
A_vec = shock_firm.A_fj_vec(:);
% DF_real = shock_firm.DF_real;
DF_vec = shock_firm.DF_vec(:);

P_j_F = shock_agg.P_j_F(:);
% D_j_F = shock_agg.D_j_F;
phi_bar = shock_agg.phi_bar;
def_vec = shock_agg.def_vec(:);
% domar_weight_pre = shock_agg.domar_weight;
% s_M_pre = shock_agg.s_M;
hour_data = shock_agg.hour_data;

s_d = x(1:total_firm); % domestic share
l_share = x(total_firm+1:2*total_firm); % labor shaer
P_j_H_guess = x( 2*total_firm+1:2*total_firm+num_sector); % P_j_H 
E_j_guess = x( 2*total_firm+num_sector+1:2*total_firm+2*num_sector); % E_j
h = x(end);

sector_agg = cache.sector_agg;
firm_num_vec = cache.firm_num_vec;
firm_num_equation = model_variety_firm_num(firm_num,Par);
% This matrix aggregates sectors
% e.g., sector_agg * l_vec = [sum(labor in sector 1); sum(labor in sector 2); ... ] 

p_vec_rel = s_d.^(1./(1-sigma_vec));
P_j_level = P_j_H_guess./ (firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_vec_rel.^(1-sigma_vec)).^(1./(1-sigma)));
p_d = p_vec_rel .* repelem(P_j_level,firm_num);

P_j_H = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_d.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price
% P_j_H = (min(sector_agg*p_d.^(1-sigma_vec),1e+10)).^(1./(1-sigma)); % Domestic sectoral price
% P_j_F = ( ( 1-pi_H_vec )./pi_H_vec ).^(1/(1-rho)) .* P_j_H; % Foreign sectoral price (can be obtained by using domestic firm share)
P_j = (P_j_H.^(1-rho) + P_j_F.^(1-rho)).^(1./(1-rho)); % Sectoral price
P_j_vec = repelem(P_j, firm_num);
P_j_H_vec = repelem(P_j_H, firm_num);
E_j_vec = repelem(E_j_guess, firm_num);
pi_H = P_j_H.^(1-rho)./(P_j_H.^(1-rho)+P_j_F.^(1-rho));

% Export shock - we back out D_j_F using export share
% D_j_F = exshare_vec./(1-exshare_vec).*E_j_guess;
% D_j_F_long = repelem(D_j_F,firm_num);

% Domestic production 
y_d = firm_num_vec.^(-1).*p_d.^(-sigma_vec).*P_j_H_vec.^(sigma_vec-rho_vec).*P_j_vec.^(rho_vec-1).*(E_j_vec);
% Domestic sale
dom_sale_vec = p_d.*y_d;
% Domestic Sale share and Domestic markup
dom_sale_sector = sector_agg * dom_sale_vec;
dom_sale_sector_vec = repelem(dom_sale_sector,firm_num);
s_y = dom_sale_vec./dom_sale_sector_vec ;
pi_H_vec_long = repelem(pi_H,firm_num);

if markup == 1
    epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
    mu_y_vec = epsil_y./(epsil_y-1);
    % Markups for fringe firms (fringe firms are the first in the sector)
    mu_y_vec(cache.fringe_idx) = sigma./(sigma-1);
elseif markup == 0
    mu_y_vec = cache.mu_x_vec;
%     mu_y_vec = ones(total_firm,1);
end

% Markups for export market
mu_x_vec = cache.mu_x_vec;

% Export price (from markup diff)
p_x = p_d.*mu_x_vec./mu_y_vec;

% Export
% y_x = p_x.^(-sigma_vec).*P_j_H_vec.^(sigma_vec-rho_vec).*P_j_vec.^(rho_vec-1).*E_j_vec.*DF_real;
% y_x = p_x.^(-sigma_vec).*P_j_H_vec.^(sigma_vec-rho_vec).*P_j_vec.^(rho_vec-1).*DF_real;
y_x = p_x.^(-sigma_vec).*DF_vec;
export_vec = p_x.*y_x;
% Total sale
sale_vec = export_vec + dom_sale_vec;

sale_sector = sector_agg*sale_vec;
sale_sector_vec = repelem(sale_sector,firm_num);
s_total = sale_vec./sale_sector_vec;

exsh = (sector_agg * export_vec)./ (sector_agg*sale_vec);

% Total production
y_vec = y_d + y_x;

% ex_vec = mu_y_vec./mu_x_vec.*export_vec./dom_sale_vec;
Gamma_d_vec = y_d./y_vec;

R = sum(gamma_K_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*tau_k_vec))/K; % Here, we only use sum of k
k_vec = gamma_K_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*tau_k_vec*R);
K_j = sector_agg*k_vec;

if phi==0
    h=hour_data;
end

l_vec = l_share * pop * h;

% Calculate wage bill share from employment
l_vec_sector = sector_agg * (l_vec.^((eta+1)/eta));
l_vec_sector_long = repelem(l_vec_sector,firm_num);
s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
if markdown==1
    % Markdowns from wage bill share
    epsil_l = (1/eta+(1/theta-1/eta).*s_l).^(-1);
    mu_l_vec = (epsil_l+1) ./ epsil_l;
    % Markdowns for fringe firms
    mu_l_vec(cache.fringe_idx) = (eta+1)/eta;
elseif markdown==0
%     mu_l_vec = ones(total_firm,1);
    mu_l_vec = (eta+1)/eta*ones(total_firm,1);
end

% Wage
w_vec = gamma_L_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*mu_l_vec.*tau_l_vec.*l_vec);

% Tax revenue
T_vec = ( (tau_l_vec-1).*w_vec.*l_vec + R*(tau_k_vec-1).*k_vec ); % Gov revenue

gamma_j_i_mat = cache.gamma_j_i_mat;
P_j_M = exp(gamma_j_i_mat'*log(P_j)+cache.gamma_entropy);

P_j_M_vec = repelem ( P_j_M, firm_num );

% M_vec = gamma_M_vec.*((dom_sale_vec./mu_y_vec+export_vec./mu_x_vec)./P_j_M_vec);
M_vec = gamma_M_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*P_j_M_vec);

% From equation 3.10
pi_vec = (1-gamma_L_vec./(mu_l_vec.*mu_y_vec)-gamma_K_vec./mu_y_vec-gamma_M_vec./mu_y_vec).*dom_sale_vec ...
    + (1-gamma_L_vec./(mu_l_vec.*mu_x_vec)-gamma_K_vec./mu_x_vec-gamma_M_vec./mu_x_vec).*export_vec;

% From equation (3.10) and (3.11)
% D = mu_y_vec.*(mu_l_vec.*tau_l_vec).^(gamma_L_vec./gamma_j_vec).*tau_k_vec.^(gamma_K_vec./gamma_j_vec); % Total distortion
% c = (y_vec.^(1-gamma_j_vec).*(w_vec./gamma_L_vec).^(gamma_L_vec).*(R./gamma_K_vec).^(gamma_K_vec).*(P_j_M_vec./gamma_M_vec).^(gamma_M_vec)).^(1./gamma_j_vec);
p_next = mu_y_vec.*y_vec.^((1-gamma_j_vec)./gamma_j_vec).*(mu_l_vec.*tau_l_vec.*w_vec./gamma_L_vec).^(gamma_L_vec./gamma_j_vec)...
    .*(tau_k_vec*R./gamma_K_vec).^(gamma_K_vec./gamma_j_vec)...
    .*(P_j_M_vec./gamma_M_vec).^(gamma_M_vec./gamma_j_vec)...
    ./(A_vec.^(1./gamma_j_vec));
cost_bundle = (w_vec./gamma_L_vec).^(gamma_L_vec./gamma_j_vec)...
    .*(R./gamma_K_vec).^(gamma_K_vec./gamma_j_vec)...
    .*(P_j_M_vec./gamma_M_vec).^(gamma_M_vec./gamma_j_vec);
P_j_H_next = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_next.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price
s_d_next = p_next.^(1-sigma_vec);
% normalization 
s_d_next = s_d_next ./ repelem ( sector_agg*s_d_next, firm_num);

W_j = (1./firm_num_equation.*sector_agg * w_vec.^(1+eta) ).^(1/(1+eta));
W_j_vec = repelem (W_j, firm_num);
L_j = firm_num_equation.^(1/(eta+1)).*( sector_agg * l_vec.^((eta+1)/eta) ).^(eta/(eta+1));
W = sum(W_j.^(1+theta))^(1/(1+theta));
L = sum( L_j.^((theta+1)/theta) )^(theta/(theta+1));


% I = sum(w_next.*l_vec + pi_vec + chi*T_vec);
I = sum(w_vec.*l_vec + R.*k_vec + pi_vec + T_vec);

% E_j_next = zeros(num_sector,1); % Expenditure in sector j
revenue_sector = sector_agg*(dom_sale_vec./mu_y_vec + export_vec./mu_x_vec);
GO = alpha_j*I + gamma_j_i_mat*(gamma_M.*revenue_sector);
% def_vec = (1-pi_H_vec-exshare_vec)./pi_H_vec.*GO; % Sectoral trade deficit
% E_j_next = GO+def_vec;
E_j_next = GO + alpha_j.*sum(def_vec); % Add deficit as lump-sum transfer
if E_j_next<=1e-12
    disp("touching threshold")
end

IM_j = E_j_next.*(1-pi_H);
EX_j = sector_agg*export_vec;
def = IM_j - EX_j;

P_j_H = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_next.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price
P_j = (P_j_H.^(1-rho)+ P_j_F.^(1-rho)).^(1./(1-rho)); % Sectoral price
% P = exp(sum(alpha_j.*log(P_j)));
RER = exp(sum(alpha_j(1:11).*log(P_j_F(1:11) ))) /  exp(sum(alpha_j(1:11).*log(P_j_H(1:11))));

p_tilde = p_d .* (1-export_vec./sale_vec) + p_x.*(export_vec./sale_vec);
P_j_tilde = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_tilde.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price
M_j = sector_agg*M_vec;
R_j = sector_agg*sale_vec;
real_output_sector = R_j./P_j_tilde;

% P_j_M_tilde = exp ( log(P_j_tilde)'*gamma_j_i_mat )';
% M_j_r = P_j_M.*M_j./P_j_M_tilde;

if year==1972
    GDP = sum(R_j) - P_j_M'*M_j;
    domar_weight = R_j / sum(R_j-P_j_M.*M_j);
    s_M =(P_j_M.*M_j) ./ R_j; % Expenditure share of material in total revenue
else
    % P_j_tilde_pre = result_pre.P_j_tilde;
    % P_j_M_pre = result_pre.P_j_M;
    M_j_pre = result_pre.M_j;
    GDP_pre = result_pre.GDP;

    % Fixed or flexible domar weight (first line is flexible)
    domar_weight_pre = result_pre.domar_weight;
    % domar_weight_pre = shock_agg.domar_weight;
    
    s_M_pre = result_pre.s_M;
    % s_M_pre = shock_agg.s_M;

    % R_j_pre = result_pre.R_j;
    real_output_sector_pre = result_pre.real_output_sector;
    
    
    % real_output = P_j_tilde_pre'*real_output_sector - P_j_M_pre'*M_j;
    domar_weight = R_j / sum(R_j-P_j_M.*M_j);
    s_M =(P_j_M.*M_j) ./ R_j; % Expenditure share of material in total revenue

    real_output_sector_hat = real_output_sector./real_output_sector_pre;
    M_vec_hat = M_j./M_j_pre;
    gdp_growth = domar_weight_pre'* (real_output_sector_hat-s_M_pre.*M_vec_hat);
    GDP = GDP_pre*gdp_growth;
end

ppi_model = exp(sum(alpha_j.*log(P_j./alpha_j)));

P = ppi_model;
% Real GDP = Consumption for now
% GDP = I;
% GDP = I/P;
profit_sum = sum(pi_vec)/P;
GDP_nominal = sum(dom_sale_vec+export_vec-P_j_M_vec.*M_vec);
% GDP2=sum(dom_sale_vec+export_vec-P_j_M_vec.*M_vec)/P;

% Real consumption per capita 
% C = GDP;
C = sum(w_vec.*l_vec + R.*k_vec + pi_vec + chi*T_vec) / P;

% pi_real = pi_vec./P;
% pi_real = pi_vec./cost_bundle;
% pi_real = pi_vec;
% pi_real = pi_vec./W;
pi_real = pi_vec./w_vec;

% hour_next by solving HH problem
% hour_next by solving HH problem
if phi==0
    L_next = pop*hour_data;
    l_next = 1./firm_num_vec.*w_vec.^(eta).*W_j_vec.^(theta-eta)*W^(-theta)*L_next;
    hour_next = hour_data;
else
    L_next = (W/P/phi_bar)^(phi);
    l_next = 1./firm_num_vec.*w_vec.^(eta).*W_j_vec.^(theta-eta)*W^(-theta)*L_next;
    hour_next = sum(l_next)/pop;
end
l_share_next = l_next/sum(l_next);

% A_firm = A_fj;
year_mat = repmat(year,total_firm,1);
sector_vec = cache.sector_vec;
R_vec = R*ones(total_firm,1);
% 
if final==0
    to_append={};
else
    to_append = array2table([shock_firm.firmid p_d y_d p_x y_x P_j_M_vec, M_vec A_vec...
        k_vec l_vec w_vec tau_l_vec tau_k_vec mu_l_vec mu_y_vec DF_vec shock_firm.DF_real R_vec year_mat sector_vec pi_real],...
        'VariableNames', {'firmid', 'p_d','y_d','p_x','y_x','p_m','m','A_fj','k','l','w_vec','tau_l','tau_k','mu_l','mu_y','DF','DF_real','R','year','secid','pi'});
end

mu_tilde = mu_y_vec.*y_d./y_vec+mu_x_vec.*y_x./y_vec;

% Calculating "weighted" average of wedge
tau_k_wtd_avg = sector_agg*(1./(tau_k_vec.*mu_tilde).*s_total);
tau_l_wtd_avg = sector_agg*((1./(tau_l_vec.*mu_tilde.*mu_l_vec).*s_total));
% tau_k_wtd_avg = 1./(sector_agg*(tau_k_vec.*s_total));
% tau_l_wtd_avg = 1./(sector_agg*(tau_l_vec.*s_total));

x_next = [ s_d_next; l_share_next;P_j_H_next; E_j_next; hour_next ];

norm_factor = 1/I;
% GDP = GDP*norm_factor;

util = log(C - phi_bar*(L_next)^(1+1/phi)/(1+1/phi));

real_wage = W/P;

% if final==1
%     sum(pi_vec<0)
% end

% result_next.P_j_tilde = P_j_tilde;
% result_next.P_j_M = P_j_M;
% result_next.GDP = GDP;
% result_next.real_output_sector = real_output_sector;
% result_next.M_j = M_j;
% result_next.R_j = R_j;
if year==1972
    result_next.domar_weight = domar_weight;
    result_next.s_M = s_M;
    result_next.GDP = GDP;
    result_next.real_output_sector = real_output_sector;
    result_next.M_j = M_j;
else    
    result_next.domar_weight = domar_weight;
    result_next.s_M = s_M;
    result_next.GDP = GDP;
    result_next.real_output_sector = real_output_sector;
    result_next.M_j = M_j;
    result_next.real_output_sector_hat = real_output_sector_hat;
    result_next.M_vec_hat = M_vec_hat;
    result_next.GDP_growth = gdp_growth;
end
% sum(T_vec)
% log(consumption_base*pop- phi_bar*hour_base^(1+1/phi)/(1+1/phi))
% log(C*pop- phi_bar*hour_off^(1+1/phi)/(1+1/phi))

% I

% x_next = [ p_next; w_next ; ones(n,1); A_level_next ];


% x_next = [ p_next; w_next ; ones(num_sector,1); A_level_next ];

% index=0;
% for j=1:num_sector
%     P_j_H_next(j) = sum(p_next(index+1:sum(firm_num(1:j))).^(1-sigma_vec))^(1/(1-sigma_vec));
%     index = index+firm_num(j);   
% end

% x = [p_next; A_level_next];

% y_vec = D.^(-gamma_j_vec/(1-gamma_j_vec)).*p.^(gamma_j_vec/(1-gamma_j_vec)) .*...
%     ( (w_vec./gamma_L_vec).^(gamma_L_vec).*(R/gamma_K)^(gamma_K).*(P_j_M_vec./gamma_M_vec).^(gamma_M_vec) ).^(-1/(1-gamma_j_vec))...
%     .*A_vec.^(1/(1-gamma_j_vec));
% p_next = sale_vec./y_vec;

% M_vec = gamma_M_vec.*p.*y_vec./(mu_y_vec.*P_j_M_vec);
% pi_vec = p.*y_vec-tau_l_vec.*w_vec.*l_vec-R*tau_k_vec.*k_vec-P_j_M_vec.*M_vec;

