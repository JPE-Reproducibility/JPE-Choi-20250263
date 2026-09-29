function []=save_result(save_option)
spec="base";
if nargin ~= 1
    error('save_result:MissingOption',...
        'Specify either "base" or "notruncation_nosmoothing".');
end
save_option = string(save_option);
switch save_option
    case "base"
        result_file_name = "result_base.csv";
        apply_truncation = true;
        apply_smoothing = true;
    case "notruncation_nosmoothing"
        result_file_name = "result_base_notruncation_nosmoothing.csv";
        apply_truncation = false;
        apply_smoothing = false;
    otherwise
        error('save_result:UnknownOption',...
            'Unknown save option: %s',save_option);
end

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
    error('save_result:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
INPUT = string(fullfile(project_root,'INPUT')) + filesep;
OUTPUT = string(fullfile(project_root,'OUTPUT')) + filesep;
figure = string(fullfile(project_root,'FIGURE')) + filesep;
if ~isfolder(OUTPUT)
    mkdir(OUTPUT);
end
if ~isfolder(figure)
    mkdir(figure);
end
warm_start_dir = fullfile(matlab_dir,'warm_start');
if ~isfolder(warm_start_dir)
    mkdir(warm_start_dir);
end
warm_file = @(name) fullfile(warm_start_dir,name);

% markup / markdown on off
markup = 1;
markdown = 1;

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
    if apply_truncation

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

% writetable(block_result,OUTPUT+'block_result.csv');
if sum(isnan(block_result.DF))+sum(isnan(block_result.tau_l))+sum(isnan(block_result.tau_k))>0
    disp("NAN")
end

if apply_smoothing

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

writetable(result,fullfile(OUTPUT,result_file_name))

run removing_granular_shocks.m

result_top3_a_sector.top3_prev = result.top3;

if save_option=="base"
    writetable(result_top3_a_sector,OUTPUT+'result_counterfactual_a.csv')
end
