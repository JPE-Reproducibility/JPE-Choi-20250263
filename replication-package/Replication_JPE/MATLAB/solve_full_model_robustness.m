function []=solve_full_model_robustness(spec)
% MAIN CODE
% Written by Younghun Shim
spec_name = char(spec);
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
    error('solve_full_model_robustness:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
use_with_variety = string(spec) == "with_variety";
warm_cache_dir = fullfile(matlab_dir,'warm_start','robustness');
baseline_warm_dir = fullfile(matlab_dir,'warm_start');
result_dir = fullfile(matlab_dir,'result');
if ~use_with_variety && ~isfolder(warm_cache_dir)
    mkdir(warm_cache_dir);
end
if ~isfolder(result_dir)
    mkdir(result_dir);
end
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

% spec = "chi_05";

run set_parameters_load_data.m
Par.with_variety = use_with_variety;


% est_result.sigma = 3*ones(length(est_result.sigma),1);
% Par.sigma=3;
% Par.theta=1.5;
% CRS
% est_result.g = est_result.gl+est_result.gk+est_result.gm;
% est_result.gl = est_result.gl./est_result.g;
% est_result.gk = est_result.gk./est_result.g;
% est_result.gm = est_result.gm./est_result.g;
% est_result.g = est_result.gl+est_result.gk+est_result.gm;

%% Calculate wedge and productivity using Proposition 2.1
block_result = array2table(zeros(1,14), 'VariableNames',...
        {'firmid','year','s_total','s_y','s_k','s_l','A','tau_l','tau_k','mu_y','mu_l','DF','secid','age_bin'});

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

% writetable(block_result,OUTPUT+'block_result.csv');
if sum(isnan(block_result.DF))+sum(isnan(block_result.tau_l))+sum(isnan(block_result.tau_k))>0
    disp("NAN")
end

% Take moving average
block_result = sortrows(block_result, {'firmid', 'year'});  % Sort data by ID, then by year
unique_id = unique(block_result.firmid);  % Find all unique IDs
A_ma = [];  % Initialize array to hold moving averages
tau_l_ma = [];
tau_k_ma = [];
DF_ma = [];
for i = 1:length(unique_id)
%     Extract data for current ID
    currentData = block_result(block_result.firmid == unique_id(i), :);
%     Append to overall array
    A_ma = [A_ma; movmean(currentData.A, [2 2])];
    tau_l_ma = [tau_l_ma; movmean(currentData.tau_l, [2 2])];
    tau_k_ma = [tau_k_ma; movmean(currentData.tau_k, [2 2])];
    DF_ma = [DF_ma; movmean(currentData.DF, [2 2])];

end
block_result.A = A_ma;
block_result.tau_l = tau_l_ma;
block_result.tau_k = tau_k_ma;
block_result.DF = DF_ma;


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

block_result = sortrows(block_result, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
% writetable(block_result,OUTPUT+'block_result.csv');

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
data.K_hat = K_year.Khat; % How to normalize capital stock ? It matters for E^*
% k_norm = mean(data.K_hat./gdp_hat)/0.9738; % To match average K/GDP = 0.9738 from the data.
data.K_hat = data.K_hat*0.6876; % To match K/Y=0.6876 in 1972
% data.K_hat = K_year.Khat; % How to normalize capital stock ? It matters for E^*
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
load(fullfile(matlab_dir,'A_year_guess_capital.mat'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% First, back out aggregate productivity by matching GDP growth rate; 
%%% for this, we take capital as given, and do not solve dynamic problems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    C_vec,L_vec,result,GDP_vec,D_j_F_vec,E_j_mat,alpha_j_mat,~,~,domar_weight,s_M,P_j_mat] = ...
    model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,markdown);
    
data.alpha_j_mat = alpha_j_mat;

% Collect some results in table
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Next, we extract shocks in dynamics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if use_with_variety
    % Variety changes welfare only, so use the factual baseline equilibrium
    % warm start rather than maintaining a duplicate robustness cache.
    warm_extract = struct();
    cache_file = fullfile(baseline_warm_dir,'warm_base.mat');
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_base')
            warm_extract = cache_contents.warm_base;
        end
    end
else
    warm_extract = struct();
    cache_file = fullfile(warm_cache_dir,[spec_name '_extract.mat']);
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_extract')
            warm_extract = cache_contents.warm_extract;
        end
    end
end
[E_t,K_star,P_star,R_star,Y_star,C_star,I_star,k_vec_extracted,C_base,L_base,warm_extract]...
= model_extract_shock_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,warm_extract);
if ~use_with_variety
    % save(cache_file,'warm_extract','-v7.3');
end

run collect_results_robust.m

% Run solve counterfactual with a given shock
data.GO = GO;
data.alpha_j_mat = alpha_j_mat;
data.hour_data = hour_data.Lhpchat;
if use_with_variety
    cache_file = fullfile(baseline_warm_dir,'warm_counterfactual_base.mat');
    warm_counterfactual_base = struct();
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_counterfactual_base')
            warm_counterfactual_base = cache_contents.warm_counterfactual_base;
        end
    end
    warm_baseline = warm_counterfactual_base;
else
    warm_baseline = struct();
    cache_file = fullfile(warm_cache_dir,[spec_name '_baseline.mat']);
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_baseline')
            warm_baseline = cache_contents.warm_baseline;
        end
    end
end
[lmd_result(1),CR3_result(:,1),GDP_result(:,1),k_guess_until_ss,C_vec,L_vec,agg_result,result_final,warm_baseline]...
= solve_counterfactual_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,warm_baseline);
if ~use_with_variety
    % save(cache_file,'warm_baseline','-v7.3');
end

C_base = C_vec(1:40);
L_base = L_vec;

data.top3_list = top3_list;


tau_k_wtd_avg_mat = agg_result.tau_k_wtd_avg_mat;
tau_l_wtd_avg_mat = agg_result.tau_l_wtd_avg_mat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Counterfactual - granular shocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run removing_granular_shocks.m

if use_with_variety
    cache_file = fullfile(baseline_warm_dir,'warm_counterfactual_a.mat');
    warm_granular_a = struct();
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_counterfactual_a')
            warm_granular_a = cache_contents.warm_counterfactual_a;
        end
    end
else
    warm_granular_a = struct();
    cache_file = fullfile(warm_cache_dir,[spec_name '_granular_a.mat']);
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_granular_a')
            warm_granular_a = cache_contents.warm_granular_a;
        end
    end
end
[lmd_granular_top3(1),CR3_granular_top3(:,1),GDP_granular_top3(:,1),K_granular_top3(:,1),C_granular_top3(:,1),L_granular_top3(:,1),agg_granular_top3_a,result_final_top3_a,warm_granular_a] ...
= solve_counterfactual_dynamics(result_top3_a_sector,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,warm_granular_a);
if ~use_with_variety
    % save(cache_file,'warm_granular_a','-v7.3');
end

if use_with_variety
    cache_file = fullfile(baseline_warm_dir,'warm_counterfactual_top3.mat');
    warm_granular_all = struct();
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_counterfactual_top3')
            warm_granular_all = cache_contents.warm_counterfactual_top3;
        end
    end
else
    warm_granular_all = struct();
    cache_file = fullfile(warm_cache_dir,[spec_name '_granular_all.mat']);
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_granular_all')
            warm_granular_all = cache_contents.warm_granular_all;
        end
    end
end
[lmd_granular_top3(5),CR3_granular_top3(:,5),GDP_granular_top3(:,5),K_granular_top3(:,5),C_granular_top3(:,5),L_granular_top3(:,5),agg_granular_top3,result_final_top3,warm_granular_all] ...
= solve_counterfactual_tau_dynamics(result_top3_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_granular_all);
if ~use_with_variety
    % save(cache_file,'warm_granular_all','-v7.3');
end

T_robust = [(agg_granular_top3.CR3_vec(end)-agg_result.CR3_vec(end))*100 (GDP_granular_top3(end,5)/GDP_result(end)-1)*100 lmd_granular_top3(5) ...
(agg_granular_top3_a.CR3_vec(end)-agg_result.CR3_vec(end))*100 (GDP_granular_top3(end,1)/GDP_result(end)-1)*100 lmd_granular_top3(1)];
save(fullfile(result_dir,['result_robust_' spec_name '.mat']),'T_robust','-v7.3')
