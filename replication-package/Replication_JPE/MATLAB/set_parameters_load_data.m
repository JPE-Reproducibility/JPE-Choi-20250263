%%%%%%%%%%%%%%%%%%%%%%
%%% Set Parameters %%%
%%%%%%%%%%%%%%%%%%%%%%
Par.eta = 4;
Par.theta = 1.89;
Par.phi = 1/2; % Fricsh elasticity of labor supply
Par.delta = 0.08; % Depreciation rate from KLEMS (unweighted average except for software)
Par.beta = 0.97; % Discount factor

%%%%%%%%%%%%%%%%%%%%%
%%% Load Data %%%%%%%
%%%%%%%%%%%%%%%%%%%%%
balance = readtable(INPUT+'firm.csv'); % Load firm balance data

% Create five age bin
balance.age_bin = ceil((balance.year-balance.startyear+1)/5);
balance.age_bin(balance.age_bin<=0)=1;
balance.age_bin(balance.age_bin>=4)=4;
balance.age_bin(isnan(balance.age_bin))=1;    
balance = balance(balance.year<=2011,:);
% Truncate data with emp>10
balance = balance(balance.emp>=10,:);        
balance.export(isnan(balance.export)) =0;

GO = readtable(INPUT+'GO.csv'); % Gross output
GK = readtable(INPUT+'K.csv'); % Capital 
GL = readtable(INPUT+'L.csv'); % Labor

seclist = array2table(unique(GO.secid),'VariableNames',{'secid'});
seclist = seclist(~isnan(seclist.secid),:);
secid_manu = seclist.secid(ismember(seclist.secid, unique(balance.secid) ) );
Par.secid_manu = secid_manu;
secid_service = seclist.secid(~ismember(seclist.secid, unique(balance.secid) ) );
Par.num_sec_manu = length(secid_manu);

year_vec = (min(balance.year):1:max(balance.year))';
Par.year_vec = year_vec;
secid_full = seclist.secid;
secid_full = secid_full(~isnan(secid_full));
num_sector = length(secid_full); %

% Production function estimation
if spec=="BW"
    est_result = readtable(INPUT+'BWpf_results_mu_x','Sheet','est4s5r2e4p1IV5'); % All firms
elseif spec=="non_exporter"
    est_result = readtable(INPUT+'pf_results_mu_x','Sheet','est2s5r2e4p1IV5'); % Only non-exporters
elseif spec=="only_exporter"
    est_result = readtable(INPUT+'pf_results_mu_x','Sheet','est5s5r2e4p1IV5'); % Only exporters
else
    est_result = readtable(INPUT+'pf_results_mu_x','Sheet','est4s5r2e4p1IV5'); % All firms
end

% est_result = readtable(INPUT+'pf_results_mu_x_JPE_1st','Sheet','est2s5r2e4p1o3c1IV5pf1'); % Only non-exporters
% est_result = readtable(INPUT+'pf_results_mu_x','Sheet','est5s5r2e4p1o3c1IV5'); % Only exporters

est_result=est_result(~isnan(est_result.secid),:);

% Add est_result for service sector using average values
est_result = outerjoin(seclist,est_result,"Keys","secid");
est_result= removevars(est_result,{'secid_est_result'});
est_result.secid=est_result.secid_seclist;
est_result= removevars(est_result,{'secid_seclist'});
est_result.sigma(isnan(est_result.sigma)) = mean(est_result.sigma(~isnan(est_result.sigma)));
est_result.gl(isnan(est_result.gl)) = mean(est_result.gl(~isnan(est_result.gl)));
est_result.gk(isnan(est_result.gk)) = mean(est_result.gk(~isnan(est_result.gk)));
est_result.gm(isnan(est_result.gm)) = mean(est_result.gm(~isnan(est_result.gm)));
est_result.g = est_result.gl+est_result.gk+est_result.gm;


EX = readtable(INPUT+'EX.csv'); % Gross export
EX=EX(~isnan(EX.secid),:);
GO=GO(~isnan(GO.secid),:);

exsh = join(GO,EX,'Keys',{'year','secid'});
exsh.exsh = exsh.EX./exsh.GO;

imsh = readtable(INPUT+'imsh.csv'); % Import share
imsh.imsh(isnan(imsh.imsh))=0;

intsh = readtable(INPUT+'intsh.csv'); % Intermediate good share
% Some years are absent in this dataset. We fill the missing variables
% using the value from previous year
year_list = unique(intsh.year);
year_diff = [year_list(1)-year_vec(1)+1;year_list(2:end) - year_list(1:end-1)]-1;
for i=1:length(year_list)
    duplicatedRows = intsh(intsh.year==year_list(i), :);
    for j=1:year_diff(i)
        duplicatedRows.year=(year_list(i)-j)*ones(length(duplicatedRows.year),1);
        intsh = [duplicatedRows;intsh];
    end
end
intsh = sortrows(intsh,{'osecid','dsecid','year'});
    
ppi_data= readtable(INPUT+'PPI.csv'); % PPI
ppi_data = ppi_data(~isnan(ppi_data.secid),:);
% Take moving average of PPI and export share
ppi_data = sortrows(ppi_data, {'secid', 'year'});  % Sort data by ID, then by year
unique_id = unique(ppi_data.secid);  % Find all unique IDs
ppi_ma = [];  % Initialize array to hold moving averages
exsh_ma = [];
for i = 1:length(unique_id)
%     Extract data for current ID
    currentData = ppi_data(ppi_data.secid == unique_id(i), :);
%     Append to overall array
    ppi_ma = [ppi_ma; movmean(currentData.PPI, [5 5])];
    currentData = exsh(exsh.secid == unique_id(i), :);
    exsh_ma = [exsh_ma; movmean(currentData.exsh, [5 5])];
end
ppi_data.PPI = ppi_ma;
exsh.exsh = exsh_ma;

for j = 1:num_sector
    ppi_temp=ppi_data.PPI(ppi_data.secid==secid_full(j) );
    ppi_init = ppi_temp(1);
    ppi_data.PPI(ppi_data.secid==secid_full(j)) = ppi_temp / ppi_init; % PPI normalizing
end

fcons = readtable(INPUT+'fcons.csv'); % Final consumption share

% Aggregate data
pop = readtable(INPUT+'Lhat.csv'); % Population (working age)
pop_data = readtable(INPUT+'hc.csv'); % Education adjusted population (working age)
pop_data.Lhat = (pop_data.hc.*pop.Lhat)./(pop_data.hc(1)*pop.Lhat(1));
pop_tot_data = readtable(INPUT+'population.csv');
pop_tot_data.population = pop_tot_data.population/pop_tot_data.population(1);
hour_data = readtable(INPUT+'Lhpchat.csv'); % Working hour
K_year = readtable(INPUT+'Khat.csv'); % Capital endowment
K_year.Khat = movmean(K_year.Khat,[4 4]); % Smooth capital stocks to avoid negative investment 
K_year.Khat = K_year.Khat./K_year.Khat(1);

gdp_data = readtable(INPUT+'rGDPg.csv'); % Real GDP growth
gdp_data = gdp_data(gdp_data.year>=year_vec(1) & gdp_data.year<=year_vec(end),:);
gdp_hat = [1; cumprod( gdp_data.rGDPg(2:end)+1 ) ]; % Real GDP with GDP in 1972 normalized to ten

GDP_growth_vec = zeros(length(year_vec),1);
total_firm_vec = zeros(length(year_vec),1);
P_vec = zeros(length(year_vec),1);

Par.sigma = est_result.sigma;
Par.rho_base = 2*ones(length(Par.sigma),1);

Par.chi = 1; % Tax revenue efficiency parameter

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

if spec=="sigma_3"
    est_result.sigma = 3*ones(length(est_result.sigma),1);
    Par.sigma=3;
elseif spec=="sigma_7"
    est_result.sigma = 7*ones(length(est_result.sigma),1);
    Par.sigma=7;
end

if spec=="eta_3"
    Par.eta=3;
elseif spec=="eta_6"
    Par.eta=6;
end

if spec=="theta_15"
    Par.theta=1.5;
elseif spec=="theta_25"
    Par.theta=2.5;
end

if spec=="phi_1"
    Par.phi=1;
elseif spec=="phi_0"
    Par.phi=0;
end

if spec=="chi_0"
    Par.chi=0;
elseif spec=="chi_05"
    Par.chi=0.5;
end

if spec=="rho_25"
    Par.rho_base = 2.5*ones(length(Par.sigma),1);
elseif spec=="rho_15"
    Par.rho_base = 1.5*ones(length(Par.sigma),1);
end

if spec=="CRS"
    est_result.g = est_result.gl+est_result.gk+est_result.gm;
    est_result.gl = est_result.gl./est_result.g;
    est_result.gk = est_result.gk./est_result.g;
    est_result.gm = est_result.gm./est_result.g;
    est_result.g = est_result.gl+est_result.gk+est_result.gm;
end
