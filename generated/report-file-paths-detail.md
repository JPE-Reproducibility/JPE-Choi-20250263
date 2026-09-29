## Filepaths Analysis Details

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_table2.m**

- Line 32, windows : fprintf(Fid,'%s\n','\toprule');
- Line 33, windows : fprintf(Fid,'%s\n','Period & 1972--1982 & 1982--1992 & 1992--2002 & 2002--2011 & & 1972--2011 \\');
- Line 34, windows : fprintf(Fid,'%s\n','\midrule');
- Line 37, windows : blankrow = @() fprintf(Fid,'%s\n','& & & & & & \\');
- Line 97, windows : fprintf(Fid,'%s\n','\bottomrule');

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/invprctile.m**

- Line 54, unix : % version 1.0.0, Release 2013/04/04: Initial release
- Line 55, unix : % version 1.0.1, Release 2013/04/05: Bug fixing for not strictly monotonic
- Line 57, unix : % version 1.0.2, Release 2013/04/05: Added additional plotting position
- Line 59, unix : % version 1.1.0, Release 2014/09/03: Fixing behaviour of unique function after MATLAB R2012b,
- Line 80, unix : %% Order inputs/arrays and set parameters
- Line 174, unix : % (2013/04/05, version 1.0.1)
- Line 199, unix : % (2013/04/05, version 1.0.1)

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/SHELL.do**

- Line 57, unix : qui: do STATA/DATA_CLEANING.do
- Line 70, unix : qui: do STATA/SHOCK_VALIDATION.do

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_given_shock_imp_pen.m**

- Line 284, unix : % GDP = I/P;
- Line 297, unix : L_next = (W/P/phi_bar)^(phi);
- Line 301, unix : l_share_next = l_next/sum(l_next);
- Line 326, unix : norm_factor = 1/I;
- Line 331, unix : real_wage = W/P;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/SHOCK_CORR.do**

- Line 32, unix : forv n = 1/3 {
- Line 68, unix : forv r = 1/3 {
- Line 72, unix : forv r = 1/3 {
- Line 78, unix : forv i = 1/1 {
- Line 82, unix : forv r = 1/3 {
- Line 89, unix : forv r = 1/3 {
- Line 98, unix : forv r = 1/3 {
- Line 114, unix : forv i = 1/1 {
- Line 192, unix : merge n:1 sec using DATA/TEMP/GO, keep(3) nogen
- Line 193, unix : merge n:1 sec using DATA/TEMP/VADD, keep(3) nogen
- Line 209, unix : use DATA/TEMP/salesh, clear
- Line 213, unix : merge n:1 secid year using DATA/TEMP/top3_wt_shock, keep(1 3) nogen
- Line 233, unix : forv i = 1/1 {
- Line 317, unix : forv s = 1/2 {
- Line 350, unix : forv must = 1/2 {

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/compute_block_only_tau_k.m**

- Line 103, unix : % s_x = s_x/sum(s_x);
- Line 107, unix : % s_y = sale_d/sum(sale_d);%
- Line 166, unix : % tau_k = tau_k/norm_factor;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/BRIBERY.do**

- Line 491, unix : gen double avgs_musd = cum/ny

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss_tau.m**

- Line 42, windows : fprintf('[fast:tau:transition-inner] iteration=%d residual=%.3e\n',...

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_only_tau_l.m**

- Line 482, unix : mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB_PROD_FUNC/PROD_FUNC_MARKUP.m**

- Line 4, unix : matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
- Line 64, unix : raw = table2array(readtable('INPUT/input_prod_func_nx.csv'));
- Line 66, unix : raw = table2array(readtable('INPUT/input_prod_func_nonx.csv'));
- Line 68, unix : raw = table2array(readtable('INPUT/input_prod_func_small.csv'));
- Line 70, unix : raw = table2array(readtable('INPUT/input_prod_func_full.csv'));
- Line 72, unix : raw = table2array(readtable('INPUT/input_prod_func_x.csv'));
- Line 74, unix : raw = table2array(readtable('INPUT/input_prod_func_ex.csv'));
- Line 76, unix : raw = table2array(readtable('INPUT/input_prod_func_large.csv'));
- Line 80, unix : raw_full = table2array(readtable('INPUT/input_prod_func_full.csv'));
- Line 216, unix : filename = 'INPUT/sec_pf_results_mu_x.xlsx';
- Line 352, unix : filename = 'INPUT/BS_sec_pf_results_mu_x.xlsx';
- Line 359, unix : filename = 'INPUT/BS_sec_pf_results_mu_x.xlsx';
- Line 388, unix : filename = 'INPUT/pf_results_mu_x.xlsx';
- Line 419, unix : filename = 'INPUT/BS_pf_results_mu_x.xlsx';
- Line 426, unix : filename = 'INPUT/BS_pf_results_mu_x.xlsx';

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_table4.m**

- Line 57, windows : fprintf(fid,'%s\n','\toprule');
- Line 58, windows : fprintf(fid,'%s\n','(1) & (2) & (3) & (4) & (5) & (6) \\');
- Line 60, windows : fprintf(fid,'%s\n','\cmidrule(lr){1-3} \cmidrule(lr){4-6}');
- Line 61, windows : fprintf(fid,'%s\n','$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\');
- Line 62, windows : fprintf(fid,'%s\n','2011 (pp) & capita in 2011 (\%) & & 2011 (pp) & capita in 2011 (\%) & \\');
- Line 63, windows : fprintf(fid,'%s\n','& & & & & \\');
- Line 64, windows : fprintf(fid,'%s\n',[strjoin(formatted_values,' & ') ' \\']);
- Line 65, windows : fprintf(fid,'%s\n','\bottomrule');
- Line 69, windows : fprintf('Wrote tau-distortion table: %s\n',table_file);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/linspecer.m**

- Line 219, unix : cmap = flipud(cmap/255);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_only_tau_k.m**

- Line 498, unix : mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_tableB4.m**

- Line 25, windows : fprintf(Fid,'%s\n', ' & Oligopoly & Oligopsony & Monopolistic Competition \\  \hline' );
- Line 26, windows : fprintf(Fid,'%s\n', 'Welfare (\%)');

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/collect_results1.m**

- Line 107, unix : mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss_profit_fix.m**

- Line 29, windows : fprintf('[fast:profit:ss-inner] iteration=%d residual=%.3e\n',...

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/set_parameters_load_data.m**

- Line 6, unix : Par.phi = 1/2; % Fricsh elasticity of labor supply
- Line 125, unix : pop_tot_data.population = pop_tot_data.population/pop_tot_data.population(1);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB_PROD_FUNC/prod_obj_sep_ar1.m**

- Line 39, unix : n = 7; % Number of variables/features
- Line 57, unix : n = 8; % Number of variables/features

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/TABLE/TABLEB6.tex**

- Line 2, unix : &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         \\

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss_A_j_fix.m**

- Line 33, windows : fprintf('[fast:A_j:ss-inner] iteration=%d residual=%.3e\n',iter,diff);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/spillover_region.do**

- Line 15, unix : gen share = numerator/denominator
- Line 19, unix : gen share_counter = numerator_counter/denominator_counter

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/save_result.m**

- Line 180, unix : % k_norm = mean(data.K_hat./gdp_hat)/0.9738; % To match average K/GDP = 0.9738 from the data.

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/TO_MATLAB.do**

- Line 7, unix : qui: use DATA/EUKLEMS, clear
- Line 12, unix : qui: save DATA/secid, replace
- Line 22, unix : qui: use DATA/IO_`IOyear'_3digit_`type', clear
- Line 26, unix : qui: merge n:1 sec using DATA/secid, keep(1 3) nogen
- Line 30, unix : qui: save DATA/TEMP/temp_IO_`type'_`IOyear', replace
- Line 33, unix : qui: use DATA/TEMP/temp_IO_all_`IOyear', clear
- Line 42, unix : qui: save DATA/TEMP/temp_IO_`IOyear', replace
- Line 60, unix : qui: use DATA/TEMP/temp_IO_`IOyear', clear
- Line 69, unix : qui: save DATA/TEMP/imports_`IOyear', replace
- Line 73, unix : qui: use DATA/TEMP/temp_IO_`IOyear', clear
- Line 82, unix : qui: save DATA/TEMP/expen_`IOyear', replace
- Line 85, unix : qui: use DATA/TEMP/imports_`IOyear', clear
- Line 86, unix : qui: merge 1:1 secid using DATA/TEMP/expen_`IOyear', keep(3) nogen
- Line 90, unix : qui: save DATA/TEMP/imsh_`IOyear', replace
- Line 93, unix : qui: use DATA/TEMP/temp_IO_`IOyear', clear
- Line 101, unix : qui: save DATA/TEMP/exports_`IOyear', replace
- Line 104, unix : qui: use DATA/TEMP/temp_IO_`IOyear', clear
- Line 114, unix : qui: save DATA/TEMP/GO_`IOyear', replace
- Line 121, unix : qui: merge 1:1 sec using DATA/TEMP/GO_`IOyear', keep(3) nogen
- Line 122, unix : qui: gen VAsh = 1 - TOT/GO
- Line 127, unix : qui: save DATA/TEMP/VAsh_`IOyear', replace
- Line 130, unix : qui: use DATA/TEMP/exports_`IOyear', clear
- Line 131, unix : qui: merge 1:1 sec using DATA/TEMP/GO_`IOyear', keep(3) nogen
- Line 133, unix : qui: save DATA/TEMP/exsh_`IOyear', replace
- Line 136, unix : qui: use DATA/TEMP/temp_IO_`IOyear', clear
- Line 145, unix : qui: merge n:1 sec using DATA/TEMP/VAsh_`IOyear', keep(3)  nogen
- Line 154, unix : qui: save DATA/TEMP/intsh_`IOyear', replace
- Line 160, unix : append using DATA/TEMP/`var'_`IOyear'
- Line 162, unix : save DATA/TEMP/noimpu_`var', replace
- Line 165, unix : use DATA/TEMP/noimpu_VAsh, clear
- Line 166, unix : merge 1:1 sec year using DATA/TEMP/noimpu_exsh, keep(3) nogen
- Line 167, unix : merge 1:1 sec year using DATA/TEMP/noimpu_imsh, keep(3) nogen
- Line 168, unix : merge 1:1 sec year using DATA/TEMP/noimpu_fcons, keep(3) nogen
- Line 183, unix : save DATA/TEMP/impu, replace
- Line 185, unix : save DATA/TEMP/impu_exsh, replace
- Line 190, unix : use DATA/TEMP/impu, clear
- Line 200, unix : use DATA/TEMP/noimpu_intsh, clear
- Line 220, unix : merge n:1 sec year using DATA/TEMP/noimpu_VAsh, keep(3) nogen
- Line 245, unix : qui: merge 1:1 year using DATA/TEMP/pop, keep(3) nogen
- Line 258, unix : qui: use DATA/EUKLEMS, clear
- Line 293, unix : forv iii = 1/20 {
- Line 316, unix : qui: save DATA/TEMP/resid, replace
- Line 318, unix : qui: use DATA/TEMP/resid, clear
- Line 353, unix : qui: merge n:1 sec year using DATA/TEMP/impu, keep(3) nogen
- Line 354, unix : qui: merge n:1 sec year using DATA/TEMP/impu_exsh, keep(3) nogen
- Line 361, unix : forv iii = 1/5{
- Line 394, unix : qui: save DATA/TEMP/EUKLEMS_impu, replace
- Line 397, unix : qui: use DATA/EUKLEMS, clear
- Line 398, unix : qui: merge n:1 sec year using DATA/TEMP/EUKLEMS_impu, keep(1 3) nogen
- Line 399, unix : qui: merge n:1 sec year using DATA/TEMP/impu_exsh, keep(1 3) nogen
- Line 400, unix : qui: merge n:1 sec using DATA/secid, keep(3) nogen
- Line 425, unix : forv iii = 1/4 {
- Line 439, unix : merge n:1 sec using DATA/secid, keep(3) nogen
- Line 440, unix : merge 1:n kis using DATA/TEMP/cleared_balance, keep(1 3) nogen
- Line 448, unix : qui: capture: erase DATA/TEMP/cleared_balance.dta
- Line 449, unix : qui: capture: erase DATA/TEMP/resid.dta
- Line 450, unix : qui: capture: erase DATA/TEMP/impu.dta
- Line 451, unix : qui: capture: erase DATA/TEMP/IO_impu.dta
- Line 452, unix : qui: capture: erase DATA/TEMP/temp_input.dta
- Line 453, unix : qui: capture: erase DATA/TEMP/EUKLEMS_impu.dta
- Line 454, unix : qui: capture: erase DATA/TEMP/sum_export.dta
- Line 455, unix : qui: capture: erase DATA/TEMP/impu_exsh.dta

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/TABLE/TABLEB5.tex**

- Line 5, unix : \textbf{(a) Treated groups} (event: first Chun-era bribe/donation) & \textbf{(b) Control groups (later-briber group)} \\[4pt]

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_figure2.m**

- Line 3, unix : plot(year_vec,agg_result.A_avg_manu/agg_result.A_avg_manu(1) ,'Linewidth',3)
- Line 20, unix : plot(year_vec,agg_result.DF_avg_manu/agg_result.DF_avg_manu(1) ,'Linewidth',3)

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/compute_block.m**

- Line 91, unix : tau_k = tau_k/norm_factor;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics_A_j_fix.m**

- Line 53, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
- Line 104, windows : fprintf('[fast:tau+A_j:ss] target_iter=%d residual=%.3e\n',...
- Line 109, windows : fprintf('[fast:tau+A_j:ss] converged=%d iterations=%d residual=%.3e\n',...
- Line 222, windows : 'period=%d/%d target_iter=%d residual=%.3e\n'],...
- Line 270, windows : 'period=%d/%d year=%d target_iterations=%d residual=%.3e\n'],...
- Line 312, windows : fprintf('[fast:tau+A_j:capital] iteration=%d residual=%.3e damping=%.3f\n',...
- Line 451, windows : 'inner_iter=%d residual=%.3e\n'],...
- Line 461, windows : fprintf('[fast:tau+A_j:observed] year=%d iterations=%d residual=%.3e\n',...
- Line 772, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 773, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 778, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 780, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 782, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 855, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 856, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 857, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 859, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_robustness.m**

- Line 175, unix : % k_norm = mean(data.K_hat./gdp_hat)/0.9738; % To match average K/GDP = 0.9738 from the data.

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss.m**

- Line 212, unix : L_next = (W/P/phi_bar)^(phi);
- Line 217, unix : l_share_next = l_next/sum(l_next);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss_tau.m**

- Line 42, windows : fprintf('[fast:tau:ss-inner] iteration=%d residual=%.3e\n',iter,diff);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_imp_pen.m**

- Line 239, unix : GDP_vec = GDP_vec/GDP_vec(1); % normalizing by the first year's GDP
- Line 485, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 486, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 487, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 489, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 491, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 556, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3_prev==1),result_all.sale(result_all.secid==j & result_all.top3_prev==1));  % new
- Line 558, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_extract_shock.m**

- Line 57, unix : % mom.ppi_vec = mom.ppi_vec/mom.ppi_vec(1);
- Line 173, unix : % GDP_vec = GDP_vec/GDP_vec(1);% normalizing by the first year's GDP

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics_profit_fix.m**

- Line 54, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
- Line 102, windows : fprintf('[fast:profit:ss] target_iter=%d residual=%.3e damping=%.3f\n',...
- Line 107, windows : fprintf('[fast:profit:ss] converged=%d target_iterations=%d residual=%.3e\n',...
- Line 214, windows : 'target_iter=%d residual=%.3e\n'],...
- Line 262, windows : 'year=%d target_iterations=%d residual=%.3e\n'],...
- Line 304, windows : fprintf('[fast:profit:capital] iteration=%d residual=%.3e damping=%.3f\n',...
- Line 433, windows : fprintf('[fast:profit:observed] year=%d inner_iter=%d residual=%.3e\n',...
- Line 443, windows : fprintf('[fast:profit:observed] year=%d iterations=%d residual=%.3e\n',...
- Line 754, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 755, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 760, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 762, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 764, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 837, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 838, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 839, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 841, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_table3.m**

- Line 28, windows : fprintf(Fid, '%s\n', '\toprule');
- Line 29, windows : fprintf(Fid, '%s\n', '  & (1) & (2) & (3) & (4) & (5) \\');
- Line 30, windows : fprintf(Fid, '%s\n', ...
- Line 32, windows : fprintf(Fid, '%s\n', ...
- Line 34, windows : fprintf(Fid, '%s\n', '\midrule');
- Line 36, windows : fprintf(Fid, '%s\n', ...
- Line 46, windows : fprintf(Fid, '%s\n', ...
- Line 55, windows : fprintf(Fid, '%s\n', ...
- Line 64, windows : fprintf(Fid, '%s\n', '\bottomrule');

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/DATA_CLEANING.do**

- Line 7, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 10, unix : save DATA/TEMP/EUKLEMS_`var', replace
- Line 13, unix : use DATA/TEMP/EUKLEMS_vi, clear
- Line 15, unix : merge 1:1 sec year using DATA/TEMP/EUKLEMS_`var', keep(3) nogen
- Line 18, unix : save DATA/TEMP/EUKLEMS_K, replace
- Line 23, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 26, unix : save DATA/TEMP/EUKLEMS_`var', replace
- Line 31, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 34, unix : save DATA/TEMP/EUKLEMS_rGO, replace
- Line 36, unix : use DATA/TEMP/EUKLEMS_GO, clear
- Line 38, unix : merge 1:1 sec year using DATA/TEMP/EUKLEMS_`var', keep(3) nogen
- Line 40, unix : merge n:1 year using RAW/AGG/exr, keep(3) nogen
- Line 41, unix : merge n:1 year using RAW/AGG/usgdpdef, keep(3) nogen
- Line 77, unix : use RAW/FIRM/FIRM_SEC, clear
- Line 78, unix : save DATA/FIRM_SEC, replace
- Line 81, unix : use RAW/FIRM/firm_balance, clear
- Line 82, unix : save DATA/firm_balance, replace
- Line 85, unix : use RAW/FIRM/kis_region, clear
- Line 86, unix : save DATA/kis_region, replace
- Line 89, unix : use RAW/FIRM/kis_ksic, clear
- Line 90, unix : save DATA/kis_ksic, replace

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_wedge.m**

- Line 211, unix : GDP_vec = GDP_vec/GDP_vec(1); % normalizing by the first year's GDP
- Line 396, unix : mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec) ;
- Line 397, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 399, unix : mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 400, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/TABLE/TABLEB10.tex**

- Line 2, unix : & b/se/bootp         & b/se/bootp         & b/se/bootp         & b/se/bootp         \\

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss_profit_fix.m**

- Line 30, windows : fprintf('[fast:profit:transition-inner] iteration=%d residual=%.3e\n',...

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_given_shock.m**

- Line 275, unix : % GDP = I/P;
- Line 297, unix : L_next = (W/P/phi_bar)^(phi);
- Line 301, unix : l_share_next = l_next/sum(l_next);
- Line 326, unix : norm_factor = 1/I;
- Line 331, unix : real_wage = W/P;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/SHOCK_VALIDATION.do**

- Line 13, unix : forv i = 0/5 {
- Line 18, unix : save DATA/TEMP/L1GO, replace
- Line 21, unix : use RAW/Shock_validation/Trade/wtf_WIOD_code, clear
- Line 24, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 27, unix : save DATA/TEMP/wtf_trade_pre2000, replace
- Line 29, unix : use DATA/TEMP/wtf_trade_pre2000, clear
- Line 43, unix : save DATA/TEMP/import`country', replace
- Line 50, unix : save DATA/TEMP/export`country', replace
- Line 54, unix : use DATA/TEMP/importKOR, clear
- Line 55, unix : merge 1:1 year sec using DATA/TEMP/exportKOR, nogen
- Line 56, unix : merge 1:1 year sec using DATA/TEMP/importTWN, nogen
- Line 57, unix : merge 1:1 year sec using DATA/TEMP/exportTWN, nogen
- Line 64, unix : save DATA/TEMP/import_export_KOR, replace
- Line 67, unix : use DATA/TEMP/wtf_trade_pre2000, clear
- Line 72, unix : save DATA/TEMP/TWNex_to_KOR, replace
- Line 74, unix : use DATA/TEMP/wtf_trade_pre2000, clear
- Line 79, unix : save DATA/TEMP/TWNim_from_KOR, replace
- Line 82, unix : use DATA/TEMP/import_export_KOR, clear
- Line 83, unix : merge 1:1 year sec using DATA/TEMP/TWNex_to_KOR, keep(1 3) nogen
- Line 84, unix : merge 1:1 year sec using DATA/TEMP/TWNim_from_KOR, keep(1 3) nogen
- Line 94, unix : merge 1:1 sec year using DATA/TEMP/L1GO, keep(3) nogen
- Line 97, unix : save DATA/TEMP/pre2000_exshock, replace
- Line 104, unix : merge n:1 year using RAW/AGG/usgdpdef, keep(3) nogen
- Line 106, unix : merge n:1 hs6 using DATA/TEMP/HS_to_ISIC3, keep(3) nogen
- Line 109, unix : forv i = 1/4{
- Line 114, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 117, unix : save DATA/TEMP/raw_post_2000, replace
- Line 120, unix : use DATA/TEMP/raw_post_2000, clear
- Line 124, unix : save DATA/TEMP/`cty'_export_post2000, replace
- Line 128, unix : use DATA/TEMP/raw_post_2000, clear
- Line 132, unix : save DATA/TEMP/`cty'_import_post2000, replace
- Line 135, unix : use DATA/TEMP/raw_post_2000, clear
- Line 139, unix : save DATA/TEMP/TWNim_from_KOR_post2000, replace
- Line 141, unix : use DATA/TEMP/raw_post_2000, clear
- Line 145, unix : save DATA/TEMP/TWNex_to_KOR_post2000, replace
- Line 148, unix : use DATA/TEMP/KOR_import_post2000, clear
- Line 150, unix : merge 1:1 sec year using DATA/TEMP/`data', nogen
- Line 152, unix : merge 1:1 sec year using DATA/TEMP/L1GO, keep(3) nogen
- Line 159, unix : save DATA/TEMP/post2000_exshock, replace
- Line 161, unix : use DATA/TEMP/pre2000_exshock, clear
- Line 162, unix : append using DATA/TEMP/post2000_exshock
- Line 163, unix : merge n:1 sec using DATA/secid, keep(3) nogen
- Line 165, unix : save DATA/TEMP/exshock, replace
- Line 170, unix : qui: use RAW/Shock_validation/Foreign_debt/firm_asset, clear
- Line 171, unix : qui: merge 1:1 kis year using RAW/Shock_validation/Foreign_debt/firm_debt, nogen
- Line 172, unix : qui: merge 1:1 kis year using RAW/Shock_validation/Foreign_debt/firm_fordebt, nogen
- Line 173, unix : qui: merge 1:1 kis year using RAW/Shock_validation/Foreign_debt/firm_forasset, nogen
- Line 334, unix : forv d = 1/3 {
- Line 335, unix : forv f = 1/2 {
- Line 353, unix : forv f = 1/2 {
- Line 477, unix : forv y = 1972/2011 {
- Line 542, unix : use DATA/TEMP/shock_valid_reg, clear
- Line 585, unix : merge n:1 secid using DATA/secid, keep(3) nogen
- Line 596, unix : merge n:1 secid using DATA/secid, keep(3) nogen
- Line 637, unix : qui: capture: erase DATA/TEMP/kotra_temp.dta
- Line 639, unix : qui: capture: erase DATA/TEMP/`cty'_export_post2000.dta
- Line 640, unix : qui: capture: erase DATA/TEMP/`cty'_import_post2000.dta
- Line 642, unix : qui: capture: erase DATA/TEMP/TWNex_to_KOR_post2000.dta
- Line 643, unix : qui: capture: erase DATA/TEMP/TWNim_from_KOR_post2000.dta
- Line 644, unix : qui: capture: erase DATA/TEMP/fringe.dta
- Line 645, unix : qui: capture: erase DATA/TEMP/shock_valid_reg.dta
- Line 646, unix : qui: capture: erase DATA/TEMP/temp_sale.dta
- Line 647, unix : qui: capture: erase DATA/TEMP/fdratio_temp.dta
- Line 648, unix : qui: capture: erase DATA/TEMP/first_adopt_year.dta
- Line 649, unix : qui: capture: erase DATA/TEMP/nt_list.dta
- Line 650, unix : qui: capture: erase DATA/TEMP/exportKOR.dta
- Line 651, unix : qui: capture: erase DATA/TEMP/exportTWN.dta
- Line 652, unix : qui: capture: erase DATA/TEMP/importKOR.dta
- Line 653, unix : qui: capture: erase DATA/TEMP/importTWN.dta
- Line 654, unix : qui: capture: erase DATA/TEMP/L1GO.dta
- Line 655, unix : qui: capture: erase DATA/TEMP/TWNim_from_KOR.dta
- Line 656, unix : qui: capture: erase DATA/TEMP/TWNex_to_KOR.dta
- Line 657, unix : qui: capture: erase DATA/TEMP/import_export_KOR.dta
- Line 658, unix : qui: capture: erase DATA/TEMP/wtf_trade_pre2000.dta
- Line 659, unix : qui: capture: erase DATA/TEMP/pre2000_exshock.dta
- Line 660, unix : qui: capture: erase DATA/TEMP/post2000_exshock.dta
- Line 661, unix : qui: capture: erase DATA/TEMP/HS_to_ISIC3.dta
- Line 662, unix : qui: capture: erase DATA/TEMP/exshock.dta
- Line 663, unix : qui: capture: erase DATA/TEMP/raw_post_2000.dta

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_tableB11.m**

- Line 140, windows : fprintf('Wrote robustness table: %s\n',table_file);
- Line 204, windows : fprintf(fid,'%s\n',line);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_figureB5.m**

- Line 69, unix : cont_avg_by_sector = mean(1-exiting_top3_sector/num_top,1);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_given_shock_dynamics.m**

- Line 219, unix : L_next = (W/P/phi_bar)^(phi);
- Line 223, unix : l_share_next = l_next/sum(l_next);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB_PROD_FUNC/DKL_MARKUP.m**

- Line 4, unix : matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
- Line 38, unix : filename = 'OUTPUT/DLcoefs.xlsx';
- Line 75, unix : filename = 'OUTPUT/DLcoefs.xlsx';

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_part1.m**

- Line 343, unix : % Supports a/DF cache files saved under the earlier generic name.

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics.m**

- Line 43, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
- Line 193, windows : 'year=%d inner_iter=%d residual=%.3e\n'],...
- Line 208, windows : 'year=%d iterations=%d residual=%.3e\n'],...
- Line 267, windows : fprintf('[fast:capital] iteration=%d residual=%.3e damping=%.3f\n',...
- Line 396, windows : fprintf('[fast:observed] year=%d inner_iter=%d residual=%.3e\n',...
- Line 406, windows : fprintf('[fast:observed] year=%d iterations=%d residual=%.3e\n',...
- Line 688, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 689, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 694, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 696, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 698, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 772, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 773, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 774, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 776, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_extract_shock_dynamics.m**

- Line 133, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss.m**

- Line 205, unix : L_next = (W/P/phi_bar)^(phi);
- Line 210, unix : l_share_next = l_next/sum(l_next);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/ESTIMATION_PROD_FUNC.do**

- Line 17, unix : qui: do STATA/subcode/SUB_SITC_REV2_MAPPING.do
- Line 18, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 21, unix : save DATA/TEMP/temp1, replace
- Line 33, unix : merge n:1 sec using DATA/secid, keep(3) nogen
- Line 44, unix : qui: do STATA/subcode/SUB_SITC_REV3_MAPPING.do
- Line 45, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 59, unix : merge 1:1 sec using DATA/secid, keep(3) nogen
- Line 61, unix : save DATA/TEMP/BW_sigma_1990_2001, replace
- Line 66, unix : use DATA/TEMP/temp1, clear
- Line 67, unix : append using DATA/TEMP/temp2
- Line 72, unix : merge 1:1 sec using DATA/secid, keep(3) nogen
- Line 74, unix : save DATA/TEMP/BW_sigma_mean, replace
- Line 84, unix : append using DATA/IO_`year'_3digit_all
- Line 88, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 98, unix : merge n:1 sec year using DATA/TEMP/temp_ppi, keep(3) nogen
- Line 121, unix : save DATA/TEMP/temp_inPPI, replace
- Line 129, unix : append using DATA/IO_`year'_3digit_all
- Line 157, unix : save DATA/TEMP/temp_`var', replace
- Line 175, unix : save DATA/TEMP/temp_`var', replace
- Line 178, unix : use DATA/TEMP/temp_expen, clear
- Line 179, unix : merge 1:1 sec year using DATA/TEMP/temp_import, keep(3) nogen
- Line 202, unix : qui: use DATA/firm_balance, clear
- Line 204, unix : qui: merge m:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 205, unix : qui: merge n:1 sec using DATA/secid, keep(3) nogen
- Line 207, unix : qui: merge n:1 year sec using DATA/EUKLEMS, keep(3) nogen
- Line 208, unix : qui: merge n:1 year sec using DATA/TEMP/temp_inPPI, keep(3) nogen
- Line 209, unix : qui: merge n:1 year sec using DATA/TEMP/temp_imsh, keep(3) nogen
- Line 210, unix : qui: merge n:1 year using RAW/AGG/usgdpdef, keep(3) nogen
- Line 211, unix : qui: merge n:1 year using RAW/AGG/exr, keep(3) nogen
- Line 213, unix : qui: merge n:1 year sec using DATA/TEMP/temp_GO, keep(3) nogen
- Line 214, unix : qui: merge n:1 year sec using DATA/TEMP/temp_export, keep(3) nogen
- Line 215, unix : qui: merge n:1 year sec using DATA/TEMP/temp_WBILL, keep(3) nogen
- Line 300, unix : qui: save DATA/TEMP/full_est, replace
- Line 303, unix : qui: use DATA/TEMP/full_est, clear
- Line 310, unix : qui: use DATA/TEMP/full_est, clear
- Line 321, unix : qui: use DATA/TEMP/full_est, clear
- Line 332, unix : qui: use DATA/TEMP/full_est, clear
- Line 337, unix : qui: save DATA/TEMP/nonx_est, replace
- Line 341, unix : qui: use DATA/TEMP/full_est, clear
- Line 348, unix : qui: save DATA/TEMP/nx_est, replace
- Line 352, unix : qui: use DATA/TEMP/full_est, clear
- Line 359, unix : qui: save DATA/TEMP/x_est, replace
- Line 363, unix : qui: use DATA/TEMP/full_est, clear
- Line 368, unix : qui: save DATA/TEMP/x_est, replace
- Line 375, unix : qui: use DATA/TEMP/full_est, clear
- Line 383, unix : qui: use DATA/TEMP/full_est, clear
- Line 393, unix : save DATA/TEMP/DLcoefs, replace
- Line 402, unix : save DATA/TEMP/DLcoefs_rolling, replace
- Line 407, unix : use DATA/TEMP/DLcoefs_rolling, clear
- Line 410, unix : save DATA/TEMP/DLcoefs_rolling_`i', replace
- Line 412, unix : use DATA/TEMP/DLcoefs_rolling, clear
- Line 414, unix : append using DATA/TEMP/DLcoefs_rolling_`i'
- Line 416, unix : save DATA/TEMP/DLcoefs_full_rolling, replace
- Line 427, unix : qui: use DATA/TEMP/full_est, clear
- Line 429, unix : forv i = 1/3 {
- Line 452, unix : merge n:1 secid using DATA/TEMP/DLcoefs, keep(3) nogen
- Line 453, unix : merge n:1 secid year using DATA/TEMP/DLcoefs_full_rolling, keep(1 3) nogen
- Line 454, unix : merge n:1 secid year using DATA/TEMP/GO_wt, keep(1 3) nogen
- Line 496, unix : use DATA/EUKLEMS, clear
- Line 512, unix : qui: capture: erase DATA/TEMP/temp_WBILL.dta
- Line 513, unix : qui: capture: erase DATA/TEMP/temp_ppi.dta
- Line 514, unix : qui: capture: erase DATA/TEMP/temp_inPPI.dta
- Line 515, unix : qui: capture: erase DATA/TEMP/temp_imsh.dta
- Line 516, unix : qui: capture: erase DATA/TEMP/temp_GO.dta
- Line 517, unix : qui: capture: erase DATA/TEMP/temp_export.dta
- Line 518, unix : qui: capture: erase DATA/TEMP/temp_WBILL.dta
- Line 519, unix : qui: capture: erase DATA/TEMP/temp_imsh.dta
- Line 520, unix : qui: capture: erase DATA/TEMP/temp_expen.dta
- Line 521, unix : qui: capture: erase DATA/TEMP/temp_import.dta
- Line 522, unix : qui: capture: erase DATA/TEMP/full_est.dta
- Line 523, unix : qui: capture: erase DATA/TEMP/nonx_est.dta
- Line 524, unix : qui: capture: erase DATA/TEMP/nx_est.dta
- Line 525, unix : qui: capture: erase DATA/TEMP/x_est.dta
- Line 526, unix : qui: capture: erase DATA/TEMP/temp1.dta
- Line 527, unix : qui: capture: erase DATA/TEMP/temp2.dta
- Line 528, unix : qui: capture: erase DATA/TEMP/BW_sigma_mean.dta
- Line 529, unix : qui: capture: erase DATA/TEMP/BW_sigma_1972_1988.dta
- Line 530, unix : qui: capture: erase DATA/TEMP/BW_sigma_1990_2001.dta
- Line 531, unix : qui: capture: erase DATA/TEMP/DLcoefs.dta
- Line 532, unix : qui: capture: erase DATA/TEMP/DLcoefs_rolling.dta
- Line 533, unix : qui: capture: erase DATA/TEMP/DLcoefs_full_rolling.dta

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/TABLE/TABLEB9.tex**

- Line 2, unix : &       b/se         &       b/se         &       b/se         &       b/se         \\

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/collect_results_robust.m**

- Line 107, unix : mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/HCI_Drive.do**

- Line 31, unix : forv f = 0/38 {

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/Merger.do**

- Line 8, unix : forv y = 1972/1979 {
- Line 12, unix : save DATA/TEMP/temp`y', replace
- Line 16, unix : forv y = 1972/1979 {
- Line 23, unix : save DATA/group_history, replace
- Line 26, unix : use DATA/group_history, clear
- Line 27, unix : merge n:1 kis using DATA/ever_t3_list, keep(3) nogen
- Line 31, unix : save DATA/TEMP/ever_t3_group, replace
- Line 34, unix : use DATA/group_history, clear
- Line 35, unix : merge n:1 kis using DATA/ever_t3_list, keep(3) nogen
- Line 39, unix : save DATA/TEMP/ever_t3_group_sec, replace
- Line 42, unix : forv y = 1972/1979 {
- Line 49, unix : use DATA/kis_ksic, clear
- Line 51, unix : save DATA/TEMP/ksic_base, replace
- Line 54, unix : use DATA/kis_ksic, clear
- Line 57, unix : save DATA/TEMP/ksic_base_list, replace
- Line 77, unix : save DATA/TEMP/ksic_list, replace
- Line 81, unix : merge n:1 kis using DATA/TEMP/ksic_base, keep(1 3) nogen
- Line 84, unix : merge n:1 ksic_k using DATA/TEMP/ksic_base_list, keep(1 3) nogen
- Line 87, unix : merge n:1 ksic_k using DATA/TEMP/ksic_list, keep(1 3) nogen
- Line 98, unix : qui: merge n:1 kis using DATA/FIRM_SEC, keep(1 3) nogen
- Line 104, unix : qui: do STATA/subcode/SUB_SECTOR_AGG.do
- Line 109, unix : qui: do STATA/subcode/SUB_CLASSIFICATION.do
- Line 171, unix : merge n:1 kis year using DATA/group_history, keep(1 3) nogen
- Line 182, unix : save DATA/merger_type_cases, replace
- Line 190, unix : use DATA/merger_type_cases, clear
- Line 192, unix : save DATA/TEMP/merger_`var', replace
- Line 195, unix : use DATA/TEMP/merger_A, clear
- Line 198, unix : save DATA/TEMP/merge_A_temp, replace
- Line 201, unix : use DATA/TEMP/merger_T, clear
- Line 204, unix : merge 1:1 merger_id merger_year using DATA/TEMP/merge_A_temp, keep(3) nogen
- Line 208, unix : save DATA/TEMP/keep_merger_id, replace
- Line 210, unix : save DATA/merger_cases, replace
- Line 213, unix : use DATA/merger_type_cases, clear
- Line 222, unix : use DATA/merger_type_cases, clear
- Line 238, unix : use DATA/merger_type_cases, clear
- Line 250, unix : save DATA/TEMP/merger_char, replace
- Line 252, unix : use DATA/TEMP/merger_char, clear
- Line 263, unix : use DATA/merger_type_cases, clear
- Line 265, unix : merge n:1 kis using DATA/ever_t3_list, keep(1 3) nogen
- Line 269, unix : merge n:1 kis year using DATA/group_history, keep(1 3) nogen
- Line 270, unix : merge n:1 g_code3 using DATA/TEMP/ever_t3_group, keep(1 3) nogen
- Line 275, unix : merge n:1 g_code3 sec using DATA/TEMP/ever_t3_group_sec, keep(1 3) nogen
- Line 286, unix : use DATA/merger_type_cases, clear
- Line 288, unix : merge n:1 kis year using DATA/firm_balance, keep(1 3) nogen
- Line 300, unix : use DATA/merger_type_cases, clear
- Line 307, unix : save DATA/TEMP/temp_T_merger_year, replace
- Line 310, unix : qui: use DATA/firm_balance, clear
- Line 311, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 312, unix : merge n:1 kis year using DATA/TEMP/temp_T_merger_year, keep(3) nogen
- Line 317, unix : save DATA/TEMP/merger_exit, replace
- Line 320, unix : use DATA/TEMP/merger_exit, clear
- Line 321, unix : merge n:1 kis using DATA/ever_t3_list, keep(1 3) nogen
- Line 324, unix : use DATA/merger_type_cases, clear
- Line 325, unix : merge n:1 kis merger_year using DATA/TEMP/merger_exit, keep(1 3)
- Line 329, unix : merge n:1 kis using DATA/ever_t3_list, keep(1 3) nogen
- Line 337, unix : use DATA/merger_type_cases, clear
- Line 339, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3)
- Line 341, unix : save DATA/TEMP/ever_merger_list, replace
- Line 344, unix : use DATA/merger_type_cases, clear
- Line 346, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3)
- Line 360, unix : forv nnn = 1/1 {
- Line 361, unix : forv lag = 1/1 {
- Line 364, unix : use DATA/merger_type_cases, clear
- Line 366, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3)
- Line 373, unix : save DATA/TEMP/treat_group, replace
- Line 375, unix : use DATA/firm_balance, clear
- Line 383, unix : forv l = 0/5 {
- Line 393, unix : use DATA/TEMP/treat_group, clear
- Line 394, unix : joinby kis using DATA/firm_balance
- Line 396, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3)
- Line 415, unix : forv l = 0/5 {
- Line 422, unix : save DATA/TEMP/treat_event_balance, replace
- Line 425, unix : use DATA/firm_balance, clear
- Line 427, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3)
- Line 429, unix : merge n:1 kis using DATA/TEMP/ever_`mstatus'_list, keep(3) nogen
- Line 446, unix : forv l = 0/5 {
- Line 451, unix : save DATA/TEMP/control_group_balance, replace
- Line 454, unix : use DATA/TEMP/treat_event_balance, clear
- Line 456, unix : merge 1:n `ematchvarlist' using DATA/TEMP/control_group_balance, keep(3) nogen
- Line 475, unix : save DATA/TEMP/temp_wid`wid', replace emptyok
- Line 504, unix : forv i = 0/7 {
- Line 553, unix : merge n:1 merger_id using DATA/TEMP/merger_char, keep(3) nogen
- Line 554, unix : merge n:1 kis year using DATA/TEMP/shock_dep, keep(1 3) nogen

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_table6.m**

- Line 50, windows : fprintf(fid,'%s\n','\toprule');
- Line 51, windows : fprintf(fid,'%s\n','(1) & (2) & (3) & & (4) & (5) & (6)\\');
- Line 54, windows : fprintf(fid,'%s\n','$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & & $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\');
- Line 55, windows : fprintf(fid,'%s\n','2011 (pp) & capita in 2011 (\%) & & & 2011 (pp) & capita in 2011 (\%) & \\');
- Line 56, windows : fprintf(fid,'%s\n','& & & & & & \\');
- Line 57, windows : fprintf(fid,'%s\n',[formatted_values{1} ' & ' formatted_values{2} ' & ' formatted_values{3} ...
- Line 59, windows : fprintf(fid,'%s\n','& & & & & & \\');
- Line 60, windows : fprintf(fid,'%s\n','\bottomrule');
- Line 64, windows : fprintf('Wrote Table 6: %s\n',table_file);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_part2.m**

- Line 53, unix : ['MATLAB/result/p1_to_p2_inputs.mat is missing: ' ...
- Line 54, unix : '%s. Re-run MATLAB/MATLAB_part1.m before Part 2.'], ...
- Line 118, unix : % Run do-file ( Matlab/COMPUTATION_YOUNGHUN_CAPITAL/spillover_region.do )

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB_PROD_FUNC/PROD_FUNC_BW_MARKUP.m**

- Line 4, unix : matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
- Line 34, unix : raw = table2array(readtable('INPUT/input_prod_func_nx.csv'));
- Line 36, unix : raw = table2array(readtable('INPUT/input_prod_func_nonx.csv'));
- Line 38, unix : raw = table2array(readtable('INPUT/input_prod_func_small.csv'));
- Line 40, unix : raw = table2array(readtable('INPUT/input_prod_func_full.csv'));
- Line 42, unix : raw = table2array(readtable('INPUT/input_prod_func_x.csv'));
- Line 44, unix : raw = table2array(readtable('INPUT/input_prod_func_ex.csv'));
- Line 46, unix : raw = table2array(readtable('INPUT/input_prod_func_large.csv'));
- Line 51, unix : raw_full = table2array(readtable('INPUT/input_prod_func_full.csv'));
- Line 103, unix : raw_sigma = table2array(readtable('INPUT/BW_sigma.xlsx', 'Sheet', '1972-1988')); % 1990-2001
- Line 196, unix : filename = 'INPUT/sec_BWpf_results_mu_x.xlsx';
- Line 333, unix : filename = 'INPUT/BS_sec_BWpf_results_mu_x.xlsx';
- Line 340, unix : filename = 'INPUT/BS_sec_BWpf_results_mu_x.xlsx';
- Line 370, unix : filename = 'INPUT/BWpf_results_mu_x.xlsx';
- Line 401, unix : filename = 'INPUT/BS_BWpf_results_mu_x.xlsx';
- Line 408, unix : filename = 'INPUT/BS_BWpf_results_mu_x.xlsx';

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve.m**

- Line 28, unix : GO_share = GO/sum(GO);
- Line 193, unix : l_share_next = l_next/sum(l_next);
- Line 315, unix : norm_factor = 1/P;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/compute_block_only_tau_l.m**

- Line 103, unix : % s_x = s_x/sum(s_x);
- Line 107, unix : % s_y = sale_d/sum(sale_d);%
- Line 168, unix : tau_k = tau_k/norm_factor;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/CONCENTRATION.do**

- Line 23, unix : use DATA/firm_balance, clear
- Line 24, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 40, unix : use DATA/EUKLEMS, clear
- Line 53, unix : use DATA/EUKLEMS, clear
- Line 57, unix : save DATA/TEMP/mfg_GO, replace
- Line 59, unix : use DATA/firm_balance, clear
- Line 60, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 63, unix : merge 1:1 year using DATA/TEMP/mfg_GO, keep(3) nogen
- Line 73, unix : use DATA/EUKLEMS, clear
- Line 74, unix : qui: do STATA/subcode/SUB_CLASSIFICATION.do
- Line 78, unix : save DATA/TEMP/temp_natGO, replace
- Line 81, unix : use DATA/IOimpu, clear
- Line 82, unix : qui: do STATA/subcode/SUB_CLASSIFICATION.do
- Line 86, unix : save DATA/TEMP/temp_IOnat`v', replace
- Line 91, unix : use DATA/firm_balance, clear
- Line 92, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 95, unix : merge n:1 year manu using DATA/TEMP/temp_natGO, keep(1 3) nogen
- Line 96, unix : merge n:1 year manu using DATA/TEMP/temp_IOnatGO, keep(1 3) nogen
- Line 97, unix : merge n:1 year manu using DATA/TEMP/temp_IOnatEX, keep(1 3) nogen
- Line 131, unix : save DATA/ever_t3_list, replace
- Line 192, unix : use DATA/firm_balance, clear
- Line 193, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 196, unix : merge n:1 year manu using DATA/TEMP/temp_natGO, keep(1 3) nogen
- Line 197, unix : merge n:1 year manu using DATA/TEMP/temp_IOnatGO, keep(1 3) nogen
- Line 198, unix : merge n:1 year manu using DATA/TEMP/temp_IOnatEX, keep(1 3) nogen
- Line 254, unix : use DATA/firm_balance, clear
- Line 255, unix : merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
- Line 258, unix : merge n:1 year manu using DATA/TEMP/temp_natGO, keep(1 3) nogen
- Line 259, unix : merge n:1 year manu using DATA/TEMP/temp_IOnatGO, keep(1 3) nogen
- Line 260, unix : merge n:1 year manu using DATA/TEMP/temp_IOnatEX, keep(1 3) nogen
- Line 295, unix : qui: capture: erase DATA/TEMP/temp_IOnatGO.dta
- Line 296, unix : qui: capture: erase DATA/TEMP/temp_IOnatEX.dta
- Line 297, unix : qui: capture: erase DATA/TEMP/temp_natGO.dta
- Line 298, unix : qui: capture: erase DATA/TEMP/mfg_GO.dta

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual.m**

- Line 223, unix : GDP_vec = GDP_vec/GDP_vec(1); % normalizing by the first year's GDP
- Line 478, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 479, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 484, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 486, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 488, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 561, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 562, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 563, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 565, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics.m**

- Line 42, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
- Line 101, windows : fprintf('[fast:tau:ss] target_iter=%d residual=%.3e damping=%.3f\n',...
- Line 106, windows : fprintf('[fast:tau:ss] converged=%d target_iterations=%d residual=%.3e\n',...
- Line 237, windows : 'target_iter=%d residual=%.3e\n'],...
- Line 288, windows : 'year=%d target_iterations=%d residual=%.3e\n'],...
- Line 336, windows : fprintf('[fast:tau:capital] iteration=%d residual=%.3e damping=%.3f\n',...
- Line 483, windows : fprintf('[fast:tau:observed] year=%d inner_iter=%d residual=%.3e\n',...
- Line 493, windows : fprintf('[fast:tau:observed] year=%d iterations=%d residual=%.3e\n',...
- Line 817, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 818, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 823, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 825, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 827, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 900, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 901, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 902, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 904, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_table7.m**

- Line 89, windows : fprintf(Fid,'%s\n','\toprule');
- Line 90, windows : fprintf(Fid,'%s\n','(1) & (2) & (3) & (4) & (5) & (6) \\');
- Line 92, windows : fprintf(Fid,'%s\n','\cmidrule(lr){1-6}');
- Line 94, windows : fprintf(Fid,'%s\n','\cmidrule(lr){1-3} \cmidrule(lr){4-6}');
- Line 95, windows : fprintf(Fid,'%s\n','$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\');
- Line 96, windows : fprintf(Fid,'%s\n','2011 (pp) & capita in 2011 (\%) & & 2011 (pp) & capita in 2011 (\%) & \\');
- Line 97, windows : fprintf(Fid,'%s\n','\midrule');
- Line 107, windows : fprintf(Fid,'%s\n',panel_labels{row_idx});
- Line 108, windows : fprintf(Fid,'%s\n',[strjoin(formatted_values(row_idx,:),' & ') ' \\']);
- Line 111, windows : fprintf(Fid,'%s\n','\bottomrule');
- Line 115, windows : fprintf('Wrote Table 7: %s\n',table_file);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/making_figure3.m**

- Line 3, unix : plot(year_vec,agg_result.A_agg/agg_result.A_agg(1),'Linewidth',3)

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss_A_j_fix.m**

- Line 34, windows : fprintf('[fast:A_j:transition-inner] iteration=%d residual=%.3e\n',...

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics_A_j_fix.m**

- Line 52, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
- Line 96, windows : fprintf('[fast:A_j:ss] target_iter=%d residual=%.3e damping=%.3f\n',...
- Line 101, windows : fprintf('[fast:A_j:ss] converged=%d target_iterations=%d residual=%.3e\n',...
- Line 207, windows : 'target_iter=%d residual=%.3e\n'],...
- Line 255, windows : 'year=%d target_iterations=%d residual=%.3e\n'],...
- Line 297, windows : fprintf('[fast:A_j:capital] iteration=%d residual=%.3e damping=%.3f\n',...
- Line 427, windows : fprintf('[fast:A_j:observed] year=%d inner_iter=%d residual=%.3e\n',...
- Line 437, windows : fprintf('[fast:A_j:observed] year=%d iterations=%d residual=%.3e\n',...
- Line 748, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 749, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 754, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 756, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 758, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 831, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 832, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 833, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 835, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/TABLE/TABLEB8.tex**

- Line 2, unix : &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         &       b/se         \\

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/STATA/DISTRIBUTED_LAG.do**

- Line 269, unix : forv r = 1/4 {
- Line 281, unix : forv r = 1/4 {
- Line 294, unix : forv q = 8/8 {
- Line 398, unix : forv l = 0/10 {
- Line 405, unix : forv l = 0/10 {
- Line 557, unix : forv l = 0/10 {
- Line 564, unix : forv l = 0/10 {

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics_profit_fix.m**

- Line 54, unix : r_over_p = (1/beta-(1-delta))/E_star; % r/p at steady state
- Line 109, windows : fprintf('[fast:tau+profit:ss] target_iter=%d residual=%.3e\n',...
- Line 114, windows : fprintf('[fast:tau+profit:ss] converged=%d iterations=%d residual=%.3e\n',...
- Line 228, windows : 'period=%d/%d target_iter=%d residual=%.3e\n'],...
- Line 276, windows : 'period=%d/%d year=%d target_iterations=%d residual=%.3e\n'],...
- Line 318, windows : fprintf('[fast:tau+profit:capital] iteration=%d residual=%.3e damping=%.3f\n',...
- Line 456, windows : 'inner_iter=%d residual=%.3e\n'],...
- Line 466, windows : fprintf('[fast:tau+profit:observed] year=%d iterations=%d residual=%.3e\n',...
- Line 777, unix : mu_y_agg_sector(i,j) = 1/sum(s_y./mu_y_tilde);
- Line 778, unix : mu_y_agg_dom_sector(i,j) = 1/sum(s_d./mu_y_vec);
- Line 783, unix : mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
- Line 785, unix : % mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
- Line 787, unix : mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );
- Line 860, unix : mu_y_top3_sector(i,j) = 1/wmean(1./mu_y_tilde(top3_vec),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 861, unix : mu_y_top3_dom_sector(i,j) = 1/wmean(1./result_all.mu_y(result_all.secid==j & result_all.top3==1),result_all.sale(result_all.secid==j & result_all.top3==1));  % new
- Line 862, unix : mu_l_top3_sector(i,j) =  1/wmean(1./(mu_l_vec(top3_vec)),s_y(top3_vec)./mu_y_tilde(top3_vec));  % new
- Line 864, unix : mu_y_agg_dom_sector_nofringe(i,j) = 1/wmean(1./mu_y_vec_nofringe,s_y_nofringe);

