function [diff,A_year_next,x_guess_cell,P_j_F_vec,phi_bar_vec,A_level_mat,A_avg_vec,util_vec,def_vec,C_vec,L_vec,result,GDP_vec,D_j_F_vec,E_j_mat,alpha_j_mat,...
    tau_k_wtd_avg_mat,tau_l_wtd_avg_mat,domar_weight,s_M,P_j_mat] = ...
model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result, markup, markdown)

% data
intsh = data.intsh;
imsh = data.imsh;
exsh = data.exsh;
ppi_data = data.ppi_data;
pop_data = data.pop_data;
hour_data = data.hour_data;
balance = data.balance;
fcons = data.fcons;
gdp_hat = data.gdp_hat;
K_hat = data.K_hat;
num_sector = data.num_sector;
secid_service = data.secid_service;
secid_full = data.secid_full;

year_vec = (min(balance.year):1:max(balance.year))';

GDP_vec = zeros(length(year_vec),1);

def_vec = zeros(length(year_vec),num_sector);
P_j_F_vec = zeros(length(year_vec),num_sector);
D_j_F_vec = zeros(length(year_vec),num_sector);
tau_k_wtd_avg_mat = zeros(length(year_vec),num_sector);
tau_l_wtd_avg_mat = zeros(length(year_vec),num_sector);
alpha_j_mat = zeros(length(year_vec),num_sector);
phi_bar_vec = zeros(length(year_vec),1);
A_level_mat = zeros(length(year_vec),num_sector);
E_j_mat = zeros(length(year_vec),num_sector);
total_firm_vec = zeros(length(year_vec),1);
A_avg_vec = zeros(length(year_vec),1);
util_vec = zeros(length(year_vec),1);
C_vec = zeros(length(year_vec),1);
L_vec = zeros(length(year_vec),1);
P_j_mat = zeros(length(year_vec),num_sector);
domar_weight = zeros(length(year_vec),num_sector);
s_M = zeros(length(year_vec),num_sector);
tol = 1e-6;


for i=1:length(year_vec)
    year=year_vec(i);
    % Sectoral variables (sector_num x 1)
    % Domestic sale / (Domestic + Import)
    mom.pi_H_vec = 1 - imsh.imsh(imsh.year==year_vec(i) & ismember(imsh.secid,secid_full));
    mom.exshare_vec = exsh.exsh(exsh.year==year_vec(i) & ismember(exsh.secid,secid_full)); 
    if i==1
    mom.ppi_vec = ppi_data.PPI(ppi_data.year==year_vec(i) & ismember(ppi_data.secid,secid_full));
    else % Make it as growth rate
    mom.ppi_vec = (ppi_data.PPI(ppi_data.year==year_vec(i) & ismember(ppi_data.secid,secid_full))...
        ./ ppi_data.PPI(ppi_data.year==year_vec(i-1) & ismember(ppi_data.secid,secid_full)) );
    end
    
    % mom.ppi_vec = mom.ppi_vec/mom.ppi_vec(1);
    mom.pop = pop_data.Lhat(pop_data.year==year_vec(i));
    mom.hour = hour_data.Lhpchat(hour_data.year==year_vec(i));
    mom.GO = data.GO.GO(data.GO.year==year_vec(i));
    % Get the number of firms in each sector
    [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
    firm_counts = accumarray(loc, 1);
    firm_num = firm_counts + 1; % Number of firms + fringe firm
    firm_num = [firm_num; ones(length(secid_service),1)]; % Add fringe firms from service sector
    total_firm = sum(firm_num);

    Par.alpha_j =  fcons.fcons(fcons.year==year_vec(i) & ismember(fcons.secid,secid_full))...
        / sum(fcons.fcons(fcons.year==year_vec(i) & ismember(fcons.secid,secid_full)));        


    tau_l_vec = block_result.tau_l( block_result.year==year_vec(i));
    tau_k_vec = block_result.tau_k( block_result.year==year_vec(i));
    tau_l_pctile = block_result.tau_l_pctile( block_result.year==year_vec(i));
    tau_k_pctile = block_result.tau_k_pctile( block_result.year==year_vec(i));
    
    A_rel_vec = block_result.A( block_result.year==year_vec(i));
    DF_vec = block_result.DF( block_result.year==year_vec(i));
    
    firmid_vec = block_result.firmid( block_result.year==year_vec(i));
    s_total_vec = block_result.s_total( block_result.year==year_vec(i));
    gamma_j_i_vec = [];    
    for j=1:num_sector
                gamma_j_i = zeros(num_sector,1); % Share of int buying from sector j to i
        for k=1:num_sector
            gamma_j_i(k) = intsh.intsh(intsh.dsecid==secid_full(j) & intsh.osecid==secid_full(k) & intsh.year==year_vec(i));
        end
        gamma_j_i  = gamma_j_i / sum(gamma_j_i); % Make it sum up to one (excluding sectors outside manufacturing)
        gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
    end
    age_bin_vec = block_result.age_bin( block_result.year==year_vec(i));

    block.tau_l_vec = tau_l_vec;
    block.tau_k_vec = tau_k_vec;
    block.tau_l_pctile = tau_l_pctile;
    block.tau_k_pctile = tau_k_pctile;
    block.A_rel_vec = A_rel_vec;
    block.DF_vec = DF_vec;
    block.firmid = firmid_vec;
    block.s_total = s_total_vec;
    block.age_bin = age_bin_vec;

    mom.gamma_j_i_vec = gamma_j_i_vec;
    mom.firm_num = firm_num;
    mom.K = K_hat(i);
    mom.secid_full = secid_full;

    % Solve full model
    % Parameters
    Par.sigma = est_result.sigma;
    Par.rho = Par.rho_base;
    Par.gamma_L = est_result.gl;
    Par.gamma_K = est_result.gk;
    Par.gamma_M = est_result.gm;
    
    x_guess = x_guess_cell{i};
    % x_guess = [ones(total_firm,1)/total_firm; ones(total_firm,1)/total_firm; ones(num_sector,1); ones(num_sector,1); ones(2*num_sector,1); ones(num_sector,1)];
    if i==1
        result = array2table(zeros(1,24), 'VariableNames',...
            {'firmid','p_d','y_d','p_x','y_x','p_m','m','A_fj','k','w','l','tau_l','tau_k','tau_l_pctile',...
            'tau_k_pctile','mu_l','mu_y','DF','year','secid','s_total','DF_real','DF_tilde','age_bin'});
        P_j_init = ones(num_sector,1);
        result_pre = [];
    end
    iter = 0;
    diff = 1;
    dmp=0.15;
    dmp_small = 0.025;
    while diff > 1e-4 && iter<1e+5
        [x_next,block] = model_solve(x_guess,A_year_guess(i), P_j_init ,Par, mom, block, year, result_pre, 0, markup, markdown);
        diff = norm(x_next-x_guess);
        x_guess = [x_next(1:total_firm).*dmp_small+x_guess(1:total_firm).*(1-dmp_small);...
                   x_next(total_firm+1:end).*dmp+x_guess(total_firm+1:end).*(1-dmp) ];
        iter = iter+1;
    end
    
    [x_next,~,norm_factor] = model_solve(x_guess, A_year_guess(i), P_j_init, Par, mom, block, year, result_pre, 0, markup, markdown);

    x_next(2*total_firm+1:2*total_firm + 2*num_sector) = x_next(2*total_firm+1:2*total_firm + 2*num_sector) * norm_factor;

    [~,~,norm_factor,P_j_F, def, phi_bar, GDP , sale_vec, to_append,util,C,L,P_j_tilde,D_j_F,alpha_j,result_next,tau_k_wtd_avg,tau_l_wtd_avg] =...
        model_solve(x_next, A_year_guess(i), P_j_init, Par, mom, block, year, result_pre, 1, markup, markdown);
    result = [result;to_append];

    result_pre = result_next; % This contains previous period domar weight, etc.

    P_j_init = P_j_tilde;

    E_j_vec = x_next( 2*total_firm+num_sector+1:2*total_firm+2*num_sector); % E_j
    A_level_vec = x_next( 2*total_firm+4*num_sector+1:end); % A of fringe firms in each sector


    GDP_vec(i) = GDP;
    P_j_F_vec(i,:) = P_j_F';
    D_j_F_vec(i,:) = D_j_F';
    phi_bar_vec(i) = phi_bar;
    def_vec(i,:) = def';
    A_level_mat(i,:) = A_level_vec;
    E_j_mat(i,:) = E_j_vec';
    total_firm_vec(i) = total_firm;
    A_avg_vec(i) = A_year_guess(i)*wmean(A_rel_vec.*repelem(A_level_vec,firm_num),sale_vec);
    util_vec(i) = util;
    C_vec(i) = C;
    L_vec(i) = L;
    x_guess_cell{i} = x_next;
    P_j_mat(i,:)=P_j_tilde';
    tau_k_wtd_avg_mat(i,:) = tau_k_wtd_avg';
    tau_l_wtd_avg_mat(i,:) = tau_l_wtd_avg';
    domar_weight(i,:) = result_next.domar_weight';
    s_M(i,:) = result_next.s_M';
    alpha_j_mat(i,:) = alpha_j';
end
% GDP_vec = GDP_vec/GDP_vec(1);% normalizing by the first year's GDP   
diff = max(abs(gdp_hat-GDP_vec));
A_year_next = A_year_guess.* (gdp_hat./GDP_vec);
