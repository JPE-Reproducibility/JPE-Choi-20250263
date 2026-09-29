% MAIN CODE
% Written by Younghun Shim
matlab_dir = fileparts(mfilename('fullpath'));
if isempty(matlab_dir)
    matlab_dir = pwd;
end
project_root = fileparts(matlab_dir);
if isfolder(fullfile(matlab_dir,'INPUT')) && isfolder(fullfile(matlab_dir,'MATLAB'))
    project_root = matlab_dir;
    matlab_dir = fullfile(project_root,'MATLAB');
end
if ~isfolder(fullfile(project_root,'INPUT'))
    error('solve_full_model_only_tau_l:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
warm_start_dir = fullfile(matlab_dir,'warm_start','only_tau_l');
result_dir = fullfile(matlab_dir,'result');
if ~isfolder(warm_start_dir)
    mkdir(warm_start_dir);
end
if ~isfolder(result_dir)
    mkdir(result_dir);
end
warm_file = @(name) fullfile(warm_start_dir,name);

INPUT = string(fullfile(project_root,'INPUT')) + filesep;
OUTPUT = string(fullfile(project_root,'OUTPUT')) + filesep;
figure = string(fullfile(project_root,'FIGURE')) + filesep;
if ~isfolder(OUTPUT)
    mkdir(OUTPUT);
end
if ~isfolder(figure)
    mkdir(figure);
end

% markup / markdown on off
markup = 1;
markdown = 1;

spec={};

run set_parameters_load_data.m

%% Calculate wedge and productivity
block_result = array2table(zeros(1,14), 'VariableNames',...
        {'firmid','year','s_total','s_y','s_k','s_l','A','tau_l','tau_k','mu_y','mu_l','DF','secid','age_bin'});

% Calculate sale share of fringe firm, and smooth it
fringe_share = zeros(length(year_vec),length(secid_manu));
for i=1:length(year_vec)
    for j=1:length(secid_manu)
        fringe_share(i,j) = (GO.GO(GO.year==year_vec(i) & GO.secid==j) ...
                        - sum(balance.sale(balance.year==year_vec(i) & balance.secid==j) )) ...
            / GO.GO(GO.year==year_vec(i) & GO.secid==j) ;
    end
end
% Take moving avereage on fringe firms' share
fringe_share = movmean(fringe_share,[5 5]);

exsh_check=zeros(length(year_vec),length(secid_manu));

for i=1:length(year_vec)
        year=year_vec(i)
        % Get the number of firms in each sector
        [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
        firm_counts = accumarray(loc, 1);
        firm_num = firm_counts + 1; % Number of firms + fringe firm
        total_firm = sum(firm_num) + length(secid_service); % Add fringe firms from service sector
        total_firm_vec(i) = total_firm;
        % Par.alpha_j =  fcons.fcons(fcons.year==year_vec(i)) / sum(fcons.fcons(fcons.year==year_vec(i)));        
    for j=1:length(secid_manu) % Back out wedge, productivity from manufacturing firms
        Par.sigma = est_result.sigma(j);
        Par.rho = Par.rho_base(j);
        Par.gamma_L = est_result.gl(j);
        Par.gamma_K = est_result.gk(j);
        Par.gamma_M = est_result.gm(j);
        Par.gamma_j = est_result.gl(j)+est_result.gk(j)+est_result.gm(j);
        
        mom.sale = balance.sale( balance.secid==j & balance.year==year_vec(i) );
        mom.fasset = balance.fasset( balance.secid==j & balance.year==year_vec(i) );
        mom.emp = balance.emp( balance.secid==j & balance.year==year_vec(i) );
        mom.G_sale = GO.GO( GO.secid==j & GO.year==year_vec(i));
        mom.G_export = EX.EX( EX.secid==j & EX.year==year_vec(i));
        mom.G_K = GK.K( GK.secid==j & GK.year==year_vec(i));
        mom.pi_H = 1 - imsh.imsh( imsh.secid==j & imsh.year==year_vec(i)); 
        mom.export = balance.export( balance.secid==j & balance.year==year_vec(i) );
        mom.firmid = [balance.firmid( balance.secid==j & balance.year==year_vec(i) );-1*j]; % -j: fringe firm
        mom.secid = j*ones(firm_num(j),1);
        mom.year = year * ones(firm_num(j),1);
        mom.fringe_share = fringe_share(i,j);
        mom.age_bin = [balance.age_bin(balance.secid==j & balance.year==year_vec(i));1];
        % Calculate wedge and relative productivity
        [to_append,exsh_check(i,j)] = compute_block(mom, Par, markup,markdown);
        block_result =[block_result; to_append];
    end
    % Add service sector (with only fringe firms)
    for j=1:length(secid_service)
        sigma = est_result.sigma(est_result.secid==secid_service(j));
        eta = Par.eta;
        to_append = array2table([-secid_service(j) year_vec(i) 1 1 1 1 1 1 1 sigma/(sigma-1) (eta+1)/eta 1 secid_service(j),1],...
        'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','DF','secid','age_bin'});
        block_result = [block_result; to_append];
    end

    % Truncate at the year level
    lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
    upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
    block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
    block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;

    lower_bound = prctile(block_result.tau_k(block_result.year==year), 1.5);
    upper_bound = prctile(block_result.tau_k(block_result.year==year), 98.5);
    block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
    block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
end

% Take percentile of wedge
for i=1:length(year_vec)
    for j=1:length(secid_manu)
        block_result.A_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
            = invprctile(block_result.A(block_result.year==year_vec(i) & block_result.secid==j),...
            block_result.A(block_result.year==year_vec(i) & block_result.secid==j));
        % block_result.A_pctile(block_result.A_pctile<2.5) = 2.5; % Truncation
    end
end

% Fix the productivity as the initial level
block_result=sortrows(block_result,{'firmid','year'});
firmlist=unique(block_result.firmid); % & result.firmid~=8973
for i = 1:length(firmlist)
    firmRows = find(block_result.firmid==firmlist(i));
    secid_sample = block_result.secid(firmRows);
    year_sample = block_result.year(firmRows);
    for j=2:length(year_sample)
        block_result.A(firmRows(j)) ...
             = prctile(block_result.A(block_result.year==year_sample(j) & block_result.secid==secid_sample(j)),block_result.A_pctile(firmRows(1)));
    end
end

block_result_temp = block_result;
block_result_temp.fringe = (block_result_temp.firmid<0);
block_result_temp = sortrows(block_result_temp, {'year','secid','fringe','firmid'}); % put fringe firm at the end

block_result = array2table(zeros(1,14), 'VariableNames',...
        {'firmid','year','s_total','s_y','s_k','s_l','A','tau_l','tau_k','mu_y','mu_l','DF','secid','age_bin'});

% Calculate sale share of fringe firm, and smooth it
fringe_share = zeros(length(year_vec),length(secid_manu));
for i=1:length(year_vec)
    for j=1:length(secid_manu)
        fringe_share(i,j) = (GO.GO(GO.year==year_vec(i) & GO.secid==j) ...
                        - sum(balance.sale(balance.year==year_vec(i) & balance.secid==j) )) ...
            / GO.GO(GO.year==year_vec(i) & GO.secid==j) ;
    end
end
% Take moving avereage on fringe firms' share
fringe_share = movmean(fringe_share,[5 5]);

exsh_check=zeros(length(year_vec),length(secid_manu));

for i=1:length(year_vec)
        year=year_vec(i)
        % Get the number of firms in each sector
        [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
        firm_counts = accumarray(loc, 1);
        firm_num = firm_counts + 1; % Number of firms + fringe firm
        total_firm = sum(firm_num) + length(secid_service); % Add fringe firms from service sector
        total_firm_vec(i) = total_firm;
    for j=1:length(secid_manu) % Back out wedge, productivity from manufacturing firms
        Par.sigma = est_result.sigma(j);
        Par.rho = Par.rho_base(j);
        Par.gamma_L = est_result.gl(j);
        Par.gamma_K = est_result.gk(j);
        Par.gamma_M = est_result.gm(j);
        Par.gamma_j = est_result.gl(j)+est_result.gk(j)+est_result.gm(j);
        
        mom.sale = balance.sale( balance.secid==j & balance.year==year_vec(i) );
        mom.fasset = balance.fasset( balance.secid==j & balance.year==year_vec(i) );
        mom.emp = balance.emp( balance.secid==j & balance.year==year_vec(i) );
        mom.G_sale = GO.GO( GO.secid==j & GO.year==year_vec(i));
        mom.G_export = EX.EX( EX.secid==j & EX.year==year_vec(i));
        mom.G_K = GK.K( GK.secid==j & GK.year==year_vec(i));
        mom.pi_H = 1 - imsh.imsh( imsh.secid==j & imsh.year==year_vec(i)); 
        mom.export = balance.export( balance.secid==j & balance.year==year_vec(i) );
        mom.firmid = [balance.firmid( balance.secid==j & balance.year==year_vec(i) );-1*j]; % -j: fringe firm
        mom.secid = j*ones(firm_num(j),1);
        mom.year = year * ones(firm_num(j),1);
        mom.fringe_share = fringe_share(i,j);
        mom.age_bin = [balance.age_bin(balance.secid==j & balance.year==year_vec(i));1];
        mom.A_vec = block_result_temp.A(block_result_temp.secid==j & block_result_temp.year==year_vec(i) & block_result_temp.firmid>0);
        [to_append,exsh_check(i,j)] = compute_block_only_tau_l(mom, Par, markup,markdown);
        block_result =[block_result; to_append];


    end
    % Add service sector (with only fringe firms)
    for j=1:length(secid_service)
        sigma = est_result.sigma(est_result.secid==secid_service(j));
        eta = Par.eta;
        to_append = array2table([-secid_service(j) year_vec(i) 1 1 1 1 1 1 1 sigma/(sigma-1) (eta+1)/eta 1 secid_service(j),1],...
        'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','DF','secid','age_bin'});
        block_result = [block_result; to_append];
    end

    % Truncate at the year level
    lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
    upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
    block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
    block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;

    % lower_bound = prctile(block_result.tau_k(block_result.year==year), 1);
    % upper_bound = prctile(block_result.tau_k(block_result.year==year), 99);
    % block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
    % block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;

    % lower_bound = prctile(block_result.A(block_result.year==year), 0.1);
    % upper_bound = prctile(block_result.A(block_result.year==year), 99.9);
    % block_result.A(block_result.A < lower_bound & block_result.year==year) = lower_bound;
    % block_result.A(block_result.A > upper_bound & block_result.year==year) = upper_bound;

    % upper_bound = prctile(block_result.DF(block_result.year==year), 99);
    % block_result.DF(block_result.DF > upper_bound & block_result.year==year) = upper_bound;
end

% Top 3 firms' capital wedge
block_result.minus_s_total = -block_result.s_total;
block_result.fringe = (block_result.firmid<0);
block_result.top3=zeros(length(block_result.s_total),1);
block_result_temp.minus_s_total = -block_result_temp.s_total;
block_result_temp.fringe = (block_result_temp.firmid<0);
block_result_temp.top3=zeros(length(block_result_temp.s_total),1);
for i=1:length(year_vec)
    for j=1:length(secid_manu)
        block_result.year_check=(block_result.year~=year_vec(i));
        block_result.sector_check=(block_result.secid~=j);            
        block_result = sortrows(block_result, {'year_check','sector_check','fringe','minus_s_total'});  
        block_result.top3(1:3) = 1;
        block_result_temp.year_check=(block_result_temp.year~=year_vec(i));
        block_result_temp.sector_check=(block_result_temp.secid~=j);            
        block_result_temp = sortrows(block_result_temp, {'year_check','sector_check','fringe','minus_s_total'});  
        block_result_temp.top3(1:3) = 1;
    end
end
block_result = sortrows(block_result,{'year','secid','firmid'});
block_result_temp = sortrows(block_result_temp,{'year','secid','firmid'});
tau_l_top3_vec = zeros(length(year_vec),length(secid_manu));
tau_l_top3_vec_separate = zeros(length(year_vec),length(secid_manu));
tau_l_others_vec_separate = zeros(length(year_vec),length(secid_manu));
s_l_top3_vec = zeros(length(year_vec),1);
s_l_top3_vec_base = zeros(length(year_vec),1);
for i=1:40
    for j=1:length(secid_manu)
         tau_l_top3_vec(i,j) = mean(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j & block_result.top3==1 & ~(block_result.firmid==5974 & block_result.year==1980) ))...
            ./mean(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j & block_result.firmid>0 & block_result.top3==0));
         tau_l_top3_vec_separate(i,j) = mean(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j & block_result.top3==1  ));
         tau_l_others_vec_separate(i,j) = mean(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j & block_result.firmid>0 & block_result.top3==0));
         s_l_top3_vec(i,j) = sum(block_result.s_l(block_result.year==year_vec(i) & block_result.secid==j & block_result.top3==1));
         s_l_top3_vec_base(i,j) = sum(block_result_temp.s_k(block_result_temp.year==year_vec(i) & block_result_temp.secid==j & block_result_temp.top3==1));
    end
end
GO_vec = reshape(GO.GO(GO.secid<=11),40,11);
L_vec = reshape(GL.L(GL.secid<=11),40,11);
L_vec = L_vec ./ sum(L_vec,2);
s_l_vec_only_tau_l = sum(s_l_top3_vec.*L_vec,2);
s_l_vec = sum(s_l_top3_vec_base.*L_vec,2);
C = linspecer(8);

% Take percentile of wedge
for i=1:length(year_vec)
for j=1:length(secid_manu)
    block_result.tau_l_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
        = invprctile(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j),...
        block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j));
    block_result.tau_k_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
        = invprctile(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j),...
        block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j));
end
end


tau_l_top3 = zeros(length(year_vec),1);
tau_l_top3_separate = zeros(length(year_vec),1);
tau_l_others_separate = zeros(length(year_vec),1);
for i=1:length(year_vec)
tau_l_top3(i) = wmean(tau_l_top3_vec(i,:),GO_vec(i,:));
tau_l_top3_separate(i) = wmean(tau_l_top3_vec_separate(i,:),GO_vec(i,:));
tau_l_others_separate(i) = wmean(tau_l_others_vec_separate(i,:),GO_vec(i,:));
% tau_k_top3(i) = mean(tau_k_top3_vec(i,:));
end

run making_figure7_CD.m


%% Solve full model
data.imsh = imsh;
data.exsh = exsh;
data.intsh = intsh;
data.ppi_data = ppi_data;
data.pop_data = pop_data;
data.hour_data = hour_data;
data.balance = balance;
data.fcons = fcons;
data.gdp_hat = gdp_hat;
data.K_hat = K_year.Khat;
data.K_hat = data.K_hat*0.6876; % To match K/Y=0.6876 in 1972
data.num_sector = num_sector;
data.secid_manu = secid_manu;
data.secid_service = secid_service;
data.secid_full = secid_full;
data.GO = GO;

Par.sigma = est_result.sigma;

x_guess_cell = {};
for i=1:length(year_vec)
    total_firm = total_firm_vec(i);
    x_guess_cell{i} =  [block_result.s_y(block_result.year==year_vec(i));...
                        block_result.s_l(block_result.year==year_vec(i))/length(secid_full)...
                        ;ones(num_sector,1);ones(num_sector,1);ones(2*num_sector,1);ones(num_sector,1)];
end

load(fullfile(matlab_dir,'A_year_guess_tau_l.mat'));

diff = 1;
iter = 0;
dmp = 0.15;
while diff>1e-2 && iter<1e+2
    [diff, A_year_next,x_guess_cell] = model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result, markup, markdown);
    if sum(isnan(A_year_next))>0
        break
    end
    A_year_guess = dmp*A_year_next + (1-dmp)*A_year_guess;
    iter = iter+1
    diff
    if diff<1e-1
        dmp=0.15;
    end        
end


[~,A_year_next,~,P_j_F_vec,phi_bar_vec,A_level_mat,A_avg_vec,util_vec,def_vec,...
    C_vec,L_vec,result,GDP_vec,D_j_F_vec,E_j_mat,alpha_j_mat,tau_k_wtd_avg_mat,tau_l_wtd_avg_mat,domar_weight,s_M,P_j_mat] = ...
    model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,markdown);

data.alpha_j_mat = alpha_j_mat;

% Aggregate level shocks
result_agg.P_j_F_vec = P_j_F_vec;
result_agg.phi_bar_vec = phi_bar_vec;
result_agg.def_vec = def_vec;

num_top=3;
result.top3 = zeros(height(result),1);
top3_list = zeros(length(year_vec),num_top*length(secid_manu));
for i=1:length(year_vec)
    result.minus_sale = -result.s_total;
    result.fringe = (result.firmid<0);
    result.year_check=(result.year~=year_vec(i));
    top3_list_year = [];
    for j=1:length(secid_manu)
        result.secid_check = (result.secid~=j);
        result = sortrows(result, {'year_check','secid_check','fringe','minus_sale'});  
        result.top3(1:num_top) = 1;
        top3_list_year = [top3_list_year;result.firmid(result.top3==1 & result.year==year_vec(i) & result.secid==j)];
    end
    result = sortrows(result,{'firmid'});
    top3_list(i,:) = top3_list_year;
end
result = sortrows(result,{'year','secid','firmid'});

% Aggregate level shocks
result_agg.P_j_F_vec = P_j_F_vec;
result_agg.phi_bar_vec = phi_bar_vec;
result_agg.def_vec = def_vec;
data.hour_data = hour_data.Lhpchat;

% Extract shocks in dynamics
warm_extract = struct();
if isfile(warm_file('warm_extract.mat'))
    load(warm_file('warm_extract.mat'),'warm_extract');
end
% warm_extract=[];
[E_t,K_star,P_star,R_star,Y_star,C_star,I_star,k_guess_until_ss,C_base,L_base,warm_extract]...
= model_extract_shock_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,warm_extract);
% save(warm_file('warm_extract.mat'),'warm_extract');

% Inputs needed by the factual and granular counterfactual solves.
result.A_rel = block_result.A / A_year_guess(1);
result.sale_vec = result.p_d.*result.y_d + result.p_x.*result.y_x;
result.export_vec = result.p_x.*result.y_x;
result.s_l = block_result.s_l;
result.s_k = block_result.s_k;
result.sale = result.sale_vec;

result_agg.P_j_F_vec = P_j_F_vec;
result_agg.phi_bar_vec = phi_bar_vec;
result_agg.def_vec = def_vec;
result_agg.C_base = C_base;
result_agg.L_base = L_base;
result_agg.domar_weight = domar_weight;
result_agg.s_M = s_M;

if false
A_avg_sector = zeros(length(year_vec),num_sector);
A_avg_sector_unweighted = zeros(length(year_vec),num_sector);
A_avg_sector_unweighted_entrant = zeros(length(year_vec),num_sector);
A_avg_vec = zeros(length(year_vec),1);
A_avg_manu = zeros(length(year_vec),1);
mu_y_avg_nofringe = zeros(length(year_vec),1);
mu_l_avg_nofringe = zeros(length(year_vec),1);
mu_y_avg_with_fringe = zeros(length(year_vec),1);
mu_l_avg_with_fringe = zeros(length(year_vec),1);
mu_y_agg = zeros(length(year_vec),1);
mu_l_agg  = zeros(length(year_vec),1);

DF_avg_sector = zeros(length(year_vec),num_sector);
DF_avg_sector_unweighted = zeros(length(year_vec),num_sector);
DF_avg_vec = zeros(length(year_vec),1);
DF_avg_manu = zeros(length(year_vec),1);

tau_l_var = zeros(length(year_vec),num_sector);
tau_k_var = zeros(length(year_vec),num_sector);
tau_l_var_avg = zeros(length(year_vec),1);
tau_k_var_avg = zeros(length(year_vec),1);
tau_l_avg_sector_unweighted = zeros(length(year_vec),num_sector);
tau_k_avg_sector_unweighted = zeros(length(year_vec),num_sector);
mu_y_agg_sector = zeros(length(year_vec),num_sector);
mu_l_agg_sector = zeros(length(year_vec),num_sector);
mu_y_avg_sector = zeros(length(year_vec),num_sector);

A_tau_l_corr_sector = zeros(length(year_vec),num_sector);
A_tau_k_corr_sector = zeros(length(year_vec),num_sector);
A_tau_l_corr = zeros(length(year_vec),1);
A_tau_k_corr = zeros(length(year_vec),1);
DF_tau_l_corr = zeros(length(year_vec),1);
DF_tau_k_corr = zeros(length(year_vec),1);
tau_l_top3_vec = zeros(length(year_vec),1);
tau_l_top3_vec = zeros(length(year_vec),1);
mu_l_top3_vec = zeros(length(year_vec),1);
mu_y_top3_vec = zeros(length(year_vec),1);
tau_k_avg =  zeros(length(year_vec),1);
tau_l_avg =  zeros(length(year_vec),1);
sale_sector = zeros(length(year_vec),num_sector);
top3_list =  [];
top3_seclist = [];
top3_tau_l = [];
top3_tau_k = [];
top3_mu_l = [];
top3_mu_y = [];
top3_A = [];
top3_A_avg = zeros(length(year_vec),1);
A_avg_nofringe = zeros(length(year_vec),1);
for i=1:length(year_vec)
        for j=1:num_sector
            sale_sector(i,j) = sum(result.sale_vec(result.year==year_vec(i) & result.secid==secid_full(j)) );
            A_fj_vec = result.A_fj(result.year==year_vec(i) & result.secid==secid_full(j) );
            sale_vec = result.sale_vec(result.year==year_vec(i) & result.secid==secid_full(j) );
            export_vec = result.export_vec(result.year==year_vec(i) & result.secid==secid_full(j) );
            y_d_vec = result.y_d(result.year==year_vec(i) & result.secid==secid_full(j) );
            y_x_vec = result.y_x(result.year==year_vec(i) & result.secid==secid_full(j) );

            sigma = est_result.sigma(est_result.secid==j);
            mu_y_tilde = result.mu_y(result.year==year_vec(i) & result.secid==secid_full(j))...
                                    .* (y_d_vec./(y_d_vec+y_x_vec)) + sigma./(sigma-1)* (y_x_vec./(y_d_vec+y_x_vec));
            mu_l_vec = result.mu_l(result.year==year_vec(i) & result.secid==secid_full(j) );
            DF_vec = result.DF(result.year==year_vec(i) & result.secid==secid_full(j) );
            tau_l_vec = result.tau_l(result.year==year_vec(i) & result.secid==secid_full(j) )-1;
            tau_k_vec = result.tau_k(result.year==year_vec(i) & result.secid==secid_full(j) )-1;
            
            A_avg_sector(i,j) = wmean(A_fj_vec, sale_vec);
            A_avg_sector_unweighted(i,j) = mean(A_fj_vec);
            A_avg_sector_unweighted_entrant(i,j) = mean(result.A_fj(result.new_firm==1 & result.year==year_vec(i) & result.secid==secid_full(j) ));
            tau_l_avg_sector_unweighted(i,j) = mean(tau_l_vec+1);
            tau_k_avg_sector_unweighted(i,j) = mean(tau_k_vec+1);
            
            DF_avg_sector(i,j) = wmean(DF_vec.^(1/(sigma-1)), export_vec)^((sigma-1)/1);
            DF_avg_sector_unweighted(i,j) = mean(DF_vec);
            tau_l_var(i,j) = std(tau_l_vec);
            tau_k_var(i,j) = std(tau_k_vec);

            mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec);
            mu_l_agg_sector(i,j) =  1/wmean( (mu_y_tilde.*mu_l_vec).^(-1), sale_vec)./mu_y_agg_sector(i,j);
        end
        A_fj_vec = result.A_fj(result.year==year_vec(i));
        A_fj_vec_wo_fringe = result.A_fj(result.year==year_vec(i) & result.firmid>0);
        A_fj_manu = result.A_fj(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        DF_vec = result.DF_real(result.year==year_vec(i));
        DF_manu = result.DF_real(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        sale_vec = result.sale_vec(result.year==year_vec(i));
        export_vec = result.export_vec(result.year==year_vec(i));
        tau_l_vec = result.tau_l(result.year==year_vec(i))-1;
        tau_k_vec = result.tau_k(result.year==year_vec(i))-1;
        tau_l_vec_wo_fringe = result.tau_l(result.year==year_vec(i) & result.firmid>0)-1;
        tau_k_vec_wo_fringe = result.tau_k(result.year==year_vec(i) & result.firmid>0)-1;
        
        sale_vec_manu = result.sale_vec(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        export_vec_manu = result.export_vec(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        
        A_avg_vec(i) = wmean(A_fj_vec,sale_vec);
        DF_avg_vec(i) = wmean(DF_vec,export_vec);
        tau_l_var_avg(i) = wmean(tau_l_var(i,secid_manu)',sale_sector(i,secid_manu)');
        tau_k_var_avg(i) = wmean(tau_k_var(i,secid_manu)',sale_sector(i,secid_manu)');
        mu_y_agg(i) = wmean(mu_y_agg_sector(i,secid_manu)',domar_weight(i,secid_manu)');
        mu_l_agg(i) = wmean(mu_l_agg_sector(i,secid_manu)',domar_weight(i,secid_manu)');
        A_avg_manu(i) = wmean(A_fj_manu,sale_vec_manu);
        DF_avg_manu(i) = wmean(DF_manu,export_vec_manu);
        A_tau_l_corr(i) = corr(tau_l_vec,A_fj_vec);
        A_tau_k_corr(i) = corr(tau_k_vec,A_fj_vec);

        DF_tau_l_corr(i) = corr(tau_l_vec,DF_vec);
        DF_tau_k_corr(i) = corr(tau_k_vec,DF_vec);
        tau_k_avg(i) = mean(tau_k_vec);
        tau_l_avg(i) = mean(tau_l_vec);
        
        % Excluding fringe firms
        result_nofringe = result(result.firmid>0,:);
        result_nofringe.minus_sale = -1*result_nofringe.sale_vec;
        result_nofringe = sortrows(result_nofringe, {'year','minus_sale'});  % Sort data by year, secid, and firmid 
        tau_l_temp=result_nofringe.tau_l(result_nofringe.year==year_vec(i))-1;
        tau_k_temp=result_nofringe.tau_k(result_nofringe.year==year_vec(i))-1;
        mu_l_temp = result_nofringe.mu_l(result_nofringe.year==year_vec(i));
        mu_y_temp = result_nofringe.mu_y(result_nofringe.year==year_vec(i));
        mu_l_with_fringe = result.mu_l(result.year==year_vec(i));
        mu_y_with_fringe = result.mu_y(result.year==year_vec(i));
        
        A_temp = result_nofringe.A_fj(result_nofringe.year==year_vec(i));
        tau_l_top3_vec(i) =  mean(tau_l_temp(1:10));
        tau_l_top3_vec(i) =  mean(tau_k_temp(1:10));
        mu_l_top3_vec(i) = mean(mu_l_temp(1:10));
        mu_y_top3_vec(i) = mean(mu_y_temp(1:10));
        
        firm_list_temp = result_nofringe.firmid(result_nofringe.year==year_vec(i));
        sec_list_temp = result_nofringe.secid(result_nofringe.year==year_vec(i));
        top3_A_avg(i) = mean(A_temp(1:10));
        A_avg_nofringe(i) = mean(A_temp);
        mu_y_avg_nofringe(i) = mean(mu_y_temp);
        mu_l_avg_nofringe(i) = mean(mu_l_temp);
        mu_y_avg_with_fringe(i) = wmean(mu_y_with_fringe,sale_vec);
        mu_l_avg_with_fringe(i) = wmean(mu_l_with_fringe,sale_vec);        
end

end

result.sale = result.p_d.*result.y_d + result.p_x.*result.y_x;
result = sortrows(result,{'firmid','year'});
% for i=1:height(result)
%     result.sale_10yrs_avg(i) = mean(result.sale(result.firmid==result.firmid(i) & result.year<=result.year(i)+9 & result.year>=result.year(i)));
% end
num_top=3;
result.top3 = zeros(height(result),1);
top3_list = zeros(length(year_vec),num_top*length(secid_manu));
for i=1:length(year_vec)
    result.minus_sale = -result.sale;
    result.fringe = (result.firmid<0);
    result.year_check=(result.year~=year_vec(i));
    top3_list_year = [];
    for j=1:length(secid_manu)
        result.secid_check = (result.secid~=j);
        result = sortrows(result, {'year_check','secid_check','fringe','minus_sale'});  
        result.top3(1:num_top) = 1;
        top3_list_year = [top3_list_year;result.firmid(result.top3==1 & result.year==year_vec(i) & result.secid==j)];
    end
    result = sortrows(result,{'firmid'});
    top3_list(i,:) = top3_list_year;
end
result = sortrows(result,{'year','secid','firmid'});

data.GO = GO;
data.alpha_j_mat = alpha_j_mat;

warm_baseline = struct();
if isfile(warm_file('warm_baseline.mat'))
    load(warm_file('warm_baseline.mat'),'warm_baseline');
end
[lmd_result(1),CR3_result(:,1),GDP_result(:,1),k_guess_until_ss,C_vec,L_vec,agg_result,result_final,warm_baseline]...
= solve_counterfactual_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,warm_baseline);
% save(warm_file('warm_baseline.mat'),'warm_baseline');
data.top3_list = top3_list;


tau_k_wtd_avg_mat = agg_result.tau_k_wtd_avg_mat;
tau_l_wtd_avg_mat = agg_result.tau_l_wtd_avg_mat;


%% Counterfactual - macro shocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove granular shock to all firms
age_max = max(result.age_bin);

% Get sector level unweighted average
result = sortrows(result,{'firmid', 'year'});
firmid_temp = result.firmid;
year_temp = result.year;
a_temp = result.A_fj;
df_temp = result.DF;
tau_l_temp = result.tau_l;
tau_k_temp = result.tau_k;

% Dummy whether it is same firm as previous, and consecutive year from previous one
result.continuing =[ 0; ( (firmid_temp(2:end) == firmid_temp(1:end-1)) & (year_temp(2:end) == year_temp(1:end-1)+1) )];
result.exporting = [0;( df_temp(2:end)>0 & df_temp(1:end-1)>0)];

a_g = [NaN ;(a_temp(2:end)./ a_temp(1:end-1))-1];
df_g = [NaN ;(df_temp(2:end) ./ df_temp(1:end-1))-1 ];
tau_l_g = [NaN ;(tau_l_temp(2:end)./ tau_l_temp(1:end-1))-1 ];
tau_k_g = [NaN ;(tau_k_temp(2:end)  ./  tau_k_temp(1:end-1))-1 ];

result.a_g(result.continuing==1) = a_g(result.continuing==1);
result.a_g(result.continuing==0) =NaN;
result.df_g(result.continuing==1 & result.exporting==1) = df_g(result.continuing==1 & result.exporting==1);
result.df_g(result.continuing==0 | result.exporting==0) =NaN;
result.tau_l_g(result.continuing==1) = tau_l_g(result.continuing==1);
result.tau_l_g(result.continuing==0) =NaN;
result.tau_k_g(result.continuing==1) = tau_k_g(result.continuing==1);
result.tau_k_g(result.continuing==0) =NaN;

a_g_sector = zeros(length(year_vec),length(secid_full),age_max);
df_g_sector = zeros(length(year_vec),length(secid_full),age_max);
tau_l_g_sector = zeros(length(year_vec),length(secid_full),age_max);
tau_k_g_sector = zeros(length(year_vec),length(secid_full),age_max);
result.a_g_trc = result.a_g;
result.df_g_trc = result.df_g;
result.tau_l_g_trc = result.tau_l_g;
result.tau_k_g_trc = result.tau_k_g;

% for i=1:length(year_vec)
for j=1:length(secid_manu)
    for k=1:age_max
    lower_bound = prctile(result.a_g(result.secid==j & result.age_bin==k), 20);
    upper_bound = prctile(result.a_g( result.secid==j & result.age_bin==k), 80);
    result.a_g_trc(result.a_g_trc <= lower_bound & result.secid==j & result.age_bin==k) = lower_bound;
    result.a_g_trc(result.a_g_trc >= upper_bound & result.secid==j & result.age_bin==k) = upper_bound;

    lower_bound = prctile(result.df_g(result.secid==j & result.age_bin==k), 20);
    upper_bound = prctile(result.df_g( result.secid==j & result.age_bin==k), 80);
    result.df_g_trc(result.df_g_trc <= lower_bound  & result.secid==j & result.age_bin==k) = lower_bound;
    result.df_g_trc(result.df_g_trc >= upper_bound & result.secid==j & result.age_bin==k) = upper_bound;

    lower_bound = prctile(result.tau_l_g( result.secid==j & result.age_bin==k), 20);
    upper_bound = prctile(result.tau_l_g( result.secid==j & result.age_bin==k), 80);
    result.tau_l_g_trc(result.tau_l_g_trc <= lower_bound  & result.secid==j & result.age_bin==k) = lower_bound;
    result.tau_l_g_trc(result.tau_l_g_trc >= upper_bound  & result.secid==j & result.age_bin==k) = upper_bound;

    lower_bound = prctile(result.tau_k_g(result.secid==j & result.age_bin==k), 20);
    upper_bound = prctile(result.tau_k_g(result.secid==j & result.age_bin==k), 80);
    result.tau_k_g_trc(result.tau_k_g_trc <= lower_bound  & result.secid==j & result.age_bin==k) = lower_bound;
    result.tau_k_g_trc(result.tau_k_g_trc >= upper_bound  & result.secid==j & result.age_bin==k ) = upper_bound;
    end
end



for i=1:length(year_vec)
for j=1:length(secid_full)
    for k=1:age_max
        a_g_sector(i,j,k)=mean(result.a_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.a_g) & result.age_bin==k  ) );
        df_g_sector(i,j,k)=mean(result.df_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.df_g) & result.age_bin==k  ) );
        tau_l_g_sector(i,j,k)=mean(result.tau_l_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.tau_l_g) & result.age_bin==k) );
        tau_k_g_sector(i,j,k)=mean(result.tau_k_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.tau_k_g) & result.age_bin==k ) );
    end
end
end
a_g_sector = (1+a_g_sector);
df_g_sector = (1+df_g_sector);
tau_l_g_sector = (1+tau_l_g_sector);
tau_k_g_sector = (1+tau_k_g_sector);

result.a_g = result.a_g_trc;
result.df_g = result.df_g_trc;
result.tau_l_g = result.tau_l_g_trc;
result.tau_k_g = result.tau_k_g_trc;

DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'df_g_sector','year','secid','age_bin'});
tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'tau_l_g_sector','year','secid','age_bin'});
tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'tau_k_g_sector','year','secid','age_bin'});
A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'a_g_sector','year','secid','age_bin'});

result = sortrows(result,{'year','secid','firmid'});

result_top3_granular = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_granular = join(result_top3_granular,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_granular = join(result_top3_granular,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_granular = join(result_top3_granular,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

result = sortrows(result,{'firmid', 'year'});
result_top3_granular = sortrows(result_top3_granular,{'firmid', 'year'});

top3_all=unique(result.firmid(result.top3==1)); % & result.firmid~=8973
% Construct only the granular counterfactual used for T_result.
for i = 1:length(top3_all)
firmRows = find(result.firmid==top3_all(i));
for j = 2:length(firmRows)
    row = firmRows(j);
    previous_row = firmRows(j-1);
    if result.continuing(row)==1 && result.top3(row)==1
        result_top3_granular.tau_k(row) = result_top3_granular.tau_k(previous_row) .* result_top3_granular.tau_k_g_sector(row);
        result_top3_granular.tau_l(row) = result_top3_granular.tau_l(previous_row) .* result_top3_granular.tau_l_g_sector(row);
        result_top3_granular.A_fj(row) = result_top3_granular.A_fj(previous_row) .* result_top3_granular.a_g_sector(row);
    elseif result.continuing(row)==1 && result.top3(row)==0
        result_top3_granular.tau_k(row) = result_top3_granular.tau_k(previous_row);
        result_top3_granular.tau_l(row) = result_top3_granular.tau_l(previous_row);
        result_top3_granular.A_fj(row) = result_top3_granular.A_fj(previous_row) .* (result_top3_granular.a_g(row)+1);
    end
    if result.continuing(row)==1 && result.exporting(row)==1 && result.top3(row)==1
        result_top3_granular.DF(row) = result_top3_granular.DF(previous_row) .* result_top3_granular.df_g_sector(row);
    elseif result.continuing(row)==1 && result.exporting(row)==1 && result.top3(row)==0
        result_top3_granular.DF(row) = result_top3_granular.DF(previous_row) .* (result_top3_granular.df_g(row)+1);
    end
end
end
result_top3_granular = sortrows(result_top3_granular,{'year','secid','firmid'});
result = sortrows(result,{'year','secid','firmid'});
result_top3_granular.DF(result_top3_granular.DF<0)=0;

% Superseded multi-scenario transformations, retained temporarily only for
% comparison with older results. They are not executed.
if false
for i = 1:length(top3_all)
firmRows = find(result.firmid==top3_all(i));
for j=1:length(firmRows)
    if result.continuing(firmRows(j))==1 && result.top3(firmRows(j)) == 1 % When it has consecutive observations & top 3
    result_top3_tau_k.tau_k(firmRows(j)) ...
        = result_top3_tau_k.tau_k(firmRows(j-1))...
        .*result_top3_tau_k.tau_k_g_sector(firmRows(j));        
    result_top3_tau_l.tau_l(firmRows(j)) ...
        = result_top3_tau_l.tau_l(firmRows(j-1))...
        .*result_top3_tau_l.tau_l_g_sector(firmRows(j));        
    result_top3_a_sector.A_fj(firmRows(j)) ...
        = result_top3_a_sector.A_fj(firmRows(j-1))...
        .*result_top3_a_sector.a_g_sector(firmRows(j));
    result_top3_a_agg.A_fj(firmRows(j)) ...
        = result_top3_a_agg.A_fj(firmRows(j-1))...
        .*result_top3_a_agg.a_g_agg(firmRows(j));
    result_top3_a_init_agg.A_fj(firmRows(j)) ...
        = result_top3_a_init_agg.A_fj(firmRows(j-1))...
        .*(result_top3_a_init_agg.a_g(firmRows(j))+1);
    result_top3_a_init_sector.A_fj(firmRows(j)) ...
        = result_top3_a_init_sector.A_fj(firmRows(j-1))...
        .*(result_top3_a_init_sector.a_g(firmRows(j))+1);
    result_top3_a_init_g_agg.A_fj(firmRows(j)) ...
        = result_top3_a_init_g_agg.A_fj(firmRows(j-1))...
        .*result_top3_a_init_g_agg.a_g_agg(firmRows(j));
    result_top3_a_init_g_sector.A_fj(firmRows(j)) ...
        = result_top3_a_init_g_sector.A_fj(firmRows(j-1))...
        .*result_top3_a_init_g_sector.a_g_sector(firmRows(j));
    result_top3_granular.tau_k(firmRows(j)) ...
        = result_top3_granular.tau_k(firmRows(j-1))...
        .*result_top3_granular.tau_k_g_sector(firmRows(j));
    result_top3_granular.tau_l(firmRows(j)) ...
        = result_top3_granular.tau_l(firmRows(j-1))...
        .*result_top3_granular.tau_l_g_sector(firmRows(j));
    result_top3_granular.A_fj(firmRows(j)) ...
        = result_top3_granular.A_fj(firmRows(j-1))...
        .*result_top3_granular.a_g_sector(firmRows(j));
    elseif result.continuing(firmRows(j))==0  && result.year(firmRows(j))~=year_vec(1)
        result_top3_a_init_agg.A_fj(firmRows(j)) = result_top3_a_init_agg.a_level_agg(firmRows(j));
        result_top3_a_init_g_agg.A_fj(firmRows(j)) = result_top3_a_init_g_agg.a_level_agg(firmRows(j));
        result_top3_a_init_sector.A_fj(firmRows(j)) = result_top3_a_init_sector.a_level_sector(firmRows(j));
        result_top3_a_init_g_sector.A_fj(firmRows(j)) = result_top3_a_init_g_sector.a_level_sector(firmRows(j));
    elseif result.continuing(firmRows(j))==1 && result.top3(firmRows(j)) == 0     
    result_top3_tau_k.tau_k(firmRows(j)) ...
        = result_top3_tau_k.tau_k(firmRows(j-1));        
    result_top3_tau_l.tau_l(firmRows(j)) ...
        = result_top3_tau_l.tau_l(firmRows(j-1)); 
    result_top3_a_sector.A_fj(firmRows(j)) ...
        = result_top3_a_sector.A_fj(firmRows(j-1))...
        .*(result_top3_a_sector.a_g(firmRows(j))+1);
    result_top3_a_agg.A_fj(firmRows(j)) ...
        = result_top3_a_agg.A_fj(firmRows(j-1))...
        .*(result_top3_a_agg.a_g(firmRows(j))+1);
    result_top3_a_init_agg.A_fj(firmRows(j)) ...
        = result_top3_a_init_agg.A_fj(firmRows(j-1))...
        .*(result_top3_a_init_agg.a_g(firmRows(j))+1);
    result_top3_a_init_sector.A_fj(firmRows(j)) ...
        = result_top3_a_init_sector.A_fj(firmRows(j-1))...
        .*(result_top3_a_init_sector.a_g(firmRows(j))+1);
    result_top3_a_init_g_agg.A_fj(firmRows(j)) ...
        = result_top3_a_init_g_agg.A_fj(firmRows(j-1))...
        .*(result_top3_a_init_g_agg.a_g(firmRows(j))+1);
    result_top3_a_init_g_sector.A_fj(firmRows(j)) ...
        = result_top3_a_init_g_sector.A_fj(firmRows(j-1))...
        .*(result_top3_a_init_g_sector.a_g(firmRows(j))+1);
    result_top3_granular.tau_k(firmRows(j)) ...
        = result_top3_granular.tau_k(firmRows(j-1));
    result_top3_granular.tau_l(firmRows(j)) ...
        = result_top3_granular.tau_l(firmRows(j-1));
    result_top3_granular.A_fj(firmRows(j)) ...
        = result_top3_granular.A_fj(firmRows(j-1))...
        .*(result_top3_granular.a_g(firmRows(j))+1);
    end
    if result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1 && result.top3(firmRows(j)) == 1
        result_top3_DF.DF(firmRows(j)) ...
            = result_top3_DF.DF(firmRows(j-1))...
            .*result_top3_DF.df_g_sector(firmRows(j));
        result_top3_granular.DF(firmRows(j)) ...
            = result_top3_granular.DF(firmRows(j-1))...
            .*result_top3_granular.df_g_sector(firmRows(j));
    elseif result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1 && result.top3(firmRows(j)) == 0
        result_top3_DF.DF(firmRows(j)) ...
            = result_top3_DF.DF(firmRows(j-1))...
            .*(result_top3_DF.df_g(firmRows(j))+1);
        result_top3_granular.DF(firmRows(j)) ...
            = result_top3_granular.DF(firmRows(j-1))...
            .*(result_top3_granular.df_g(firmRows(j))+1);
    end
end
end

result_top3_a_sector=sortrows(result_top3_a_sector,{'year','secid','firmid'});
result_top3_a_agg=sortrows(result_top3_a_agg,{'year','secid','firmid'});
result_top3_a_init_agg=sortrows(result_top3_a_init_agg,{'year','secid','firmid'});
result_top3_a_init_sector=sortrows(result_top3_a_init_sector,{'year','secid','firmid'});
result_top3_a_init_g_agg=sortrows(result_top3_a_init_g_agg,{'year','secid','firmid'});
result_top3_a_init_g_sector=sortrows(result_top3_a_init_g_sector,{'year','secid','firmid'});
result_top3_DF=sortrows(result_top3_DF,{'year','secid','firmid'});
result_top3_tau_k= sortrows(result_top3_tau_k,{'year','secid','firmid'});
result_top3_tau_l = sortrows(result_top3_tau_l,{'year','secid','firmid'});
result_top3_granular = sortrows(result_top3_granular,{'year','secid','firmid'});
result = sortrows(result,{'year','secid','firmid'});

result_top3_DF.DF(result_top3_DF.DF<0)=0;
result_top3_granular.DF(result_top3_granular.DF<0)=0;
end

warm_granular = struct();
if isfile(warm_file('warm_granular.mat'))
load(warm_file('warm_granular.mat'),'warm_granular');
end
has_granular_warm_start = ~isempty(fieldnames(warm_granular));
try
    [lmd_granular,~,GDP_granular,~,~,~,agg_granular_top3,~,warm_granular] ...
    = solve_counterfactual_tau_dynamics(result_top3_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_granular);
catch ME
    if has_granular_warm_start && ...
            strcmp(ME.identifier,'model_relative_residual:NonfiniteIterate')
        warning('solve_full_model_only_tau_l:WarmStartFallback', ...
            ['The granular tau warm start became nonfinite. Retrying this ' ...
             'counterfactual once without the cache.']);
        warm_granular = struct();
        [lmd_granular,~,GDP_granular,~,~,~,agg_granular_top3,~,warm_granular] ...
        = solve_counterfactual_tau_dynamics(result_top3_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_granular);
    else
        rethrow(ME);
    end
end
% save(warm_file('warm_granular.mat'),'warm_granular');

load(fullfile(result_dir,'CR3_base.mat'))
T_result = [(agg_granular_top3.CR3_vec(end)-CR3_end)*100 (GDP_granular(end)/GDP_result(end)-1)*100 lmd_granular];
save(fullfile(result_dir,'result_only_tau_l.mat'),'T_result','-v7.3')


