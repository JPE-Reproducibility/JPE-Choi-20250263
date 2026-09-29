%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Robustness table (TABLE 7)%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    error('solve_full_model_part2:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
warm_start_dir = fullfile(matlab_dir,'warm_start');
warm_file = @(name) fullfile(warm_start_dir,name);
INPUT = string(fullfile(project_root,'INPUT')) + filesep;
OUTPUT = string(fullfile(project_root,'OUTPUT')) + filesep;
figure = string(fullfile(project_root,'FIGURE')) + filesep;
table = string(fullfile(project_root,'TABLE')) + filesep;
if ~isfolder(warm_start_dir)
    mkdir(warm_start_dir);
end
if ~isfolder(OUTPUT)
    mkdir(OUTPUT);
end
if ~isfolder(figure)
    mkdir(figure);
end
if ~isfolder(table)
    mkdir(table);
end

load(fullfile(matlab_dir,'result','p1_to_p2_inputs.mat'));
required_part1_inputs = { ...
    'result','result_agg','agg_result','est_result','Par','data', ...
    'x_guess_cell','E_t','C_base','L_base','k_vec_extracted', ...
    'k_guess_until_ss','tau_k_wtd_avg_mat','tau_l_wtd_avg_mat', ...
    'result_top3_a_sector','result_top3_granular', ...
    'tau_level_guess_mat_top3','year_vec','GDP_result'};
missing_part1_inputs = {};
for input_idx = 1:numel(required_part1_inputs)
    if ~exist(required_part1_inputs{input_idx},'var')
        missing_part1_inputs{end+1} = required_part1_inputs{input_idx}; %#ok<AGROW>
    end
end
if ~isempty(missing_part1_inputs)
    error('solve_full_model_part2:IncompletePart1Handoff', ...
        ['MATLAB/result/p1_to_p2_inputs.mat is missing: ' ...
         '%s. Re-run MATLAB/MATLAB_part1.m before Part 2.'], ...
        strjoin(missing_part1_inputs,', '));
end

result_agg.A_j_given = agg_result.A_j;
result_agg.pi_avg_sector_given = agg_result.pi_avg_sector;
% A_j fix
warm_A_j_fix_a = struct();
cache_file = warm_file('warm_A_j_fix_a.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_A_j_fix_a')
        warm_A_j_fix_a = cache_contents.warm_A_j_fix_a;
    end
end

[lmd_granular_top3_A_j_fix(1),CR3_granular_top3_A_j_fix(:,1),GDP_granular_top3_A_j_fix(:,1),K_granular_top3_A_j_fix(:,1),C_granular_top3_A_j_fix(:,1)...
    ,L_granular_top3_A_j_fix(:,1),agg_granular_top3_a_A_j_fix,result_final_top3_a_A_j_fix,warm_A_j_fix_a] ...
    = solve_counterfactual_dynamics_A_j_fix(result_top3_a_sector,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,warm_A_j_fix_a);

warm_A_j_fix_top3 = struct();
cache_file = warm_file('warm_A_j_fix_top3.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_A_j_fix_top3')
        warm_A_j_fix_top3 = cache_contents.warm_A_j_fix_top3;
    end
end
[lmd_granular_top3_A_j_fix(5),CR3_granular_top3_A_j_fix(:,5),GDP_granular_top3_A_j_fix(:,5),K_granular_top3_A_j_fix(:,5),C_granular_top3_A_j_fix(:,5)...
    ,L_granular_top3_A_j_fix(:,5),agg_granular_top3_A_j_fix,result_final_top3_A_j_fix,warm_A_j_fix_top3] ...
    = solve_counterfactual_tau_dynamics_A_j_fix(result_top3_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,tau_level_guess_mat_top3,warm_A_j_fix_top3);
% save(warm_file('warm_A_j_fix_a.mat'),'warm_A_j_fix_a','-v7.3');
% save(warm_file('warm_A_j_fix_top3.mat'),'warm_A_j_fix_top3','-v7.3');

% Profit fix (free entry)
warm_profit_fix_a = struct();
cache_file = warm_file('warm_profit_fix_a.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_profit_fix_a')
        warm_profit_fix_a = cache_contents.warm_profit_fix_a;
    end
end
[lmd_granular_top3_profit_fix(1),CR3_granular_top3_profit_fix(:,1),GDP_granular_top3_profit_fix(:,1),K_granular_top3_profit_fix(:,1),C_granular_top3_profit_fix(:,1)...
    ,L_granular_top3_profit_fix(:,1),agg_granular_top3_a_profit_fix,result_final_top3_a_profit_fix,warm_profit_fix_a] ...
    = solve_counterfactual_dynamics_profit_fix(result_top3_a_sector,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,warm_profit_fix_a);

warm_profit_fix_top3 = struct();
cache_file = warm_file('warm_profit_fix_top3.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_profit_fix_top3')
        warm_profit_fix_top3 = cache_contents.warm_profit_fix_top3;
    end
end
[lmd_granular_top3_profit_fix(5),CR3_granular_top3_profit_fix(:,5),GDP_granular_top3_profit_fix(:,5),K_granular_top3_profit_fix(:,5),C_granular_top3_profit_fix(:,5)...
    ,L_granular_top3_profit_fix(:,5),agg_granular_top3_profit_fix,result_final_top3_profit_fix,warm_profit_fix_top3] ...
    = solve_counterfactual_tau_dynamics_profit_fix(result_top3_granular,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,tau_level_guess_mat_top3,warm_profit_fix_top3);
% save(warm_file('warm_profit_fix_a.mat'),'warm_profit_fix_a','-v7.3');
% save(warm_file('warm_profit_fix_top3.mat'),'warm_profit_fix_top3','-v7.3');


% Spillover

% Run do-file ( Matlab/COMPUTATION_YOUNGHUN_CAPITAL/spillover_region.do )

counterfactual_spillover = readtable(OUTPUT+'counterfactual_spillover.csv');
result_top3_a_spillover = join(result_top3_a_sector,counterfactual_spillover,'Keys',{'firmid','year'});
result_top3_a_spillover.A_fj=result_top3_a_spillover.a_fj_counter_adj;
result_top3_a_spillover=sortrows(result_top3_a_spillover,{'year','secid','firmid'});

result_top3_granular_spillover = join(result_top3_granular,counterfactual_spillover,'Keys',{'firmid','year'});
result_top3_granular_spillover.A_fj=result_top3_granular_spillover.a_fj_counter_adj;
result_top3_granular_spillover=sortrows(result_top3_granular_spillover,{'year','secid','firmid'});

warm_spillover_a = struct();
cache_file = warm_file('warm_spillover_a.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_spillover_a')
        warm_spillover_a = cache_contents.warm_spillover_a;
    end
end
[lmd_granular_spillover(1),CR3_granular_spillover(:,1),GDP_granular_spillover(:,1),~,~,~,~,~,warm_spillover_a] ...
    = solve_counterfactual_dynamics(result_top3_a_spillover,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,warm_spillover_a);

warm_spillover_top3 = struct();
cache_file = warm_file('warm_spillover_top3.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_spillover_top3')
        warm_spillover_top3 = cache_contents.warm_spillover_top3;
    end
end
[lmd_granular_spillover(5),CR3_granular_spillover(:,5),GDP_granular_spillover(:,5),~,~,~,~,~,warm_spillover_top3] ...
    = solve_counterfactual_tau_dynamics(result_top3_granular_spillover,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_spillover_top3);
% save(warm_file('warm_spillover_a.mat'),'warm_spillover_a','-v7.3');
% save(warm_file('warm_spillover_top3.mat'),'warm_spillover_top3','-v7.3');

% Shock correlation with IO consideration
% Run do file (SHOCK_CORR.do)
counterfactual_shock_corr_io = readtable(OUTPUT+'counterfactual_shock_corr_io.csv');
result_top3_a_shock_corr_io = join(result_top3_a_sector,counterfactual_shock_corr_io,'Keys',{'firmid','year'});
result_top3_a_shock_corr_io.A_fj(~isnan(result_top3_a_shock_corr_io.a_fj_counter_adj))=result_top3_a_shock_corr_io.a_fj_counter_adj(~isnan(result_top3_a_shock_corr_io.a_fj_counter_adj));
result_top3_a_shock_corr_io=sortrows(result_top3_a_shock_corr_io,{'year','secid','firmid'});

result_top3_granular_shock_corr_io = join(result_top3_granular,counterfactual_shock_corr_io,'Keys',{'firmid','year'});
result_top3_granular_shock_corr_io.A_fj(~isnan(result_top3_granular_shock_corr_io.a_fj_counter_adj))=result_top3_granular_shock_corr_io.a_fj_counter_adj(~isnan(result_top3_granular_shock_corr_io.a_fj_counter_adj));
result_top3_granular_shock_corr_io=sortrows(result_top3_granular_shock_corr_io,{'year','secid','firmid'});


warm_shock_corr_io_a = struct();
cache_file = warm_file('warm_shock_corr_io_a.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_shock_corr_io_a')
        warm_shock_corr_io_a = cache_contents.warm_shock_corr_io_a;
    end
end
[lmd_granular_shock_corr_io(1),CR3_granular_shock_corr_io(:,1),GDP_granular_shock_corr_io(:,1),~,~,~,~,~,warm_shock_corr_io_a] ...
    = solve_counterfactual_dynamics(result_top3_a_shock_corr_io,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,warm_shock_corr_io_a);

warm_shock_corr_io_top3 = struct();
cache_file = warm_file('warm_shock_corr_io_top3.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_shock_corr_io_top3')
        warm_shock_corr_io_top3 = cache_contents.warm_shock_corr_io_top3;
    end
end
[lmd_granular_shock_corr_io(5),CR3_granular_shock_corr_io(:,5),GDP_granular_shock_corr_io(:,5),~,~,~,~,~,warm_shock_corr_io_top3] ...
    = solve_counterfactual_tau_dynamics(result_top3_granular_shock_corr_io,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_vec_extracted,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_shock_corr_io_top3);
% save(warm_file('warm_shock_corr_io_a.mat'),'warm_shock_corr_io_a','-v7.3');
% save(warm_file('warm_shock_corr_io_top3.mat'),'warm_shock_corr_io_top3','-v7.3');
run making_table7.m




%% Industrial policy + political economy
lmd_ip_vec = zeros(3,1);
GDP_granular_ip_vec = zeros(length(year_vec),3);
agg_granular_ip = {};

balance2 = readtable(INPUT+'shock_DL_polcon.xlsx','sheet','lag8'); % Load firm balance data
balance2.Properties.VariableNames = {'secid','firmid','year','A_fj_cf','tau_k_cf','tau_l_cf','DF_cf'};
balance2 = sortrows(balance2,{'year','secid','firmid'});
result_ip = outerjoin(result,balance2,'Keys',{'secid','firmid','year'});
result_ip.A_fj(~isnan(result_ip.A_fj_cf)) = result_ip.A_fj_cf(~isnan(result_ip.A_fj_cf));
result_ip.tau_k(~isnan(result_ip.tau_k_cf)) = result_ip.tau_k_cf(~isnan(result_ip.tau_k_cf));
result_ip.tau_l(~isnan(result_ip.tau_l_cf)) = result_ip.tau_l_cf(~isnan(result_ip.tau_l_cf));
result_ip.DF(~isnan(result_ip.DF_cf)) = result_ip.DF_cf(~isnan(result_ip.DF_cf));
result_ip = removevars(result_ip, ["A_fj_cf","tau_k_cf","tau_l_cf","DF_cf"]);
result_ip = renamevars(result_ip, {'secid_result','firmid_result','year_result'}, {'secid','firmid','year'});
result_ip = removevars(result_ip, ["secid_balance2","firmid_balance2","year_balance2"]);
result_ip = sortrows(result_ip,{'year','secid','firmid'});

warm_ip_lag8 = struct();
cache_file = warm_file('warm_ip_lag8.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_ip_lag8')
        warm_ip_lag8 = cache_contents.warm_ip_lag8;
    end
end
[lmd_ip(1),CR3_granular_ip,GDP_granular_ip_vec(:,1),K_granular_ip,C_granular_ip,L_granular_ip,agg_granular_ip{1},result_final_ip,warm_ip_lag8] ...
    = solve_counterfactual_tau_dynamics(result_ip,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_ip_lag8);
% save(warm_file('warm_ip_lag8.mat'),'warm_ip_lag8','-v7.3');

k_guess_ip = K_granular_ip;

balance2 = readtable(INPUT+'shock_DL_polcon_t3.xlsx'); % Load firm balance data
balance2.Properties.VariableNames = {'secid','firmid','year','A_fj_cf','tau_k_cf','tau_l_cf','DF_cf'};
balance2 = sortrows(balance2,{'year','secid','firmid'});
result_ip = outerjoin(result,balance2,'Keys',{'secid','firmid','year'});
result_ip.A_fj(~isnan(result_ip.A_fj_cf)) = result_ip.A_fj_cf(~isnan(result_ip.A_fj_cf));
result_ip.tau_k(~isnan(result_ip.tau_k_cf)) = result_ip.tau_k_cf(~isnan(result_ip.tau_k_cf));
result_ip.tau_l(~isnan(result_ip.tau_l_cf)) = result_ip.tau_l_cf(~isnan(result_ip.tau_l_cf));
result_ip.DF(~isnan(result_ip.DF_cf)) = result_ip.DF_cf(~isnan(result_ip.DF_cf));
result_ip = removevars(result_ip, ["A_fj_cf","tau_k_cf","tau_l_cf","DF_cf"]);
result_ip = renamevars(result_ip, {'secid_result','firmid_result','year_result'}, {'secid','firmid','year'});
result_ip = removevars(result_ip, ["secid_balance2","firmid_balance2","year_balance2"]);
result_ip = sortrows(result_ip,{'year','secid','firmid'});

warm_ip_t3 = struct();
cache_file = warm_file('warm_ip_t3.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_ip_t3')
        warm_ip_t3 = cache_contents.warm_ip_t3;
    end
end
[lmd_ip(2),CR3_granular_ip,GDP_granular_ip_vec(:,2),K_granular_ip,C_granular_ip,L_granular_ip,agg_granular_ip{2},result_final_ip,warm_ip_t3] ...
    = solve_counterfactual_tau_dynamics(result_ip,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_ip_t3);
% save(warm_file('warm_ip_t3.mat'),'warm_ip_t3','-v7.3');


balance2 = readtable(INPUT+'shock_DL_polcon_bribe.xlsx','Sheet','lag8'); % Load firm balance data
balance2.Properties.VariableNames = {'secid','firmid','year','A_fj_cf','tau_k_cf','tau_l_cf','DF_cf'};
balance2 = sortrows(balance2,{'year','secid','firmid'});
result_ip = outerjoin(result,balance2,'Keys',{'secid','firmid','year'});
result_ip.A_fj(~isnan(result_ip.A_fj_cf)) = result_ip.A_fj_cf(~isnan(result_ip.A_fj_cf));
result_ip.tau_k(~isnan(result_ip.tau_k_cf)) = result_ip.tau_k_cf(~isnan(result_ip.tau_k_cf));
result_ip.tau_l(~isnan(result_ip.tau_l_cf)) = result_ip.tau_l_cf(~isnan(result_ip.tau_l_cf));
result_ip.DF(~isnan(result_ip.DF_cf)) = result_ip.DF_cf(~isnan(result_ip.DF_cf));
result_ip = removevars(result_ip, ["A_fj_cf","tau_k_cf","tau_l_cf","DF_cf"]);
result_ip = renamevars(result_ip, {'secid_result','firmid_result','year_result'}, {'secid','firmid','year'});
result_ip = removevars(result_ip, ["secid_balance2","firmid_balance2","year_balance2"]);
result_ip = sortrows(result_ip,{'year','secid','firmid'});

warm_ip_bribe = struct();
cache_file = warm_file('warm_ip_bribe.mat');
if isfile(cache_file)
    cache_contents = load(cache_file);
    if isfield(cache_contents,'warm_ip_bribe')
        warm_ip_bribe = cache_contents.warm_ip_bribe;
    end
end
[lmd_ip(3),CR3_granular_ip,GDP_granular_ip_vec(:,3),K_granular_ip,C_granular_ip,L_granular_ip,agg_granular_ip{3},result_final_ip,warm_ip_bribe] ...
    = solve_counterfactual_tau_dynamics(result_ip,result_agg,est_result,Par,data,1,1,x_guess_cell,E_t,C_base,L_base,k_guess_until_ss,[tau_k_wtd_avg_mat tau_l_wtd_avg_mat],3,warm_ip_bribe);
% save(warm_file('warm_ip_bribe.mat'),'warm_ip_bribe','-v7.3');

run making_table6.m
