clear; clc;  
 
% Set directory 
matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
if isempty(matlab_dir)
    matlab_dir = pwd;                           
end
project_root = fileparts(matlab_dir);            

cd(project_root);
addpath(matlab_dir);
addpath(fullfile(project_root, 'INPUT'));
addpath(fullfile(project_root, 'OUTPUT'));


% Flag_std = 1: Estimate bootstrapped standard errors
% savefull = 1: Save the esitmation result
flag_std = 1;
savefull = 1;

B = 100; % Bootstrap number 
 
for sigma0 = [5]   
for rho0 = [2] 
for eta0 = [4]
for IVtype = [5]
for p = [1]

estlist = [4];
 
for est = estlist
 
if est == 1
    raw = table2array(readtable('INPUT/input_prod_func_nx.csv'));
elseif est == 2
    raw = table2array(readtable('INPUT/input_prod_func_nonx.csv'));
elseif est == 3
    raw = table2array(readtable('INPUT/input_prod_func_small.csv'));
elseif est == 4
    raw = table2array(readtable('INPUT/input_prod_func_full.csv'));
elseif est == 5 
    raw = table2array(readtable('INPUT/input_prod_func_x.csv'));
elseif est == 6
    raw = table2array(readtable('INPUT/input_prod_func_ex.csv'));    
elseif est == 7
    raw = table2array(readtable('INPUT/input_prod_func_large.csv'));        
end


if est == 5 
    raw_full = table2array(readtable('INPUT/input_prod_func_full.csv'));
    raw_full = raw; 
else
    raw_full = raw;
end

% Importing raw data; The number of sectors
J = size(unique(raw(:, 1)), 1); 

% Estimation results
sec = zeros(J, 1); 
gl = zeros(J, 1);
gk = zeros(J, 1);
gm = zeros(J, 1);
g = zeros(J, 1);

bl = zeros(J, 1);
bk = zeros(J, 1);
bm = zeros(J, 1);
b = zeros(J, 1);

pfcond = zeros(J, 1);
const = zeros(J, 1);
fvals = zeros(J, 1);
eflag = zeros(J, 1);
outputs = zeros(J, 1);

% Bootstrap tables 
se_gl = zeros(J, 1);
se_gk = zeros(J, 1);
se_gm = zeros(J, 1);
se_g = zeros(J, 1);

se_bl = zeros(J, 1);
se_bk = zeros(J, 1);
se_bm = zeros(J, 1);
se_b = zeros(J, 1);

p_gl = zeros(J, 1);
p_gk = zeros(J, 1);
p_gm = zeros(J, 1);
p_g = zeros(J, 1);

p_bl = zeros(J, 1);
p_bk = zeros(J, 1);
p_bm = zeros(J, 1);
p_b = zeros(J, 1);
    
 
%% Baseline: sigma = 5.8 (De Loecker et al.)
% Estimates from the data 
 
raw_sigma = table2array(readtable('INPUT/BW_sigma.xlsx', 'Sheet', '1972-1988')); % 1990-2001 
sigma = raw_sigma(:, 2);
rho = rho0 * ones(J, 1);
eta = eta0;
muL = (eta + 1) / eta;
 
disp(strcat('IV Type: ', num2str(IVtype), '  poly num: ', num2str(p), ' sigma: BW, rho: ', num2str(rho0)));

for jjj = setdiff([1:J], [4])
    rng(0, "threefry");

    if jjj == 6     
        temp_dt1 = raw(raw(:, 1) == 4, :);
        temp_dt2 = raw(raw(:, 1) == 6, :);

        temp_dt_full1 = raw_full(raw_full(:, 1) == 4, :);
        temp_dt_full2 = raw_full(raw_full(:, 1) == 6, :);

        dt = vertcat(temp_dt1, temp_dt2);
        dt_full = vertcat(temp_dt_full1, temp_dt_full2);
        clear temp_dt1 temp_dt2 temp_dt_full1 temp_dt_full2 
    else
        dt = raw(raw(:, 1) == jjj, :);
        dt_full = raw_full(raw_full(:, 1) == jjj, :);
    end
    
    sig = sigma(jjj); 
    rh = rho(jjj); 

    betam = bbb_markup(dt, dt_full, sig, rh, est); 

    sig = sigma(jjj); 
    mu = sig / (sig - 1);
    muL = (eta + 1) / eta;   

    mmobj = @(x) prod_obj_sep_ar1(x, betam, sig, rh, dt, p, IVtype, est);   

    if p == 3
        Aineq = [1 / muL, 1, 0, 0, 0, 0; 1, 1, 0, 0, 0, 0];
        beta0 = [0.2 0.05 0.1 0 0 0]; 

    elseif p == 2
        Aineq = [1 / muL, 1, 0, 0, 0; 1, 1, 0, 0, 0];
        beta0 = [0.2 0.05 0.8 0 0];      
    elseif p == 1 
        Aineq = [1 / muL, 1, 0, 0; 1, 1, 0, 0]; 
        beta0 = [0.2 0.05 0.6 0];   
    end

    Bineq = [0.95 * (1 - betam); 0.95 * (1 - betam)]; 
 
    lb = [0.05 0.05];

    ub = [1 1];      
    if (est == 5 || est == 6 || est == 7) && jjj == 10
        ub = [0.15 0.12]; % For exporter sample, sector 10 hitting the constraint. 
    end
    if jjj == 5 
        lb = [0.15 0.15]; % Sector 5 was sensitive to estimated values below 0.05. 
        ub = [0.25 0.25];
    end
 
    option = optimset('Display', 'off', 'Algorithm', 'interior-point', 'TolX', 1e-6, 'TolCon', 1e-6);
 
    disp(strcat('MS-estimation-sector: ', num2str(jjj)));
    lb = [lb, -Inf(1, numel(beta0) - numel(lb))];
    ub = [ub,  Inf(1, numel(beta0) - numel(ub))];
    [beta, fval, exitflag, output] = fmincon(mmobj, beta0, Aineq, Bineq, [], [], lb, ub, [], option);
 
    disp(beta * mu);
 
 
    gl(jjj) = beta(1) * mu;
    gk(jjj) = beta(2) * mu;
    gm(jjj) = betam * mu;
 
    bl(jjj) = beta(1);
    bk(jjj) = beta(2);
    bm(jjj) = betam; 

    g(jjj) = gl(jjj) + gk(jjj) + gm(jjj); 
    b(jjj) = bl(jjj) + bk(jjj) + bm(jjj); 

    fvals(jjj) = 1e5* fval; 
    eflag(jjj) = exitflag;
 
    disp(strcat('RTS: ', num2str(g(jjj))));

    sec(jjj) = jjj; 

    pfcond(jjj) = (beta(1) / muL + beta(2) + betam);
 
    result = round(horzcat(sigma(jjj), gl(jjj), gk(jjj), gm(jjj), g(jjj), bl(jjj), bk(jjj), bm(jjj), b(jjj), sec(jjj)), 2); 
    filename = 'INPUT/sec_BWpf_results_mu_x.xlsx';
    vnames = {'sigma' 'gl' 'gk' 'gm' 'g' 'bl' 'bk' 'bm' 'b' 'secid'};
    T = array2table(result,'VariableNames',vnames);
    sheetname = strcat('sec',num2str(jjj),'est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0), 'p', num2str(p), 'IV', num2str(IVtype));
    writetable(T, filename, 'Sheet', sheetname);    
    
 
    %% Bootstrap procedure 
    if flag_std == 1   

        disp(strcat('Bootstrap-sector:  ', num2str(jjj)));
        B = 100; 

        sigma_b = zeros(B, 1);
        gl_b = zeros(B, 1);
        gk_b = zeros(B, 1);
        gm_b = zeros(B, 1);

        bl_b = zeros(B, 1);
        bm_b = zeros(B, 1);
        bk_b = zeros(B, 1);

        g_b = zeros(B, 1);
        b_b = zeros(B, 1); 

        for bb = 1:B

            % Random number generator        
            rng(bb);
            disp(strcat('Bootstrap number :', num2str(bb)));

            % Generate bootstrap sample for each b: Block bootstrap (Pick IDs) 
            if jjj == 6     
                temp_dt1 = raw(raw(:, 1) == 4, :);
                temp_dt2 = raw(raw(:, 1) == 6, :);
                dt = vertcat(temp_dt1, temp_dt2);

                temp_dt_full1 = raw_full(raw_full(:, 1) == 4, :);
                temp_dt_full2 = raw_full(raw_full(:, 1) == 6, :);
                dt_full = vertcat(temp_dt_full1, temp_dt_full2);                
                clear temp_dt_full1 temp_dt_full2 temp_dt1 temp_dt2 
            else
                dt = raw(raw(:, 1) == jjj, :);
                dt_full = raw_full(raw_full(:, 1) == jjj, :);
            end

            id_list = unique(dt(:, 2));
            id_list_b = datasample(id_list, length(id_list));
            dt_b = [];
 
            for mmm = 1:length(id_list_b)
               dt_b = vertcat(dt_b, dt(dt(:, 2) == id_list_b(mmm), :)); 
               dt_b(dt_b(:, 2) == id_list_b(mmm), 2) = mmm; % Constructing new IDs 
            end

            id_list_full = unique(dt_full(:, 2));
            id_list_full_b = datasample(id_list_full, length(id_list_full));
            dt_full_b = [];
 
            for mmm = 1:length(id_list_full_b)
               dt_full_b = vertcat(dt_full_b, dt_full(dt_full(:, 2) == id_list_full_b(mmm), :)); 
               dt_full_b(dt_full_b(:, 2) == id_list_full_b(mmm), 2) = mmm; % Constructing new IDs 
            end      
 
            sig = sigma(jjj); 
            rh = rho(jjj); 

            betam_b = bbb_markup(dt_b, dt_full_b, sig, rh, est);  
            mmobj = @(x) prod_obj_sep_ar1(x, betam_b, sig, rh, dt_b, p, IVtype, est); 

            if p == 3
                Aineq = [1 / muL, 1, 0, 0, 0, 0; 1, 1, 0, 0, 0, 0];
                beta0 = [0.2 0.05 0.1 0 0 0]; 
            elseif p == 2
                Aineq = [1 / muL, 1, 0, 0, 0; 1, 1, 0, 0, 0];
                beta0 = [0.2 0.05 0.8 0 0];      
            elseif p == 1 
                Aineq = [1 / muL, 1, 0, 0; 1, 1, 0, 0];
                beta0 = [0.2 0.05 0.6 0];         
            end

            Bineq = [0.95 * (1 - betam_b); 0.95 * (1 - betam_b)]; 

            lb = [0.05 0.05];
            ub = [1 1];      
            if (est == 5 || est == 6 || est == 7) && jjj == 10
                ub = [0.15 0.12]; % For exporter sample, sector 10 hitting the constraint. 
            end
            if jjj == 5 
                lb = [0.15 0.15]; % Sector 5 was sensitive to estimated values below 0.05. 
                ub = [0.25 0.25];
            end     
 
            option = optimset('Display', 'off', 'Algorithm', 'interior-point', 'TolX', 1e-6, 'TolCon', 1e-6);
            disp(strcat('MS-estimation-sector: ', num2str(jjj)));
            lb = [lb, -Inf(1, numel(beta0) - numel(lb))];
            ub = [ub,  Inf(1, numel(beta0) - numel(ub))];
            [beta, fval, exitflag, output] = fmincon(mmobj, beta0, Aineq, Bineq, [], [], lb, ub, [], option);

            mu = sig / (sig - 1);

            gl_b(bb) = beta(1) * mu;
            gk_b(bb) = beta(2) * mu;
            gm_b(bb) = betam_b * mu;

            bl_b(bb) = beta(1);
            bk_b(bb) = beta(2);
            bm_b(bb) = betam_b; 

            g_b(bb) = gl_b(bb) + gk_b(bb) + gm_b(bb); 
            b_b(bb) = bl_b(bb) + bk_b(bb) + bm_b(bb); 
        end

        se_gl(jjj) = (sum((gl_b - mean(gl_b)).^2) / (B - 1))^0.5;
        se_gk(jjj) = (sum((gk_b - mean(gk_b)).^2) / (B - 1))^0.5;
        se_gm(jjj) = (sum((gm_b - mean(gm_b)).^2) / (B - 1))^0.5;
        se_g(jjj) = (sum((g_b - mean(g_b)).^2) / (B - 1))^0.5;

        se_bl(jjj) = (sum((bl_b - mean(bl_b)).^2) / (B - 1))^0.5;
        se_bk(jjj) = (sum((bk_b - mean(bk_b)).^2) / (B - 1))^0.5;
        se_bm(jjj) = (sum((bm_b - mean(bm_b)).^2) / (B - 1))^0.5;
        se_b(jjj) = (sum((b_b - mean(b_b)).^2) / (B - 1))^0.5;

        p_gl(jjj) = 2 * (1 - normcdf(abs(gl(jjj) / se_gl(jjj))));
        p_gk(jjj) = 2 * (1 - normcdf(abs(gk(jjj) / se_gk(jjj))));
        p_gm(jjj) = 2 * (1 - normcdf(abs(gm(jjj) / se_gm(jjj))));
        p_g(jjj) = 2 * (1 - normcdf(abs(g(jjj) / se_g(jjj))));

        p_bl(jjj) = 2 * (1 - normcdf(abs(bl(jjj) / se_bl(jjj))));
        p_bk(jjj) = 2 * (1 - normcdf(abs(bk(jjj) / se_bk(jjj))));
        p_bm(jjj) = 2 * (1 - normcdf(abs(bm(jjj) / se_bm(jjj))));
        p_b(jjj) = 2 * (1 - normcdf(abs(b(jjj) / se_b(jjj))));

        disp(strcat('SE gl: ', num2str(se_gl(jjj)), '   SE gk: ', num2str(se_gk(jjj)), '   SE gm: ', num2str(se_gm(jjj)), '  SE g: ', num2str(se_g(jjj))));
        disp(strcat('p gl: ', num2str(p_gl(jjj)), '  p gk: ', num2str(p_gk(jjj)), ' p gm: ', num2str(p_gm(jjj)), '  p g: ', num2str(p_g(jjj))));

        se_result = round(horzcat(sigma(jjj), se_gl(jjj), se_gk(jjj), se_gm(jjj), se_g(jjj), se_bl(jjj), se_bk(jjj), se_bm(jjj), se_b(jjj), sec(jjj)), 2); 
        filename = 'INPUT/BS_sec_BWpf_results_mu_x.xlsx';
        vnames = {'sigma' 'se_gl' 'se_gk' 'se_gm' 'se_g' 'se_bl' 'se_bk' 'se_bm' 'se_b' 'secid'};
        T = array2table(se_result,'VariableNames',vnames);
        sheetname = strcat('sec', num2str(jjj),'se_est', num2str(est), 's',num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0), 'p', num2str(p), 'IV', num2str(IVtype));
        writetable(T, filename, 'Sheet', sheetname);

        pval_result = round(horzcat(sigma(jjj), p_gl(jjj), p_gk(jjj), p_gm(jjj), p_g(jjj), p_bl(jjj), p_bk(jjj), p_bm(jjj), p_b(jjj), sec(jjj)), 2); 
        filename = 'INPUT/BS_sec_BWpf_results_mu_x.xlsx';
        vnames = {'sigma' 'p_gl' 'p_gk' 'p_gm' 'p_g' 'p_bl' 'p_bk' 'p_bm' 'p_b' 'secid'};
        T = array2table(pval_result,'VariableNames',vnames);
        sheetname = strcat('sec', num2str(jjj),'pval_est',num2str(est),'s',num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0), 'p', num2str(p), 'IV', num2str(IVtype));
        writetable(T, filename, 'Sheet', sheetname);          
    end
end
    
% Sector 4: Petrochemical 
mu = sigma(4) / (sigma(4) - 1);
gl(4) = gl(6);
gk(4) = gk(6);
gm(4) = gm(6);
% const(jjj) = beta(3); 

bl(4) = bl(6);
bk(4) = bk(6);
bm(4) = bm(6);

g(4) = gl(4) + gk(4) + gm(4); 
b(4) = bl(4) + bk(4) + bm(4); 

fvals(4) = fvals(6);
eflag(4) = eflag(6);
sec(4) = 4; 
pfcond(4) = pfcond(6);

if savefull == 1
    % Original estimates
    result = round(horzcat(sigma, gl, gk, gm, g, bl, bk, bm, b, sec), 2); 
    filename = 'INPUT/BWpf_results_mu_x.xlsx';
    vnames = {'sigma' 'gl' 'gk' 'gm' 'g' 'bl' 'bk' 'bm' 'b' 'secid'};
    T = array2table(result,'VariableNames',vnames);
    sheetname = strcat('est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0), 'p', num2str(p), 'IV', num2str(IVtype));
    writetable(T, filename, 'Sheet', sheetname);
end

if flag_std == 1
    % Sector 4: Petrochemical 
    se_gl(4) = se_gl(6);
    se_gk(4) = se_gk(6);
    se_gm(4) = se_gm(6);
    se_g(4) = se_g(6);

    se_bl(4) = se_bl(6);
    se_bk(4) = se_bk(6);
    se_bm(4) = se_bm(6);
    se_b(4) = se_b(6);

    p_gl(4) = p_gl(6);
    p_gk(4) = p_gk(6);
    p_gm(4) = p_gm(6);
    p_g(4) = p_g(6);

    p_bl(4) = p_bl(6);
    p_bk(4) = p_bk(6);
    p_bm(4) = p_bm(6);
    p_b(4) = p_b(6);
    
    if savefull == 1
        se_result = round(horzcat(sigma, se_gl, se_gk, se_gm, se_g, se_bl, se_bk, se_bm, se_b, sec), 2); 
        filename = 'INPUT/BS_BWpf_results_mu_x.xlsx';
        vnames = {'sigma' 'se_gl' 'se_gk' 'se_gm' 'se_g' 'se_bl' 'se_bk' 'se_bm' 'se_b' 'secid'};
        T = array2table(se_result,'VariableNames',vnames);
        sheetname = strcat('se_est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0), 'p', num2str(p), 'IV', num2str(IVtype));
        writetable(T, filename, 'Sheet', sheetname);

        pval_result = round(horzcat(sigma, p_gl, p_gk, p_gm, p_g, p_bl, p_bk, p_bm, p_b, sec), 2); 
        filename = 'INPUT/BS_BWpf_results_mu_x.xlsx';
        vnames = {'sigma' 'p_gl' 'p_gk' 'p_gm' 'p_g' 'p_bl' 'p_bk' 'p_bm' 'p_b' 'secid'};
        T = array2table(pval_result,'VariableNames',vnames);
        sheetname = strcat('pval_est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0), 'p', num2str(p), 'IV', num2str(IVtype));
        writetable(T, filename, 'Sheet', sheetname);
    end
end

end
end
end
end
end
end
