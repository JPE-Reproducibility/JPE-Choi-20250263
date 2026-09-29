## Potentially Hardcoded Numeric Constants


We found the following set of hard coded numbers. This may be completely legitimate (parameter input, thresholds for computations, etc), and is hence only for information.

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/invprctile.m**

- Line 22, : %  'Median'     (i-0.3175)/(n+0.365)Median exceedance probabilities for
- Line 25, : %  'Blom'       (i-0.375)/(n+0.25)  Unbiased normal quantiles
- Line 113, : p1 = 0.3175; p2 = 0.365;
- Line 117, : p1 = 0.375; p2 = 0.25;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_given_wedge.m**

- Line 12, : dmp=0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss_A_j_fix.m**

- Line 19, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/compute_block_only_tau_l.m**

- Line 49, : % if sale(end)/sum(sale)<0.0001
- Line 51, : %     sale(end)=0.0001*sum(sale(1:end-1))/(1-0.0001);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_adapt_damping.m**

- Line 21, : dmp = max(0.5*dmp,0.005);
- Line 22, : dmp_small = max(0.5*dmp_small,0.0025);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/save_result.m**

- Line 180, : % k_norm = mean(data.K_hat./gdp_hat)/0.9738; % To match average K/GDP = 0.9738 from the data.
- Line 181, : data.K_hat = data.K_hat*0.6876; % To match K/Y=0.6876 in 1972

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual.m**

- Line 137, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/compute_block_only_tau_k.m**

- Line 49, : % if sale(end)/sum(sale)<0.0001
- Line 51, : %     sale(end)=0.0001*sum(sale(1:end-1))/(1-0.0001);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics_A_j_fix.m**

- Line 156, : dmp_outer=0.025;
- Line 207, : dmp=0.015;
- Line 208, : dmp_small = 0.025;
- Line 437, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_part1.m**

- Line 176, : data.K_hat = data.K_hat*0.6876; % To match K/Y=0.6876 in 1972

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics.m**

- Line 86, : dmp_small = 0.025;
- Line 150, : dmp_outer=0.025;
- Line 180, : dmp_small = 0.025;
- Line 385, : dmp_small = 0.025;
- Line 1168, : dmp = max(0.5*dmp,0.005);
- Line 1169, : dmp_small = max(0.5*dmp_small,0.0025);

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_robustness.m**

- Line 175, : % k_norm = mean(data.K_hat./gdp_hat)/0.9738; % To match average K/GDP = 0.9738 from the data.
- Line 176, : data.K_hat = data.K_hat*0.6876; % To match K/Y=0.6876 in 1972

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss_tau.m**

- Line 28, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss_tau.m**

- Line 28, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_imp_pen.m**

- Line 143, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_extract_shock.m**

- Line 128, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics_profit_fix.m**

- Line 155, : dmp_outer=0.025;
- Line 200, : dmp=0.015;
- Line 201, : dmp_small = 0.025;
- Line 420, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics.m**

- Line 186, : dmp_outer=0.025;
- Line 218, : dmp_small = 0.025;
- Line 470, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_extract_shock_dynamics.m**

- Line 113, : dmp_small = 0.025;
- Line 189, : dmp_small = 0.025;
- Line 238, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_only_tau_l.m**

- Line 306, : data.K_hat = data.K_hat*0.6876; % To match K/Y=0.6876 in 1972

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss_A_j_fix.m**

- Line 20, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics_A_j_fix.m**

- Line 148, : dmp_outer=0.025;
- Line 192, : dmp=0.015;
- Line 193, : dmp_small = 0.025;
- Line 414, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/linspecer.m**

- Line 202, : cmap =  [0.2005    0.5593    0.7380];
- Line 206, : cmap =  [0.2005    0.5593    0.7380;
- Line 207, : 0.9684    0.4799    0.2723];

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_full_model_only_tau_k.m**

- Line 303, : data.K_hat = data.K_hat*0.6876;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_solve_ss_profit_fix.m**

- Line 15, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics_profit_fix.m**

- Line 162, : dmp_outer=0.025;
- Line 214, : dmp=0.015;
- Line 215, : dmp_small = 0.025;
- Line 442, : dmp_small = 0.025;

**/Users/florianoswald/actions-runner/_work/JPE-Choi-20250263/JPE-Choi-20250263/replication-package/Replication_JPE/MATLAB/model_until_ss_profit_fix.m**

- Line 16, : dmp_small = 0.025;

