function [x_next,block,norm_factor,P_j_F, def, phi_bar, GDP, sale_vec, to_append,util,C,L,P_j_tilde,D_j_F,alpha_j,result_next,tau_k_wtd_avg,tau_l_wtd_avg]=...
    model_solve(x,  A_year, P_j_init, Par, mom, block, year, result_pre, final, markup, markdown)

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
chi = Par.chi;

% Variables from data
pi_H_vec = mom.pi_H_vec;
exshare_vec = mom.exshare_vec;

ppi_vec = mom.ppi_vec;
gamma_j_i_vec = mom.gamma_j_i_vec;
firm_num = mom.firm_num;
K = mom.K;
pop = mom.pop;
hour = mom.hour;
secid_full = mom.secid_full;
GO = mom.GO;
GO_share = GO/sum(GO);

total_firm = sum(firm_num);
num_sector=length(firm_num);
sigma_vec = repelem(sigma,firm_num);
rho_vec = repelem(rho,firm_num);
gamma_L_vec = repelem(gamma_L,firm_num);
gamma_K_vec = repelem(gamma_K,firm_num);
gamma_M_vec = repelem(gamma_M,firm_num);
gamma_j_vec = repelem(gamma_j,firm_num);

% Results from previous steps
A_rel_vec = block.A_rel_vec;
DF_rel = block.DF_vec;

s_d = x(1:total_firm); % domestic share
l_share = x(total_firm+1:2*total_firm); % labor share
P_j_H_guess = x( 2*total_firm+1:2*total_firm+num_sector); % P_j_H 
E_j_guess = x( 2*total_firm+num_sector+1:2*total_firm+2*num_sector); % E_j
tau_k_level_guess = x( 2*total_firm+2*num_sector+1 : 2*total_firm+3*num_sector); % average level of tau_l
tau_l_level_guess = x( 2*total_firm+3*num_sector+1 : 2*total_firm+4*num_sector); % average level of tau_k
A_sector_guess = x( 2*total_firm+4*num_sector+1:end); % A of fringe firms in each sector, the first sector is normalized as one

block.tau_k_vec = block.tau_k_vec.*repelem(tau_k_level_guess,firm_num);
block.tau_l_vec = block.tau_l_vec.*repelem(tau_l_level_guess,firm_num);

tau_k_vec = block.tau_k_vec;
tau_l_vec = block.tau_l_vec;


sector_agg = sparse(repelem(1:num_sector, firm_num),1:total_firm, 1, num_sector, total_firm);
firm_num_equation = model_variety_firm_num(firm_num,Par);
firm_num_vec = repelem(firm_num_equation, firm_num);

p_vec_rel = s_d.^(1./(1-sigma_vec));
P_j_level = P_j_H_guess./ (firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_vec_rel.^(1-sigma_vec)).^(1./(1-sigma)));
p_d = p_vec_rel .* repelem(P_j_level,firm_num);
% This matrix aggregates sectors
% e.g., sector_agg * l_vec = [sum(labor in sector 1); sum(labor in sector 2); ... ] 
P_j_H = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_d.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price


P_j_F = ( ( 1-pi_H_vec )./pi_H_vec ).^(1./(1-rho)) .* P_j_H; % Foreign sectoral price (can be obtained by using domestic firm share)
P_j = (P_j_H.^(1-rho)+ P_j_F.^(1-rho)).^(1./(1-rho)); % Sectoral price
P_j_vec = repelem(P_j, firm_num);
P_j_H_vec = repelem(P_j_H, firm_num);
E_j_vec = repelem(E_j_guess, firm_num);

% Domestic production
y_d = firm_num_vec.^(-1).*p_d.^(-sigma_vec).*P_j_H_vec.^(sigma_vec-rho_vec).*P_j_vec.^(rho_vec-1).*(E_j_vec);
% Domestic sale
dom_sale_vec = p_d.*y_d;
% Domestic Sale share and Domestic markup
dom_sale_sector = sector_agg * dom_sale_vec;
dom_sale_sector_vec = repelem(dom_sale_sector,firm_num);
s_y = dom_sale_vec./dom_sale_sector_vec ;
pi_H_vec_long = repelem(pi_H_vec,firm_num);
sigma_vec = repelem(sigma,firm_num);

firm_num_cum = cumsum(firm_num);
firm_num_cum = [0;firm_num_cum(1:end-1)];

if markup == 1
    epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
    mu_y_vec = epsil_y./(epsil_y-1);
    % Markups for fringe firms (fringe firms are the first in the sector)
    for j=1:num_sector
        mu_y_vec(firm_num_cum(j)+1) = sigma(j)/(sigma(j)-1);
    end
elseif markup == 0
    mu_y_vec = repelem(sigma./(sigma-1),firm_num);
end


% Markups for export market
mu_x_vec = repelem(sigma./(sigma-1),firm_num);

% Export price (from markup diff)
p_x = p_d.*mu_x_vec./mu_y_vec;

% Back out D_j_F
D_j_F = exshare_vec.* (sector_agg * dom_sale_vec) ./ ((1-exshare_vec).*( sector_agg* (p_x.^(1-sigma_vec).*DF_rel)));
DF_vec = DF_rel.*repelem(D_j_F,firm_num);

% Export
y_x = p_x.^(-sigma_vec).*DF_vec;
export_vec = p_x.*y_x;
% Total sale
sale_vec = export_vec + dom_sale_vec;

% Total sale share
sale_sector = sector_agg*sale_vec;
sale_sector_vec = repelem(sale_sector,firm_num);
s_total = sale_vec./sale_sector_vec;

% Total production
y_vec = y_d + y_x;

Gamma_d_vec = y_d./y_vec;

R = sum(gamma_K_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*tau_k_vec))/K; % Here, we only use sum of k
k_vec = gamma_K_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*tau_k_vec*R); 
l_vec = l_share * pop * hour;

l_vec_sector = sector_agg * (l_vec.^((eta+1)/eta));
l_vec_sector_long = repelem(l_vec_sector,firm_num);
s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;

if markdown==1
    % Markdowns from wage bill share
    epsil_l = (1/eta+(1/theta-1/eta).*s_l).^(-1);
    mu_l_vec = (epsil_l+1) ./ epsil_l;
    % Markdowns for fringe firms
    for j=1:num_sector
        mu_l_vec(firm_num_cum(j)+1) = (eta+1)/ eta;
    end
elseif markdown==0
    mu_l_vec = (eta+1)/eta*ones(total_firm,1);
end

% Wage
w_vec = gamma_L_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*mu_l_vec.*tau_l_vec.*l_vec);

% Tax revenue
T_vec = ( (tau_l_vec-1).*w_vec.*l_vec + R*(tau_k_vec-1).*k_vec ); % Gov revenue

gamma_j_i_mat = reshape(gamma_j_i_vec,num_sector,num_sector);

P_j_M = zeros(num_sector,1);
for i=1:num_sector
    for j=1:num_sector
        if gamma_j_i_mat(j,i)>0
            P_j_M(i) = P_j_M(i) + log(P_j(j)./gamma_j_i_mat(j,i))*gamma_j_i_mat(j,i);
        end
    end
end
P_j_M = exp(P_j_M);

P_j_M_vec = repelem ( P_j_M, firm_num );
A_vec = A_year*repelem( A_sector_guess, firm_num ).* A_rel_vec;

M_vec = gamma_M_vec.*dom_sale_vec./(Gamma_d_vec.*mu_y_vec.*P_j_M_vec);

% From equation 3.10
pi_vec = (1-gamma_L_vec./(mu_l_vec.*mu_y_vec)-gamma_K_vec./mu_y_vec-gamma_M_vec./mu_y_vec).*dom_sale_vec ...
    + (1-gamma_L_vec./(mu_l_vec.*mu_x_vec)-gamma_K_vec./mu_x_vec-gamma_M_vec./mu_x_vec).*export_vec;

% From equation (3.10) and (3.11)
p_next = mu_y_vec.*y_vec.^((1-gamma_j_vec)./gamma_j_vec).*(mu_l_vec.*tau_l_vec.*w_vec./gamma_L_vec).^(gamma_L_vec./gamma_j_vec)...
    .*(tau_k_vec*R./gamma_K_vec).^(gamma_K_vec./gamma_j_vec)...
    .*(P_j_M_vec./gamma_M_vec).^(gamma_M_vec./gamma_j_vec)...
    ./(A_vec.^(1./gamma_j_vec));
P_j_H_next = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_next.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price

s_d_next = p_next.^(1-sigma_vec);
% normalization 
s_d_next = s_d_next ./ repelem ( sector_agg*s_d_next, firm_num);

W_j = (1./firm_num_equation.*sector_agg * w_vec.^(1+eta) ).^(1/(1+eta));
W_j_vec = repelem (W_j, firm_num);
L_j = (firm_num_equation.^(1/eta).*(sector_agg * l_vec.^((eta+1)/eta)) ).^(eta/(eta+1));
W = sum(W_j.^(1+theta))^(1/(1+theta));
L = sum( L_j.^((theta+1)/theta) )^(theta/(theta+1));

l_next = 1./firm_num_vec.*w_vec.^(eta).*W_j_vec.^(theta-eta)*W^(-theta)*L;
l_share_next = l_next/sum(l_next);

I = sum(w_vec.*l_vec + R.*k_vec + pi_vec + T_vec); % This is income for expenditure. We do not multiply Chi here.

revenue_sector = sector_agg*(dom_sale_vec./mu_y_vec + export_vec./mu_x_vec);

GO = zeros(num_sector,1);

alpha_j = zeros(num_sector,1);
int_revenue = zeros(num_sector,1);

for j=1:num_sector
    int_revenue(j) = sum(gamma_M.*gamma_j_i_vec( j:num_sector:(num_sector-1)*num_sector+j )...
        .*revenue_sector );
end

for j=1:num_sector
    alpha_j(j) = max((GO_share(j) * (I+sum(int_revenue))-int_revenue(j)) / I ,1e-4);
end
alpha_j = alpha_j / sum(alpha_j); % normalize as sum to one

for j=1:num_sector
    GO(j) = (alpha_j(j) * I + int_revenue(j)) ;
end

def = (1-pi_H_vec-exshare_vec)./pi_H_vec.*GO; % Sectoral trade deficit

E_j_next = max(GO + def,1e-12); % Add deficit to sectoral expenditure
if sum(E_j_next==1e-12)>0
    disp("Touching Threshold")
end


IM_j = E_j_next.*(1-pi_H_vec);


p_tilde = p_d .* (1-export_vec./sale_vec) + p_x.*(export_vec./sale_vec);
P_j_tilde = firm_num_equation.^(-1./(1-sigma)).*(sector_agg*p_tilde.^(1-sigma_vec)).^(1./(1-sigma)); % Domestic sectoral price
M_j = sector_agg*M_vec;
R_j = sector_agg*sale_vec;
real_output_sector = R_j./P_j_tilde;

if year==1972
    GDP = sum(R_j) - P_j_M'*M_j;
    domar_weight = R_j / sum(R_j-P_j_M.*M_j);
    s_M =(P_j_M.*M_j) ./ R_j; % Expenditure share of material in total revenue
else
    M_j_pre = result_pre.M_j;
    GDP_pre = result_pre.GDP;
    domar_weight_pre = result_pre.domar_weight;
    real_output_sector_pre = result_pre.real_output_sector;
    s_M_pre = result_pre.s_M;
    
    domar_weight = R_j / sum(R_j-P_j_M.*M_j);
    s_M =(P_j_M.*M_j) ./ R_j; % Expenditure share of material in total revenue

    real_output_sector_hat = real_output_sector./real_output_sector_pre;
    M_vec_hat = M_j./M_j_pre;
    gdp_growth = domar_weight_pre'* (real_output_sector_hat-s_M_pre.*M_vec_hat);
    GDP = GDP_pre*gdp_growth;
end

ppi_model = exp(sum(alpha_j.*log(P_j./alpha_j)));

P = ppi_model;

C = sum(w_vec.*l_vec + R.*k_vec + pi_vec + chi*T_vec) / P; % This is consumption to compute welfare. We do multiply Chi here.

DF_real = DF_vec./(firm_num_vec.^(-1).*P_j_H_vec.^(sigma_vec-rho_vec).*P_j_vec.^(rho_vec-1).*E_j_vec);
DF_tilde = DF_vec./(firm_num_vec.^(-1).*P_j_H_vec.^(sigma_vec-rho_vec).*P_j_vec.^(rho_vec-1).*E_j_vec);

DF_real(DF_vec==0)=0;

year_mat = repmat(year,total_firm,1);
sector_vec = repelem(secid_full,firm_num);

if final==0
    to_append={};
else
    to_append = array2table([block.firmid p_d y_d p_x y_x P_j_M_vec, M_vec A_vec...
        k_vec w_vec l_vec tau_l_vec tau_k_vec block.tau_l_pctile block.tau_k_pctile ...
        mu_l_vec mu_y_vec DF_vec year_mat sector_vec block.s_total DF_real DF_tilde block.age_bin],...
        'VariableNames', {'firmid', 'p_d','y_d','p_x','y_x','p_m','m','A_fj','k','w','l','tau_l','tau_k',...
        'tau_l_pctile','tau_k_pctile',...
        'mu_l','mu_y','DF','year','secid','s_total','DF_real','DF_tilde','age_bin'});
end

ppi_growth = P_j_tilde./P_j_init;

% % when year==1972, use P_j as PPI_j
% if year==1972 
%     ppi_model = P_j;
% else
%     result_pre = result(result.year==year-1,:);
%     result_current = to_append;
%     [ppi_model] ...
%         = compute_ppi(result_pre,result_current);
% end

% A_level_next = ( ppi_vec./ppi_model ).^(-gamma_j).* A_sector_guess ;
% A_level_next = ( ppi_vec./ppi_model*ppi_model(1)).^(-gamma_j).* A_sector_guess ;
% A_level_next = ones(num_sector,1);

% P_j_tilde = [1;1;1;1 ...] at the initial year
% Also, A=1 in secid=1 at the initial year
if year==1972 % At the initial level, ppi is level which is all one for all sectors. 
    A_level_next = ( (ppi_vec./ppi_vec(1))./ (P_j_tilde./P_j_tilde(1)).^(-gamma_j) ).* A_sector_guess ; 
else % ppi_vec is ppi growth rate from data
    A_level_next = ( (ppi_vec./ppi_vec(1))./ (ppi_growth./ppi_growth(1)) ).^(-gamma_j).* A_sector_guess ;
end

mu_tilde = mu_y_vec.*dom_sale_vec./sale_vec+mu_x_vec.*export_vec./sale_vec;

% Calculating "weighted" average of wedge
tau_k_wtd_avg = sector_agg*(1./(tau_k_vec.*mu_tilde).*s_total);
tau_l_wtd_avg = sector_agg*((1./(tau_l_vec.*mu_tilde.*mu_l_vec).*s_total));

tau_k_level_next = tau_k_wtd_avg;
tau_l_level_next = tau_l_wtd_avg;

x_next = [ s_d_next; l_share_next; P_j_H_next; E_j_next; tau_k_level_next; tau_l_level_next ; A_level_next];

norm_factor = 1/P;

% Back out phi_bar from hour
phi_bar=W/P*L^(-1/phi);

% GDP = GDP;
util = log(C - phi_bar*L^(1+1/phi)/(1+1/phi));

result_next.domar_weight = domar_weight;
result_next.s_M = s_M;
result_next.GDP = GDP;
result_next.real_output_sector = real_output_sector;
result_next.M_j = M_j;
