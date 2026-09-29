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
    error('solve_full_model_part1:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
warm_start_dir = fullfile(matlab_dir,'warm_start');
if ~isfolder(warm_start_dir)
    mkdir(warm_start_dir);
end
warm_file = @(name) fullfile(warm_start_dir,name);
result_dir = fullfile(matlab_dir,'result');
if ~isfolder(result_dir)
    mkdir(result_dir);
end

INPUT = string(fullfile(project_root,'INPUT')) + filesep;
OUTPUT = string(fullfile(project_root,'OUTPUT')) + filesep;
figure = string(fullfile(project_root,'FIGURE')) + filesep;
table = string(fullfile(project_root,'TABLE')) + filesep;
if ~isfolder(OUTPUT)
    mkdir(OUTPUT);
end
if ~isfolder(figure)
    mkdir(figure);
end
if ~isfolder(table)
    mkdir(table);
end


% markup / markdown on off
markup = 1;
markdown = 1;

spec="baseline"
save_option="";
% save_option="_notruncation";
% save_option="_nosmoothing";
% save_option="_notruncation_nosmoothing";

run set_parameters_load_data.m

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
    if save_option~="_notruncation" & save_option~="_notruncation_nosmoothing"

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

end

if sum(isnan(block_result.DF))+sum(isnan(block_result.tau_l))+sum(isnan(block_result.tau_k))>0
    disp("NAN")
end

if save_option~="_nosmoothing" & save_option~="_notruncation_nosmoothing"

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

end


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
result.top4 = zeros(height(result),1);
result.top10 = zeros(height(result),1);

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
        num_top4 = min(4,sum(result.year_check==0 & result.secid_check==0 & result.fringe==0));
        result.top4(1:num_top4) = 1;
        num_top10 = min(10,sum(result.year_check==0 & result.secid_check==0 & result.fringe==0));
        result.top10(1:num_top10) = 1;
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

run collect_results1.m

% writetable(result,OUTPUT+'result_base'+save_option+'.csv')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Next, we extract shocks in dynamics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warm_base = struct();
cache_file = warm_file('warm_base.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_base')
        warm_base = cache_contents.warm_base;
    end
end

[E_t,K_star,P_star,R_star,Y_star,C_star,I_star,k_vec_extracted,C_base,L_base,warm_base]...
= model_extract_shock_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,warm_base);
% save(cache_file,'warm_base','-v7.3');



% Run solve counterfactual with a given shock
data.GO = GO;
data.alpha_j_mat = alpha_j_mat;
data.hour_data = hour_data.Lhpchat;

warm_counterfactual_base = struct();
cache_file = warm_file('warm_counterfactual_base.mat');
if isfile(cache_file)
    loaded_warm_counterfactual = load(...
        cache_file,'warm_counterfactual_base');
    if isfield(loaded_warm_counterfactual,'warm_counterfactual_base')
        warm_counterfactual_base = ...
            loaded_warm_counterfactual.warm_counterfactual_base;
    end
end

[lmd_result(1),CR3_result(:,1),GDP_result(:,1),k_guess_until_ss,C_vec,L_vec,agg_result,result_final,warm_counterfactual_base]...
= solve_counterfactual_dynamics(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,warm_counterfactual_base);
% save(cache_file,'warm_counterfactual_base','-v7.3');

C_base = C_vec(1:40);
L_base = L_vec;

data.top3_list = top3_list;


tau_k_wtd_avg_mat = agg_result.tau_k_wtd_avg_mat;
tau_l_wtd_avg_mat = agg_result.tau_l_wtd_avg_mat;

run making_figure2.m
run making_figure3.m
run making_figureB5.m
run making_table2.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Counterfactual - granular shocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run removing_granular_shocks.m

% % How much productivity decreased for top-3 firms? 
% mean(result_top3_a_sector.A_fj(result_top3_a_sector.top3==1 & result_top3_a_sector.year==2011)) / ...
%     mean(result.A_fj(result.top3==1 & result.year==2011))

counterfactual_results = {result_top3_a_sector; result_top3_DF; ...
    result_top3_tau_k; result_top3_tau_l; result_top3_granular};
cache_file_names = {'warm_counterfactual_a.mat'; 'warm_counterfactual_DF.mat'; ...
    'warm_counterfactual_tau_k.mat'; 'warm_counterfactual_tau_l.mat'; ...
    'warm_counterfactual_top3.mat'};
cache_files = cellfun(warm_file,cache_file_names,'UniformOutput',false);
cache_variable_names = {'warm_counterfactual_a'; 'warm_counterfactual_DF'; ...
    'warm_counterfactual_tau_k'; 'warm_counterfactual_tau_l'; ...
    'warm_counterfactual_top3'};
tau_targets = {[]; []; tau_k_wtd_avg_mat; tau_l_wtd_avg_mat; ...
    [tau_k_wtd_avg_mat tau_l_wtd_avg_mat]};
tau_types = [0; 0; 1; 2; 3];

warm_counterfactual_all = cell(5,1);
agg_granular_top3_all = cell(5,1);
result_final_top3_all = cell(5,1);
for counterfactual_idx=1:5
    warm_counterfactual_all{counterfactual_idx} = struct();
    if isfile(cache_files{counterfactual_idx})
        cache_contents = load(cache_files{counterfactual_idx});
        cache_variable_name = cache_variable_names{counterfactual_idx};
        if isfield(cache_contents,cache_variable_name)
            warm_counterfactual_all{counterfactual_idx} = ...
                cache_contents.(cache_variable_name);
        elseif isfield(cache_contents,'warm_counterfactual')
            % Supports a/DF cache files saved under the earlier generic name.
            warm_counterfactual_all{counterfactual_idx} = ...
                cache_contents.warm_counterfactual;
        end
    end

    if tau_types(counterfactual_idx)==0
        [lmd_granular_top3(counterfactual_idx),...
            CR3_granular_top3(:,counterfactual_idx),...
            GDP_granular_top3(:,counterfactual_idx),...
            K_granular_top3(:,counterfactual_idx),...
            C_granular_top3(:,counterfactual_idx),...
            L_granular_top3(:,counterfactual_idx),...
            agg_granular_top3_all{counterfactual_idx},...
            result_final_top3_all{counterfactual_idx},...
            warm_counterfactual_all{counterfactual_idx}] = ...
            solve_counterfactual_dynamics(counterfactual_results{counterfactual_idx},...
                result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,...
                L_base,k_guess_until_ss,warm_counterfactual_all{counterfactual_idx});
    else
        [lmd_granular_top3(counterfactual_idx),...
            CR3_granular_top3(:,counterfactual_idx),...
            GDP_granular_top3(:,counterfactual_idx),...
            K_granular_top3(:,counterfactual_idx),...
            C_granular_top3(:,counterfactual_idx),...
            L_granular_top3(:,counterfactual_idx),...
            agg_granular_top3_all{counterfactual_idx},...
            result_final_top3_all{counterfactual_idx},...
            warm_counterfactual_all{counterfactual_idx}] = ...
            solve_counterfactual_tau_dynamics(counterfactual_results{counterfactual_idx},...
                result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,...
                L_base,k_guess_until_ss,tau_targets{counterfactual_idx},...
                tau_types(counterfactual_idx),...
                warm_counterfactual_all{counterfactual_idx});
    end
end

agg_granular_top3_a = agg_granular_top3_all{1};
agg_granular_top3_DF = agg_granular_top3_all{2};
agg_granular_top3_tau_k = agg_granular_top3_all{3};
agg_granular_top3_tau_l = agg_granular_top3_all{4};
agg_granular_top3 = agg_granular_top3_all{5};
result_final_top3_a = result_final_top3_all{1};
result_final_top3_DF = result_final_top3_all{2};
result_final_top3_tau_k = result_final_top3_all{3};
result_final_top3_tau_l = result_final_top3_all{4};
result_final_top3 = result_final_top3_all{5};
warm_counterfactual_a = warm_counterfactual_all{1};
warm_counterfactual_DF = warm_counterfactual_all{2};
warm_counterfactual_tau_k = warm_counterfactual_all{3};
warm_counterfactual_tau_l = warm_counterfactual_all{4};
warm_counterfactual_top3 = warm_counterfactual_all{5};

% save(warm_file('warm_counterfactual_a.mat'),'warm_counterfactual_a','-v7.3');
% save(warm_file('warm_counterfactual_DF.mat'),'warm_counterfactual_DF','-v7.3');
% save(warm_file('warm_counterfactual_tau_k.mat'),'warm_counterfactual_tau_k','-v7.3');
% save(warm_file('warm_counterfactual_tau_l.mat'),'warm_counterfactual_tau_l','-v7.3');
% save(warm_file('warm_counterfactual_top3.mat'),'warm_counterfactual_top3','-v7.3');

T_result = [(agg_granular_top3.CR3_vec(end)-agg_result.CR3_vec(end))*100 (GDP_granular_top3(end,5)/GDP_result(end)-1)*100 lmd_granular_top3(5) ...
(agg_granular_top3_a.CR3_vec(end)-agg_result.CR3_vec(end))*100 (GDP_granular_top3(end,1)/GDP_result(end)-1)*100 lmd_granular_top3(1)];
save(fullfile(result_dir,'result_base.mat'),'T_result','-v7.3')

CR3_end=agg_result.CR3_vec(end);
save(fullfile(result_dir,'CR3_base.mat'),'CR3_end','-v7.3');

run making_figure4.m
run making_figureB13.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Samsung counterfactual %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run removing_samsung_shocks.m

samsung_results = {result_samsung_a; result_samsung_DF; result_samsung_tau_k; ...
    result_samsung_tau_l; result_samsung};
samsung_cache_file_names = {'warm_samsung_a.mat'; 'warm_samsung_DF.mat'; ...
    'warm_samsung_tau_k.mat'; 'warm_samsung_tau_l.mat'; 'warm_samsung.mat'};
samsung_cache_files = cellfun(warm_file,samsung_cache_file_names,'UniformOutput',false);
samsung_cache_variables = {'warm_samsung_a'; 'warm_samsung_DF'; ...
    'warm_samsung_tau_k'; 'warm_samsung_tau_l'; 'warm_samsung'};
samsung_tau_targets = {[]; []; tau_k_wtd_avg_mat; tau_l_wtd_avg_mat; ...
    [tau_k_wtd_avg_mat tau_l_wtd_avg_mat]};
samsung_tau_types = [0; 0; 1; 2; 3];
warm_samsung_all = cell(5,1);
agg_samsung_all = cell(5,1);
result_final_samsung_all = cell(5,1);
for samsung_idx=1:5
    warm_samsung_all{samsung_idx} = struct();
    if isfile(samsung_cache_files{samsung_idx})
        cache_contents = load(samsung_cache_files{samsung_idx});
        cache_variable_name = samsung_cache_variables{samsung_idx};
        if isfield(cache_contents,cache_variable_name)
            warm_samsung_all{samsung_idx} = cache_contents.(cache_variable_name);
        elseif isfield(cache_contents,'warm_counterfactual')
            warm_samsung_all{samsung_idx} = cache_contents.warm_counterfactual;
        end
    end

    if samsung_tau_types(samsung_idx)==0
        [lmd_samsung(samsung_idx),CR3_samsung(:,samsung_idx),...
            GDP_samsung(:,samsung_idx),~,~,~,agg_samsung_all{samsung_idx},...
            result_final_samsung_all{samsung_idx},warm_samsung_all{samsung_idx}] = ...
            solve_counterfactual_dynamics(samsung_results{samsung_idx},...
                result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,...
                L_base,k_guess_until_ss,warm_samsung_all{samsung_idx});
    else
        [lmd_samsung(samsung_idx),CR3_samsung(:,samsung_idx),...
            GDP_samsung(:,samsung_idx),~,~,~,agg_samsung_all{samsung_idx},...
            result_final_samsung_all{samsung_idx},warm_samsung_all{samsung_idx}] = ...
            solve_counterfactual_tau_dynamics(samsung_results{samsung_idx},...
                result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,...
                L_base,k_guess_until_ss,samsung_tau_targets{samsung_idx},...
                samsung_tau_types(samsung_idx),warm_samsung_all{samsung_idx});
    end
end

agg_samsung_a = agg_samsung_all{1};
agg_samsung_DF = agg_samsung_all{2};
agg_samsung_tau_k = agg_samsung_all{3};
agg_samsung_tau_l = agg_samsung_all{4};
agg_samsung = agg_samsung_all{5};
result_final_samsung_a = result_final_samsung_all{1};
result_final_samsung_DF = result_final_samsung_all{2};
result_final_samsung_tau_k = result_final_samsung_all{3};
result_final_samsung_tau_l = result_final_samsung_all{4};
result_final_samsung = result_final_samsung_all{5};
warm_samsung_a = warm_samsung_all{1};
warm_samsung_DF = warm_samsung_all{2};
warm_samsung_tau_k = warm_samsung_all{3};
warm_samsung_tau_l = warm_samsung_all{4};
warm_samsung = warm_samsung_all{5};

% save(warm_file('warm_samsung_a.mat'),'warm_samsung_a','-v7.3');
% save(warm_file('warm_samsung_DF.mat'),'warm_samsung_DF','-v7.3');
% save(warm_file('warm_samsung_tau_k.mat'),'warm_samsung_tau_k','-v7.3');
% save(warm_file('warm_samsung_tau_l.mat'),'warm_samsung_tau_l','-v7.3');
% save(warm_file('warm_samsung.mat'),'warm_samsung','-v7.3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% hyundai counterfactual %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run removing_hyundai_shocks.m

hyundai_results = {result_hyundai_a; result_hyundai_DF; result_hyundai_tau_k; ...
    result_hyundai_tau_l; result_hyundai};
hyundai_cache_file_names = {'warm_hyundai_a.mat'; 'warm_hyundai_DF.mat'; ...
    'warm_hyundai_tau_k.mat'; 'warm_hyundai_tau_l.mat'; 'warm_hyundai.mat'};
hyundai_cache_files = cellfun(warm_file,hyundai_cache_file_names,'UniformOutput',false);
hyundai_cache_variables = {'warm_hyundai_a'; 'warm_hyundai_DF'; ...
    'warm_hyundai_tau_k'; 'warm_hyundai_tau_l'; 'warm_hyundai'};
hyundai_tau_targets = {[]; []; tau_k_wtd_avg_mat; tau_l_wtd_avg_mat; ...
    [tau_k_wtd_avg_mat tau_l_wtd_avg_mat]};
hyundai_tau_types = [0; 0; 1; 2; 3];
warm_hyundai_all = cell(5,1);
agg_hyundai_all = cell(5,1);
result_final_hyundai_all = cell(5,1);
for hyundai_idx=1:5
    warm_hyundai_all{hyundai_idx} = struct();
    if isfile(hyundai_cache_files{hyundai_idx})
        cache_contents = load(hyundai_cache_files{hyundai_idx});
        cache_variable_name = hyundai_cache_variables{hyundai_idx};
        if isfield(cache_contents,cache_variable_name)
            warm_hyundai_all{hyundai_idx} = cache_contents.(cache_variable_name);
        elseif isfield(cache_contents,'warm_counterfactual')
            warm_hyundai_all{hyundai_idx} = cache_contents.warm_counterfactual;
        end
    end

    if hyundai_tau_types(hyundai_idx)==0
        [lmd_hyundai(hyundai_idx),CR3_hyundai(:,hyundai_idx),...
            GDP_hyundai(:,hyundai_idx),~,~,~,agg_hyundai_all{hyundai_idx},...
            result_final_hyundai_all{hyundai_idx},warm_hyundai_all{hyundai_idx}] = ...
            solve_counterfactual_dynamics(hyundai_results{hyundai_idx},...
                result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,...
                L_base,k_guess_until_ss,warm_hyundai_all{hyundai_idx});
    else
        [lmd_hyundai(hyundai_idx),CR3_hyundai(:,hyundai_idx),...
            GDP_hyundai(:,hyundai_idx),~,~,~,agg_hyundai_all{hyundai_idx},...
            result_final_hyundai_all{hyundai_idx},warm_hyundai_all{hyundai_idx}] = ...
            solve_counterfactual_tau_dynamics(hyundai_results{hyundai_idx},...
                result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,...
                L_base,k_guess_until_ss,hyundai_tau_targets{hyundai_idx},...
                hyundai_tau_types(hyundai_idx),warm_hyundai_all{hyundai_idx});
    end
end

agg_hyundai_a = agg_hyundai_all{1};
agg_hyundai_DF = agg_hyundai_all{2};
agg_hyundai_tau_k = agg_hyundai_all{3};
agg_hyundai_tau_l = agg_hyundai_all{4};
agg_hyundai = agg_hyundai_all{5};
result_final_hyundai_a = result_final_hyundai_all{1};
result_final_hyundai_DF = result_final_hyundai_all{2};
result_final_hyundai_tau_k = result_final_hyundai_all{3};
result_final_hyundai_tau_l = result_final_hyundai_all{4};
result_final_hyundai = result_final_hyundai_all{5};
warm_hyundai_a = warm_hyundai_all{1};
warm_hyundai_DF = warm_hyundai_all{2};
warm_hyundai_tau_k = warm_hyundai_all{3};
warm_hyundai_tau_l = warm_hyundai_all{4};
warm_hyundai = warm_hyundai_all{5};

% save(warm_file('warm_hyundai_a.mat'),'warm_hyundai_a','-v7.3');
% save(warm_file('warm_hyundai_DF.mat'),'warm_hyundai_DF','-v7.3');
% save(warm_file('warm_hyundai_tau_k.mat'),'warm_hyundai_tau_k','-v7.3');
% save(warm_file('warm_hyundai_tau_l.mat'),'warm_hyundai_tau_l','-v7.3');
% save(warm_file('warm_hyundai.mat'),'warm_hyundai','-v7.3');

run making_figure5.m
run making_figureB14.m

run making_table3.m


%% Baseline with different market structure (TABLE B4)
mkt_str = [1 1;1 0;0 1;0 0];
lmd_mkt_str = zeros(4,1);
CR3_mkt_str = {};
GDP_mkt_str = {};
warm_mkt_str = cell(4,1);

for j=2:4
    warm_mkt_str{j} = struct();
    cache_file = warm_file(sprintf('warm_mkt_str_%d%d.mat',mkt_str(j,1),mkt_str(j,2)));
    if isfile(cache_file)
        cache_contents = load(cache_file);
        if isfield(cache_contents,'warm_mkt')
            warm_mkt_str{j} = cache_contents.warm_mkt;
        end
    end
    [lmd_mkt_str(j),CR3_mkt_str{j},GDP_mkt_str{j},~,~,~,~,~,warm_mkt_str{j}] ...
    = solve_counterfactual_dynamics(result,result_agg,est_result,Par,data,...
        mkt_str(j,1),mkt_str(j,2),x_guess_cell,E_t,C_base,L_base,...
        k_guess_until_ss,warm_mkt_str{j});
    warm_mkt = warm_mkt_str{j};
    % save(cache_file,'warm_mkt','-v7.3');
end

run making_tableB4.m
run making_figureB9.m


%% Import penetration
result_agg.pi_H_vec = agg_result.pi_H_vec;
result_agg.exsh_vec = agg_result.exsh_vec;
result_agg.pi_avg_sector_base = agg_result.pi_avg_sector;
result_agg.A_j_given = agg_result.A_j;
result_agg.C_base=C_base;
result_agg.L_base=L_base;
result_agg.domar_weight = agg_result.domar_weight;
result_agg.s_M = agg_result.s_M;

[lmd_result_imp_pen(1),delta_result_imp_pen(1),welfare_result_imp_pen(1),CR3_result_imp_pen(:,1),HHI_result_imp_pen(:,1)...
        ,util_result_imp_pen(:,1),GDP_result_imp_pen(:,1),agg_result_imp_pen,result_imp_pen] ...
    = solve_counterfactual_imp_pen(result_final,result_agg,est_result,Par,data,1,1,x_guess_cell);

run making_figureB7.m

%% Finding villains - all shocks
year_converge=100;
total_period = length(year_vec)-1+year_converge;

top3_sum = groupsummary(result, 'firmid', 'sum', 'top3');
top3_unique_firm_list = unique(top3_sum.firmid(top3_sum.sum_top3>10));
lmd_vec_all = zeros(length(top3_unique_firm_list),1);
CR3_mat_all = zeros(length(top3_unique_firm_list),length(year_vec));
GDP_mat_all = zeros(length(top3_unique_firm_list),length(year_vec));
util_mat_all = zeros(length(top3_unique_firm_list),length(year_vec));
C_mat_all = zeros(length(top3_unique_firm_list),total_period);
A_mat_all = zeros(length(top3_unique_firm_list),length(year_vec));
sale_gdp_vec = zeros(length(top3_unique_firm_list),1);
warm_villains_all = cell(length(top3_unique_firm_list),1);
cache_file = warm_file('warm_villains_all.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_villains') && ...
            isfield(cache_contents.warm_villains,'firmid') && ...
            isfield(cache_contents.warm_villains,'states') && ...
            iscell(cache_contents.warm_villains.states)
        [has_cached_state,cache_idx] = ismember(top3_unique_firm_list,...
            cache_contents.warm_villains.firmid);
        warm_villains_all(has_cached_state) = ...
            cache_contents.warm_villains.states(cache_idx(has_cached_state));
    end
end
% Get cumsum for top3 -> identify the first year of becoming top3
result = sortrows(result,{'firmid', 'year'});
G = findgroups(result.firmid);
top3_cumsum = splitapply(@(x) {cumsum(x)}, result.top3, G);
top3_cumsum = vertcat(top3_cumsum{:});
result.top3_cumsum = top3_cumsum;

for i=1:length(top3_unique_firm_list)
    firmRows = find(result.firmid == top3_unique_firm_list(i) & result.top3_cumsum>0);
    last_year=result.year(firmRows(end));
    sale_gdp_vec(i) = result.sale(firmRows(end)) / GDP_result(find(year_vec==last_year));
end

gdp_sale_table=array2table([sale_gdp_vec top3_unique_firm_list],...
    'VariableNames',{'sale_gdp','firmid'});
writetable(gdp_sale_table,OUTPUT+'sale_gdp_top3.csv');

for i=1:length(top3_unique_firm_list)
    i
    result_one_top3 = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
    result_one_top3 = join(result_one_top3,DF_sector_growth,'Keys',{'secid','year','age_bin'});
    result_one_top3 = join(result_one_top3,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
    result_one_top3 = join(result_one_top3,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

    result_one_top3=sortrows(result_one_top3,{'firmid', 'year'});
    result = sortrows(result,{'firmid', 'year'});
    firmRows = find(result_one_top3.firmid == top3_unique_firm_list(i) & result_one_top3.top3_cumsum>0);

    for j=2:length(firmRows)   
        if result_one_top3.continuing(firmRows(j))==1 && result_one_top3.top3(firmRows(j)) == 1 % When it has consecutive observations & top 3
            result_one_top3.tau_k(firmRows(j)) ...
                = result_one_top3.tau_k(firmRows(j-1))...
                .*result_one_top3.tau_k_g_sector(firmRows(j));
            result_one_top3.tau_l(firmRows(j)) ...
                = result_one_top3.tau_l(firmRows(j-1))...
                .*result_one_top3.tau_l_g_sector(firmRows(j));
            result_one_top3.A_fj(firmRows(j)) ...
                = result_one_top3.A_fj(firmRows(j-1))...
                .*result_one_top3.a_g_sector(firmRows(j));
        elseif result_one_top3.continuing(firmRows(j))==1 && result_one_top3.top3(firmRows(j)) == 0
            result_one_top3.tau_k(firmRows(j)) ...
                = result_one_top3.tau_k(firmRows(j-1))...
                .*(result_one_top3.tau_k_g(firmRows(j))+1);
            result_one_top3.tau_l(firmRows(j)) ...
                = result_one_top3.tau_l(firmRows(j-1))...
                .*(result_one_top3.tau_l_g(firmRows(j))+1);
            result_one_top3.A_fj(firmRows(j)) ...
                = result_one_top3.A_fj(firmRows(j-1))...
                .*(result_one_top3.a_g(firmRows(j))+1);
        end
        if result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1 && result.top3(firmRows(j)) == 1
            result_one_top3.DF(firmRows(j)) ...
                = result_one_top3.DF(firmRows(j-1))...
                .*result_one_top3.df_g_sector(firmRows(j));
        elseif result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1 && result.top3(firmRows(j)) == 0
            result_one_top3.DF(firmRows(j)) ...
                = result_one_top3.DF(firmRows(j-1))...
                .*(result_one_top3.df_g(firmRows(j))+1);
        end
    end
    result_one_top3 = sortrows(result_one_top3,{'year','secid','firmid'});
    result = sortrows(result,{'year','secid','firmid'});
    [lmd_vec_all(i),CR3_mat_all(i,:),GDP_mat_all(i,:),~,C_mat_all(i,:),~,...
        agg_result_test,~,warm_villains_all{i}] = ...
        solve_counterfactual_tau_dynamics(result_one_top3,result_agg,est_result,...
            Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,...
            [tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_villains_all{i});
    A_mat_all(i,:) = agg_result_test.A_agg;

end

warm_villains = struct();
warm_villains.firmid = top3_unique_firm_list;
warm_villains.states = warm_villains_all;
% save(warm_file('warm_villains_all.mat'),'warm_villains','-v7.3');

% Plot
delta_CR3_all = CR3_mat_all(:,end)-agg_result.CR3_vec(end);
delta_real_income_all = log(C_mat_all(:,40))-log(C_vec(40));
delta_agg_productivity_all = log(A_mat_all(:,end))-log(agg_result.A_agg(end));
delta_gdp_all = log(GDP_mat_all(:,end))-log(GDP_result(end));

villain_all=array2table([delta_CR3_all delta_real_income_all delta_agg_productivity_all delta_gdp_all top3_unique_firm_list],...
    'VariableNames',{'delta_CR3','delta_real_income','delta_agg_productivity','delta_gdp','firmid'});
writetable(villain_all,OUTPUT+'villain_all.csv');

% Top 4 Top 10
run removing_granular_shocks_top4.m

warm_top4_a = struct();
cache_file = warm_file('warm_top4_a.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_top4_a')
        warm_top4_a = cache_contents.warm_top4_a;
    end
end
[lmd_granular_top4(1),CR4_granular_top4(:,1),GDP_granular_top4(:,1),K_granular_top4(:,1),C_granular_top4(:,1),L_granular_top4(:,1),agg_granular_top4_a,result_final_top4_a,warm_top4_a] ...
    = solve_counterfactual_dynamics(result_top4_a_sector,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,warm_top4_a);
% save(warm_file('warm_top4_a.mat'),'warm_top4_a','-v7.3');

warm_top4_all = struct();
cache_file = warm_file('warm_top4_all.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_top4_all')
        warm_top4_all = cache_contents.warm_top4_all;
    end
end
[lmd_granular_top4(5),CR4_granular_top4(:,5),GDP_granular_top4(:,5),K_granular_top4(:,5),C_granular_top4(:,5),L_granular_top4(:,5),agg_granular_top4,result_final_top4,warm_top4_all] ...
    = solve_counterfactual_tau_dynamics(result_top4_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_top4_all);
% save(warm_file('warm_top4_all.mat'),'warm_top4_all','-v7.3');

run removing_granular_shocks_top10.m

warm_top10_a = struct();
cache_file = warm_file('warm_top10_a.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_top10_a')
        warm_top10_a = cache_contents.warm_top10_a;
    end
end
[lmd_granular_top10(1),CR10_granular_top10(:,1),GDP_granular_top10(:,1),K_granular_top10(:,1),C_granular_top10(:,1),L_granular_top10(:,1),agg_granular_top10_a,result_final_top10_a,warm_top10_a] ...
    = solve_counterfactual_dynamics(result_top10_a_sector,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,warm_top10_a);
% save(warm_file('warm_top10_a.mat'),'warm_top10_a','-v7.3');

warm_top10_all = struct();
cache_file = warm_file('warm_top10_all.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_top10_all')
        warm_top10_all = cache_contents.warm_top10_all;
    end
end
[lmd_granular_top10(5),CR10_granular_top10(:,5),GDP_granular_top10(:,5),K_granular_top10(:,5),C_granular_top10(:,5),L_granular_top10(:,5),agg_granular_top10,result_final_top10,warm_top10_all] ...
    = solve_counterfactual_tau_dynamics(result_top10_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_top10_all);
% save(warm_file('warm_top10_all.mat'),'warm_top10_all','-v7.3');

T_top4 = [(agg_granular_top4.CR4_vec(end)-agg_result.CR4_vec(end))*100 (GDP_granular_top4(end,5)/GDP_result(end)-1)*100,lmd_granular_top4(5) ...
    (agg_granular_top4_a.CR4_vec(end)-agg_result.CR4_vec(end))*100 (GDP_granular_top4(end,1)/GDP_result(end)-1)*100 lmd_granular_top4(1)];
save(fullfile(matlab_dir,'result','result_robust_top4.mat'),'T_top4','-v7.3')

T_top10 = [(agg_granular_top10.CR10_vec(end)-agg_result.CR10_vec(end))*100 (GDP_granular_top10(end,5)/GDP_result(end)-1)*100,lmd_granular_top10(5) ...
    (agg_granular_top10_a.CR10_vec(end)-agg_result.CR10_vec(end))*100 (GDP_granular_top10(end,1)/GDP_result(end)-1)*100 lmd_granular_top10(1)];
save(fullfile(matlab_dir,'result','result_robust_top10.mat'),'T_top10','-v7.3')

% Exogenous capital
[lmd_granular_top3_exo(1),~,~,CR3_granular_top3_exo(:,1),~,~,GDP_granular_top3_exo(:,1),agg_result_exo,result_final_exo] ...
    = solve_counterfactual(result,result_agg,est_result,Par,data,1,1,x_guess_cell);
result_agg.C_base = agg_result_exo.C_vec;
[lmd_granular_top3_exo_base(1),~,~,CR3_granular_top3_exo_base(:,1),~,~,GDP_granular_top3_exo_base(:,1),agg_result_exo,result_final_exo] ...
    = solve_counterfactual(result,result_agg,est_result,Par,data,1,1,x_guess_cell);

[lmd_granular_top3_exo(1),~,~,CR3_granular_top3_exo(:,1),~,~,GDP_granular_top3_exo(:,1)] ...
    = solve_counterfactual(result_top3_a_sector,result_agg,est_result,Par,data,1,1,x_guess_cell);
[lmd_granular_top3_exo(5),~,~,CR3_granular_top3_exo(:,5),~,~,GDP_granular_top3_exo(:,5)] ...
    = solve_counterfactual_wedge(result_top3_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,tau_k_wtd_avg_mat,tau_l_wtd_avg_mat);


T_exo_capital = [(CR3_granular_top3_exo(end)-agg_result.CR3_vec(end))*100 (GDP_granular_top3_exo(end,5)/GDP_granular_top3_exo_base(end)-1)*100 lmd_granular_top3_exo(5) ...
    (CR3_granular_top3_exo(end)-agg_result.CR3_vec(end))*100 (GDP_granular_top3_exo(end,1)/GDP_granular_top3_exo_base(end)-1)*100 lmd_granular_top3_exo(1)];
save(fullfile(matlab_dir,'result','result_robust_exo_capital.mat'),'T_exo_capital','-v7.3')

tau_level_guess_mat_top3 = agg_granular_top3.tau_level_guess_mat;
save(fullfile(result_dir,'p1_to_p2_inputs.mat'), ...
    'result','result_agg','agg_result','est_result','Par','data', ...
    'x_guess_cell','E_t','C_base','L_base','k_vec_extracted', ...
    'k_guess_until_ss','tau_k_wtd_avg_mat','tau_l_wtd_avg_mat', ...
    'result_top3_a_sector','result_top3_granular','tau_level_guess_mat_top3', ...
    'year_vec','GDP_result','-v7.3');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Decomposition with counterfactual %%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% result_final_top3.w=result_final_top3.w_vec;
% result_final_top3.sale_vec=result_final_top3.sale;
% result_final_top3.DF_tilde=result_final_top3.DF_real;
% 
% % Collect some results in table
% num_top=3;
% result_final_top3.top3 = zeros(height(result_final_top3),1);
% top3_list = zeros(length(year_vec),num_top*length(secid_manu));
% for i=1:length(year_vec)
%     result_final_top3.minus_sale = -result_final_top3.sale;
%     result_final_top3.fringe = (result_final_top3.firmid<0);
%     result_final_top3.year_check=(result_final_top3.year~=year_vec(i));
%     top3_list_year = [];
%     for j=1:length(secid_manu)
%         result_final_top3.secid_check = (result_final_top3.secid~=j);
%         result_final_top3 = sortrows(result_final_top3, {'year_check','secid_check','fringe','minus_sale'});  
%         result_final_top3.top3(1:num_top) = 1;
%         top3_list_year = [top3_list_year;result_final_top3.firmid(result_final_top3.top3==1 & result_final_top3.year==year_vec(i) & result_final_top3.secid==j)];
%     end
%     result_final_top3 = sortrows(result_final_top3,{'firmid'});
%     top3_list(i,:) = top3_list_year;
% end
% result_final_top3 = sortrows(result_final_top3,{'year','secid','firmid'});
% 
% 
% [continuing_margin_10,entry_exit_margin_10,sector_margin_10,productivity_margin_10,export_margin_10] = CR3_decompose(1,Par,est_result,result_final_top3);
% total_margin_10 = continuing_margin_10 + entry_exit_margin_10 + sector_margin_10;
% within_margin_10 = productivity_margin_10 + export_margin_10 + entry_exit_margin_10;
% 
% sum(sector_margin_10)/sum(total_margin_10)*(agg_granular_top3.CR3_vec(end)-agg_granular_top3.CR3_vec(1))*100