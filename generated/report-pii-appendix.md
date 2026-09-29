## Appendix: Detailed PII Detection Results

*Generated on 2026-09-29 09:36:32*

This appendix lists all detected instances of potential personally identifiable information (PII) in the project files. Each entry shows the matched PII terms and, for data files, sample values to help verify whether the flagged content is indeed sensitive.

### Full Summary Table

| File Type | File | Variables/References | PII Categories |
|-----------|------|----------------------|----------------|
| Data | `EUKLEMS_KOR_WK_2015_YL.xlsx` | 1 | name |
| Data | `LeeLee_v1.dta` | 17 | country, name, sex, second, lat, school |
| Data | `TABLE5.xlsx` | 1 | lat |
| Data | `firm_asset.dta` | 1 | name |
| Data | `firm_balance.dta` | 1 | name |
| Data | `firm_balance.dta` | 1 | name |
| Data | `firm_debt.dta` | 1 | name |
| Data | `firm_forasset.dta` | 1 | name |
| Data | `firm_fordebt.dta` | 1 | name |
| Data | `firmid_cname.dta` | 1 | name |
| Data | `group_history.dta` | 1 | name |
| Data | `merger_cases.dta` | 2 | name |
| Data | `merger_type_cases.dta` | 1 | name |
| Data | `political_events.csv` | 1 | url |
| Data | `population.csv` | 1 | lat |
| Data | `population.csv` | 1 | lat |
| Data | `wiot_full.dta` | 2 | country |
| Code | `BRIBERY.do` | 81 | loc, name, lat, lon |
| Code | `CONCENTRATION.do` | 19 | loc, name, lat |
| Code | `DATA_CLEANING.do` | 8 | name |
| Code | `DISTRIBUTED_LAG.do` | 91 | loc, name, lon |
| Code | `DKL_MARKUP.m` | 7 | name |
| Code | `ESTIMATION_PROD_FUNC.do` | 25 | lat, name, loc |
| Code | `FIGURE6_scatter_plot_villain.do` | 3 | name |
| Code | `HCI_Drive.do` | 37 | loc, name, lat |
| Code | `MATLAB_part1.m` | 1 | name |
| Code | `MATLAB_part2.m` | 1 | name |
| Code | `Merger.do` | 38 | name, loc |
| Code | `PF_EST_RESULT.do` | 57 | loc, name |
| Code | `PROD_FUNC_BW_MARKUP.m` | 32 | name, block, loc |
| Code | `PROD_FUNC_MARKUP.m` | 33 | name, city, block, loc |
| Code | `SHELL.do` | 3 | name, lat |
| Code | `SHOCK_CORR.do` | 80 | lat, loc, name, lname, second |
| Code | `SHOCK_VALIDATION.do` | 52 | name, country, loc, lat, lon |
| Code | `SUB_CLASSIFICATION.do` | 1 | loc |
| Code | `SUB_SECTOR_AGG.do` | 9 | lat, city, house, social, son |
| Code | `TABLEB4.tex` | 1 | son |
| Code | `TABLEB5.tex` | 2 | lat, lon |
| Code | `TO_MATLAB.do` | 26 | name, country, lat, sex |
| Code | `build_counterfactual_period_cache.m` | 3 | loc |
| Code | `build_model_static_cache.m` | 1 | name |
| Code | `collect_results1.m` | 3 | block, lat, loc |
| Code | `collect_results_robust.m` | 3 | block, lat, loc |
| Code | `compute_block.m` | 2 | block, loc, name |
| Code | `compute_block_only_tau_k.m` | 6 | block, loc, lat, name |
| Code | `compute_block_only_tau_l.m` | 6 | block, loc, lat, name |
| Code | `invprctile.m` | 11 | lat, lon |
| Code | `linspecer.m` | 4 | lon, child, lat |
| Code | `making_figure2.m` | 4 | loc, location |
| Code | `making_figure3.m` | 2 | loc, location |
| Code | `making_figure4.m` | 1 | lat, loc, location |
| Code | `making_figure5.m` | 1 | lat, loc, location |
| Code | `making_figure7_AB.m` | 5 | lat, loc, location |
| Code | `making_figure7_CD.m` | 5 | lat, loc, location |
| Code | `making_figureB13.m` | 3 | lat, loc, location |
| Code | `making_figureB14.m` | 3 | lat, loc, location |
| Code | `making_figureB7.m` | 2 | loc, location |
| Code | `making_figureB9.m` | 1 | lat, loc, location, son |
| Code | `making_table2.m` | 1 | name |
| Code | `making_table3.m` | 1 | name |
| Code | `making_table4.m` | 1 | name |
| Code | `making_table6.m` | 1 | name |
| Code | `making_table7.m` | 2 | name, lat |
| Code | `making_tableB11.m` | 9 | name, lat |
| Code | `making_tableB4.m` | 2 | name, son |
| Code | `model_extract_shock.m` | 26 | block, loc, lon, name |
| Code | `model_extract_shock_dynamics.m` | 9 | lat, loc, lon, block |
| Code | `model_given_shock.m` | 8 | lat, lon, name |
| Code | `model_given_shock_dynamics.m` | 5 | lat, lon |
| Code | `model_given_shock_imp_pen.m` | 8 | lat, lon, name |
| Code | `model_relative_residual.m` | 4 | lat, name |
| Code | `model_solve.m` | 17 | block, loc, lon, name, lat |
| Code | `model_solve_ss.m` | 6 | lat, lon |
| Code | `model_solve_ss_A_j_fix.m` | 1 | lat |
| Code | `model_solve_ss_profit_fix.m` | 1 | lat |
| Code | `model_solve_ss_tau.m` | 1 | lat |
| Code | `model_until_ss.m` | 6 | lat, lon |
| Code | `model_until_ss_A_j_fix.m` | 1 | lat |
| Code | `model_until_ss_profit_fix.m` | 1 | lat |
| Code | `model_until_ss_tau.m` | 1 | lat |
| Code | `removing_granular_shocks.m` | 10 | name |
| Code | `removing_granular_shocks_top10.m` | 10 | name |
| Code | `removing_granular_shocks_top4.m` | 10 | name |
| Code | `run_robustness.m` | 1 | name |
| Code | `save_result.m` | 42 | name, block, loc, lat |
| Code | `set_parameters_load_data.m` | 7 | city, name, lat |
| Code | `solve_counterfactual.m` | 4 | loc, lon, name |
| Code | `solve_counterfactual_dynamics.m` | 10 | lat, name, second, loc |
| Code | `solve_counterfactual_dynamics_A_j_fix.m` | 7 | lat, name, second |
| Code | `solve_counterfactual_dynamics_profit_fix.m` | 7 | lat, name, second |
| Code | `solve_counterfactual_imp_pen.m` | 4 | loc, lon, name |
| Code | `solve_counterfactual_tau_dynamics.m` | 9 | lat, name, second |
| Code | `solve_counterfactual_tau_dynamics_A_j_fix.m` | 7 | lat, name, second |
| Code | `solve_counterfactual_tau_dynamics_profit_fix.m` | 7 | lat, name, second |
| Code | `solve_counterfactual_wedge.m` | 4 | loc, lon, name |
| Code | `solve_full_model_only_tau_k.m` | 99 | name, lat, block, loc |
| Code | `solve_full_model_only_tau_l.m` | 99 | name, lat, block, loc, son |
| Code | `solve_full_model_part1.m` | 56 | name, block, loc, lat |
| Code | `solve_full_model_part2.m` | 9 | name, lat |
| Code | `solve_full_model_robustness.m` | 44 | name, block, loc, lat |
| Code | `spillover_region.do` | 2 | name, loc |
| Code | `wmean.m` | 2 | lon |

### Data Files

**/replication-package/Replication_JPE/DATA/firm_balance.dta**

- Variable: `cname` (label: *기업명*)
  - Matched terms: name
  - Sample values: 천우사, 에이스하이텍(주), (주)메타바이오메드

**/replication-package/Replication_JPE/DATA/firmid_cname.dta**

- Variable: `cname` (label: *기업명*)
  - Matched terms: name
  - Sample values: 세진식품(주), 한성수산식품(주), (주)송림푸드

**/replication-package/Replication_JPE/DATA/group_history.dta**

- Variable: `gname` (label: *old_kyel_k*)
  - Matched terms: name
  - Sample values: 갑을합섬, 갑을합성, 갑을상사

**/replication-package/Replication_JPE/DATA/merger_cases.dta**

- Variable: `cname_A` (label: *firm_name_k*)
  - Matched terms: name
  - Sample values: 강원산업㈜, (주)갑을금속, 거성산업㈜
- Variable: `cname_T` (label: *firm_name_k*)
  - Matched terms: name
  - Sample values: 삼표중공업㈜, ㈜갑을방적, ㈜삼익가구

**/replication-package/Replication_JPE/DATA/merger_type_cases.dta**

- Variable: `cname` (label: *firm_name_k*)
  - Matched terms: name
  - Sample values: 삼표중공업㈜, 강원산업㈜, ㈜갑을방적

**/replication-package/Replication_JPE/INPUT/population.csv**

- Variable: `population`
  - Matched terms: lat
  - Sample values: 33505406, 34103149, 34692266

**/replication-package/Replication_JPE/RAW/AGG/population.csv**

- Variable: `population`
  - Matched terms: lat
  - Sample values: 33505406, 34103149, 34692266

**/replication-package/Replication_JPE/RAW/EUKLEMS/EUKLEMS_KOR_WK_2015_YL.xlsx**

- Variable: `Variables (Sheetname)`
  - Matched terms: name
  - Sample values: GO, VA, II

**/replication-package/Replication_JPE/RAW/FIRM/firm_balance.dta**

- Variable: `cname` (label: *기업명*)
  - Matched terms: name
  - Sample values: 천우사, 에이스하이텍(주), (주)메타바이오메드

**/replication-package/Replication_JPE/RAW/Lee_human_capital/LeeLee_v1.dta**

- Variable: `country` (label: *Country name*)
  - Matched terms: country, name
  - Sample values: Australia, Austria, Belgium
- Variable: `hc` (label: *Human capital,  population aged 15-64*)
  - Matched terms: lat
  - Sample values: 1.1417580842971802, 1.1589900255203247, 1.1893651485443115
- Variable: `hca` (label: *Alternative human capital,  population aged 15-64*)
  - Matched terms: lat
  - Sample values: 1.2468675374984741, 1.274677038192749, 1.3433843851089478
- Variable: `hyr` (label: *Tertiary years of schooling, population aged 15-64*)
  - Matched terms: lat, school
  - Sample values: 0.0006099274614825845, 0.0005794807220809162, 0.0005600135191343725
- Variable: `lh` (label: *Percentage of tertiary, population aged 15-64*)
  - Matched terms: lat
  - Sample values: 0.019999999552965164, 0.020106293261051178, 0.020351899787783623
- Variable: `lhc` (label: *Percentage of tertiary complete, population aged 15-64*)
  - Matched terms: lat
  - Sample values: 0.01049568597227335, 0.008973176591098309, 0.00789206475019455
- Variable: `lp` (label: *Percentage of primary, population aged 15-64*)
  - Matched terms: lat
  - Sample values: 35.302574157714844, 38.266212463378906, 44.73816680908203
- Variable: `lpc` (label: *Percentage of primary complete, population aged 15-64*)
  - Matched terms: lat
  - Sample values: 8.566478729248047, 10.467007637023926, 11.809449195861816
- Variable: `ls` (label: *Percentage of secondary, population aged 15-64*)
  - Matched terms: lat, second
  - Sample values: 0.07133036851882935, 0.11269515007734299, 0.37118735909461975
- Variable: `lsc` (label: *Percentage of secondary complete, population aged 15-64*)
  - Matched terms: lat, second
  - Sample values: 0.019550954923033714, 0.02855953574180603, 0.07949114590883255
- Variable: `lu` (label: *Percentage of no schooling, population aged 15-64*)
  - Matched terms: lat, school
  - Sample values: 64.62554931640625, 61.61708068847656, 54.880210876464844
- Variable: `pop` (label: *Population (thousands)*)
  - Matched terms: lat
  - Sample values: 398.0, 466.3285827636719, 579.0
- Variable: `pyr` (label: *Primary years of schooling, population aged 15-64*)
  - Matched terms: lat, school
  - Sample values: 1.3215514421463013, 1.4699584245681763, 1.7199060916900635
- Variable: `sec` (label: *Secondary adjusted enrollment ratio (%)*)
  - Matched terms: second
  - Sample values: 0.0, 0.0015160352922976017, 0.003977600950747728
- Variable: `sex` (label: *Total (MF), Female (F), Male (M)*)
  - Matched terms: sex
  - Sample values: F, M, MF
- Variable: `syr` (label: *Secondary years of schooling, population aged 15-64*)
  - Matched terms: lat, school, second
  - Sample values: 0.0035309300292283297, 0.0049520451575517654, 0.013730757869780064
- Variable: `tyr` (label: *Total years of schooling, population aged 15-64*)
  - Matched terms: lat, school
  - Sample values: 1.3256922960281372, 1.475489854812622, 1.7341969013214111

**/replication-package/Replication_JPE/RAW/Shock_validation/Foreign_debt/firm_asset.dta**

- Variable: `cname`
  - Matched terms: name
  - Sample values: 에이스하이텍(주), (주)메타바이오메드, (주)코라

**/replication-package/Replication_JPE/RAW/Shock_validation/Foreign_debt/firm_debt.dta**

- Variable: `cname`
  - Matched terms: name
  - Sample values: 에이스하이텍(주), (주)메타바이오메드, (주)코라

**/replication-package/Replication_JPE/RAW/Shock_validation/Foreign_debt/firm_forasset.dta**

- Variable: `cname`
  - Matched terms: name
  - Sample values: 한국가스공사, (주)케이티앤지, 코스맥스비티아이(주)

**/replication-package/Replication_JPE/RAW/Shock_validation/Foreign_debt/firm_fordebt.dta**

- Variable: `cname`
  - Matched terms: name
  - Sample values: 한국가스공사, (주)케이티앤지, (주)인팩

**/replication-package/Replication_JPE/RAW/WIOD/wiot_full.dta**

- Variable: `col_country`
  - Matched terms: country
  - Sample values: AUS
- Variable: `row_country`
  - Matched terms: country
  - Sample values: AUS

**/replication-package/Replication_JPE/RAW/political_events/political_events.csv**

- Variable: `source_url`
  - Matched terms: url
  - Sample values: https://www.worldbank.org/content/dam/Worldbank/Event/DEC/ABCDE/ABCDE-2015/StatusAndBribery_JeongSiegel_ABCDE2015.pdf, https://mobilitytv.co.kr/en/featured/article/103581/, https://www.deseret.com/1995/12/5/19208335/s-korea-business-chiefs-former-president-indicted/

**/replication-package/Replication_JPE/TABLE/TABLE5.xlsx**

- Variable: `Cumulative sum_{tau=0}^{8} beta (b / se / p) from the DL estimated with lags 0__8; FE firm+sector-year; cluster(firmid)`
  - Matched terms: lat
  - Sample values: Technology Adoption, Ihs Credit, Ihs Trade Fair Participation

### Code Files

**/replication-package/Replication_JPE/MATLAB/MATLAB_part1.m**

- Line 3: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/MATLAB_part2.m**

- Line 3: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/build_counterfactual_period_cache.m**

- Line 13: loc
  ```
  [is_present,loc] = ismember(balance.secid(balance_index),secid_full);
  ```
- Line 18: loc
  ```
  if any(loc>length(secid_manu))
  ```
- Line 23: loc
  ```
  firm_counts = accumarray(loc,1,[length(secid_manu),1]);
  ```

**/replication-package/Replication_JPE/MATLAB/build_model_static_cache.m**

- Line 63: name
  ```
  name,num_sector,numel(values));
  ```

**/replication-package/Replication_JPE/MATLAB/collect_results1.m**

- Line 2: block, lat, loc
  ```
  result.A_rel = block_result.A / A_year_guess(1);  % Relative productivity in 1972 level
  ```
- Line 5: block, loc
  ```
  result.s_l = block_result.s_l;
  ```
- Line 6: block, loc
  ```
  result.s_k = block_result.s_k;
  ```

**/replication-package/Replication_JPE/MATLAB/collect_results_robust.m**

- Line 2: block, lat, loc
  ```
  result.A_rel = block_result.A / A_year_guess(1);  % Relative productivity in 1972 level
  ```
- Line 5: block, loc
  ```
  result.s_l = block_result.s_l;
  ```
- Line 6: block, loc
  ```
  result.s_k = block_result.s_k;
  ```

**/replication-package/Replication_JPE/MATLAB/compute_block.m**

- Line 1: block, loc
  ```
  function [to_append,exsh_check,tau_l_vec,tau_k_vec,A_rel_vec,mu_l,mu_y] = compute_block(mom, Par, ma
  ```
- Line 135: name
  ```
  'VariableNames', {'firmid', 'year', 's_total','s_y', 's_k', 's_l', 'A','tau_l','tau_k', 'mu_y','mu_l
  ```

**/replication-package/Replication_JPE/MATLAB/compute_block_only_tau_k.m**

- Line 1: block, loc
  ```
  function [to_append,exsh_check,tau_l_vec,tau_k_vec,A_rel_vec,mu_l,mu_y] = compute_block_only_tau_k(m
  ```
- Line 70: lat
  ```
  % Note that the sectoral export value will not change here (it will be adjusted later)
  ```
- Line 72: lat
  ```
  % % Correction when export resid share is too small(need to be changed later)
  ```
- Line 77: lat
  ```
  % % Correction when export resid share is too small(need to be changed later)
  ```
- Line 90: lat
  ```
  % % Correction (should be changed later)
  ```
- Line 222: name
  ```
  'VariableNames', {'firmid', 'year', 's_total','s_y', 's_k', 's_l', 'A','tau_l','tau_k', 'mu_y','mu_l
  ```

**/replication-package/Replication_JPE/MATLAB/compute_block_only_tau_l.m**

- Line 1: block, loc
  ```
  function [to_append,exsh_check,tau_l_vec,tau_k_vec,A_rel_vec,mu_l,mu_y] = compute_block_only_tau_l(m
  ```
- Line 70: lat
  ```
  % Note that the sectoral export value will not change here (it will be adjusted later)
  ```
- Line 72: lat
  ```
  % % Correction when export resid share is too small(need to be changed later)
  ```
- Line 77: lat
  ```
  % % Correction when export resid share is too small(need to be changed later)
  ```
- Line 90: lat
  ```
  % % Correction (should be changed later)
  ```
- Line 238: name
  ```
  'VariableNames', {'firmid', 'year', 's_total','s_y', 's_k', 's_l', 'A','tau_l','tau_k', 'mu_y','mu_l
  ```

**/replication-package/Replication_JPE/MATLAB/invprctile.m**

- Line 16: lat
  ```
  %             are to be calculated
  ```
- Line 17: lat
  ```
  %  plot_pos - plotting positions that determine interpolation method.
  ```
- Line 41: lon
  ```
  %        column of x. For N-dimension arrays, INVPRCTILE operates along the
  ```
- Line 82: lon
  ```
  % Figure out which dimension prctile will work along.
  ```
- Line 137: lat
  ```
  %% Calculate inverse percentile
  ```
- Line 149: lon
  ```
  % leaves a matrix, and we can work along columns.
  ```
- Line 161: lat
  ```
  % For interpolation yi = interp1(x,Y,xi) x must be vector,so work on
  ```
- Line 163: lat
  ```
  extrapvalMin = 0; % extrapolation value for outsite range (lower end)
  ```
- Line 164: lat
  ```
  extrapvalMax = 1; % extrapolation value for outsite range (upper end)
  ```
- Line 184: lat
  ```
  % Perform extrapolation for elements of xq outside the range of xx
  ```
- Line 209: lat
  ```
  % Perform extrapolation for elements of xq outside the range of xx
  ```

**/replication-package/Replication_JPE/MATLAB/linspecer.m**

- Line 12: lon
  ```
  % lineStyles = linspecer(N,'sequential'); forces the colors to vary along a spectrum
  ```
- Line 21: child
  ```
  % axes('NextPlot','replacechildren', 'ColorOrder',C);
  ```
- Line 55: lat
  ```
  % thought was a bit too bright. In addition some interpolation is going on
  ```
- Line 249: lat
  ```
  % Eat a approximate colormap, then interpolate the rest of it up.
  ```

**/replication-package/Replication_JPE/MATLAB/making_figure2.m**

- Line 6: loc, location
  ```
  legend("Average","Top 3 / Others",'location','northwest')
  ```
- Line 23: loc, location
  ```
  legend("Average","Top 3 / Others",'location','northwest')
  ```
- Line 42: loc, location
  ```
  legend("Standard Deviation (left)","Top 3 / Others (right)",'location','north')
  ```
- Line 73: loc, location
  ```
  legend("Standard Deviation (left)","Top 3 / Others (right)",'location','northwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figure3.m**

- Line 24: loc, location
  ```
  legend("Aggregate Markup","Top 3 Markup",'location','northwest')
  ```
- Line 40: loc, location
  ```
  legend("Aggregate Markdown","Top 3 Markdown",'location','northwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figure4.m**

- Line 10: lat, loc, location
  ```
  legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All","Data",'Interpreter','latex','location','northwest'
  ```

**/replication-package/Replication_JPE/MATLAB/making_figure5.m**

- Line 10: lat, loc, location
  ```
  legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All","Data",'Interpreter','latex','location','northwest'
  ```

**/replication-package/Replication_JPE/MATLAB/making_figure7_AB.m**

- Line 12: lat
  ```
  text(xpos, 1 + gap, '$\uparrow$ Relative tax on the top-3', ...
  ```
- Line 15: lat
  ```
  'FontSize', 16,'Interpreter','latex');
  ```
- Line 17: lat
  ```
  text(xpos, 1 - gap, '$\downarrow$ Relative subsidy to the top-3', ...
  ```
- Line 20: lat
  ```
  'FontSize', 16,'Interpreter','latex');
  ```
- Line 39: loc, location
  ```
  legend("Factual","Counterfactual",'location','northwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figure7_CD.m**

- Line 12: lat
  ```
  text(xpos, 1 + gap, '$\uparrow$ Relative tax on the top-3', ...
  ```
- Line 15: lat
  ```
  'FontSize', 16,'Interpreter','latex');
  ```
- Line 17: lat
  ```
  text(xpos, 1 - gap, '$\downarrow$ Relative subsidy to the top-3', ...
  ```
- Line 20: lat
  ```
  'FontSize', 16,'Interpreter','latex');
  ```
- Line 38: loc, location
  ```
  legend("Factual","Counterfactual",'location','northwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figureB13.m**

- Line 10: lat, loc, location
  ```
  legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
  ```
- Line 31: lat, loc, location
  ```
  % legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
  ```
- Line 52: lat, loc, location
  ```
  % legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figureB14.m**

- Line 11: lat, loc, location
  ```
  legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
  ```
- Line 33: lat, loc, location
  ```
  % legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
  ```
- Line 75: lat, loc, location
  ```
  legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figureB7.m**

- Line 7: loc, location
  ```
  legend("Domestic Markup","Aggregate Markup",'location','northwest')
  ```
- Line 24: loc, location
  ```
  legend("Domestic Markup","Without Import / Export Penetration",'location','northwest')
  ```

**/replication-package/Replication_JPE/MATLAB/making_figureB9.m**

- Line 8: lat, loc, location, son
  ```
  legend("Baseline","Oligopoly","Oligopsony","Monopolistic Competition",'Interpreter','latex','locatio
  ```

**/replication-package/Replication_JPE/MATLAB/making_table2.m**

- Line 5: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/making_table3.m**

- Line 5: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/making_table4.m**

- Line 3: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/making_table6.m**

- Line 3: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/making_table7.m**

- Line 5: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 68: lat
  ```
  % Format negatives as "$-$15.41", matching the paper's LaTex convention.
  ```

**/replication-package/Replication_JPE/MATLAB/making_tableB11.m**

- Line 3: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 158: name
  ```
  variable_name = preferred_variables{variable_idx};
  ```
- Line 159: name
  ```
  if isfield(loaded_result,variable_name)
  ```
- Line 160: name
  ```
  candidate = loaded_result.(variable_name);
  ```
- Line 168: name
  ```
  variable_names = fieldnames(loaded_result);
  ```
- Line 170: name
  ```
  for variable_idx = 1:numel(variable_names)
  ```
- Line 171: name
  ```
  candidate = loaded_result.(variable_names{variable_idx});
  ```
- Line 173: name
  ```
  matching_variables{end+1} = variable_names{variable_idx}; %#ok<AGROW>
  ```
- Line 190: lat
  ```
  formatted_values{value_idx} = format_latex_number(result_vector(value_idx));
  ```

**/replication-package/Replication_JPE/MATLAB/making_tableB4.m**

- Line 4: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 25: son
  ```
  fprintf(Fid,'%s\n', ' & Oligopoly & Oligopsony & Monopolistic Competition \\  \hline' );
  ```

**/replication-package/Replication_JPE/MATLAB/model_extract_shock.m**

- Line 3: block, loc
  ```
  model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result, markup, ma
  ```
- Line 62: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 63: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 72: block, loc
  ```
  tau_l_vec = block_result.tau_l( block_result.year==year_vec(i));
  ```
- Line 73: block, loc
  ```
  tau_k_vec = block_result.tau_k( block_result.year==year_vec(i));
  ```
- Line 74: block, loc
  ```
  tau_l_pctile = block_result.tau_l_pctile( block_result.year==year_vec(i));
  ```
- Line 75: block, loc
  ```
  tau_k_pctile = block_result.tau_k_pctile( block_result.year==year_vec(i));
  ```
- Line 77: block, loc
  ```
  A_rel_vec = block_result.A( block_result.year==year_vec(i));
  ```
- Line 78: block, loc
  ```
  DF_vec = block_result.DF( block_result.year==year_vec(i));
  ```
- Line 80: block, loc
  ```
  firmid_vec = block_result.firmid( block_result.year==year_vec(i));
  ```
- Line 81: block, loc
  ```
  s_total_vec = block_result.s_total( block_result.year==year_vec(i));
  ```
- Line 89: lon
  ```
  gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
  ```
- Line 91: block, loc
  ```
  age_bin_vec = block_result.age_bin( block_result.year==year_vec(i));
  ```
- Line 93: block, loc
  ```
  block.tau_l_vec = tau_l_vec;
  ```
- Line 94: block, loc
  ```
  block.tau_k_vec = tau_k_vec;
  ```
- Line 95: block, loc
  ```
  block.tau_l_pctile = tau_l_pctile;
  ```
- Line 96: block, loc
  ```
  block.tau_k_pctile = tau_k_pctile;
  ```
- Line 97: block, loc
  ```
  block.A_rel_vec = A_rel_vec;
  ```
- Line 98: block, loc
  ```
  block.DF_vec = DF_vec;
  ```
- Line 99: block, loc
  ```
  block.firmid = firmid_vec;
  ```
- Line 100: block, loc
  ```
  block.s_total = s_total_vec;
  ```
- Line 101: block, loc
  ```
  block.age_bin = age_bin_vec;
  ```
- Line 119: name
  ```
  result = array2table(zeros(1,24), 'VariableNames',...
  ```
- Line 130: block, loc
  ```
  [x_next,block] = model_solve(x_guess,A_year_guess(i), P_j_init ,Par, mom, block, year, result_pre, 0
  ```
- Line 137: block, loc
  ```
  [x_next,~,norm_factor] = model_solve(x_guess, A_year_guess(i), P_j_init, Par, mom, block, year, resu
  ```
- Line 142: block, loc
  ```
  model_solve(x_next, A_year_guess(i), P_j_init, Par, mom, block, year, result_pre, 1, markup, markdow
  ```

**/replication-package/Replication_JPE/MATLAB/model_extract_shock_dynamics.m**

- Line 3: lat
  ```
  % This code extracts E_t and calculate K^*, P^*, R^*, Y^*, C^*
  ```
- Line 4: lat
  ```
  % Then, solve the model until steady state. In that way, we can calculate C_t
  ```
- Line 64: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 65: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 80: lon
  ```
  gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
  ```
- Line 142: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(end)), secid_full);
  ```
- Line 143: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 155: lon
  ```
  gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
  ```
- Line 240: block, loc
  ```
  [x_next,block] = model_until_ss(x_guess, k_guess_until_ss(i), Par, mom, shock_firm, shock_agg, marku
  ```

**/replication-package/Replication_JPE/MATLAB/model_given_shock.m**

- Line 39: lat
  ```
  alpha_j = Par.alpha_j(:); % Will be changed later
  ```
- Line 95: lon
  ```
  % D_j_F_long = repelem(D_j_F,firm_num);
  ```
- Line 105: lon
  ```
  pi_H_vec_long = repelem(pi_H,firm_num);
  ```
- Line 108: lon
  ```
  epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
  ```
- Line 155: lon
  ```
  l_vec_sector_long = repelem(l_vec_sector,firm_num);
  ```
- Line 156: lon
  ```
  s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
  ```
- Line 313: name
  ```
  'VariableNames', {'firmid', 'p_d','y_d','p_x','y_x','p_m','m','A_fj','k','l','w_vec','tau_l','tau_k'
  ```
- Line 318: lat
  ```
  % Calculating "weighted" average of wedge
  ```

**/replication-package/Replication_JPE/MATLAB/model_given_shock_dynamics.m**

- Line 25: lat
  ```
  alpha_j = Par.alpha_j; % Will be changed later
  ```
- Line 83: lon
  ```
  pi_H_vec_long = repelem(pi_H,firm_num);
  ```
- Line 90: lon
  ```
  epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
  ```
- Line 130: lon
  ```
  l_vec_sector_long = repelem(l_vec_sector,firm_num);
  ```
- Line 131: lon
  ```
  s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
  ```

**/replication-package/Replication_JPE/MATLAB/model_given_shock_imp_pen.m**

- Line 29: lat
  ```
  alpha_j = Par.alpha_j; % Will be changed later
  ```
- Line 79: lon
  ```
  % D_j_F_long = repelem(D_j_F,firm_num);
  ```
- Line 89: lon
  ```
  pi_H_vec_long = repelem(pi_H_vec,firm_num);
  ```
- Line 96: lon
  ```
  epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
  ```
- Line 145: lon
  ```
  l_vec_sector_long = repelem(l_vec_sector,firm_num);
  ```
- Line 146: lon
  ```
  s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
  ```
- Line 313: name
  ```
  'VariableNames', {'firmid', 'p_d','y_d','p_x','y_x','p_m','m','A_fj','k','l','w_vec','tau_l','tau_k'
  ```
- Line 318: lat
  ```
  % Calculating "weighted" average of wedge
  ```

**/replication-package/Replication_JPE/MATLAB/model_relative_residual.m**

- Line 5: lat
  ```
  error('model_relative_residual:NonfiniteIterate',...
  ```
- Line 13: name
  ```
  caller = sprintf('%s line %d',stack(1).name,stack(1).line);
  ```
- Line 15: lat
  ```
  error('model_relative_residual:NonvectorIterate',...
  ```
- Line 24: lat
  ```
  error('model_relative_residual:IterateSizeMismatch',...
  ```

**/replication-package/Replication_JPE/MATLAB/model_solve.m**

- Line 1: block, loc
  ```
  function [x_next,block,norm_factor,P_j_F, def, phi_bar, GDP, sale_vec, to_append,util,C,L,P_j_tilde,
  ```
- Line 2: block, loc
  ```
  model_solve(x,  A_year, P_j_init, Par, mom, block, year, result_pre, final, markup, markdown)
  ```
- Line 40: block, loc
  ```
  A_rel_vec = block.A_rel_vec;
  ```
- Line 41: block, loc
  ```
  DF_rel = block.DF_vec;
  ```
- Line 51: block, loc
  ```
  block.tau_k_vec = block.tau_k_vec.*repelem(tau_k_level_guess,firm_num);
  ```
- Line 52: block, loc
  ```
  block.tau_l_vec = block.tau_l_vec.*repelem(tau_l_level_guess,firm_num);
  ```
- Line 54: block, loc
  ```
  tau_k_vec = block.tau_k_vec;
  ```
- Line 55: block, loc
  ```
  tau_l_vec = block.tau_l_vec;
  ```
- Line 84: lon
  ```
  pi_H_vec_long = repelem(pi_H_vec,firm_num);
  ```
- Line 91: lon
  ```
  epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
  ```
- Line 133: lon
  ```
  l_vec_sector_long = repelem(l_vec_sector,firm_num);
  ```
- Line 134: lon
  ```
  s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
  ```
- Line 272: block, loc
  ```
  to_append = array2table([block.firmid p_d y_d p_x y_x P_j_M_vec, M_vec A_vec...
  ```
- Line 273: block, loc
  ```
  k_vec w_vec l_vec tau_l_vec tau_k_vec block.tau_l_pctile block.tau_k_pctile ...
  ```
- Line 274: block, loc
  ```
  mu_l_vec mu_y_vec DF_vec year_mat sector_vec block.s_total DF_real DF_tilde block.age_bin],...
  ```
- Line 275: name
  ```
  'VariableNames', {'firmid', 'p_d','y_d','p_x','y_x','p_m','m','A_fj','k','w','l','tau_l','tau_k',...
  ```
- Line 306: lat
  ```
  % Calculating "weighted" average of wedge
  ```

**/replication-package/Replication_JPE/MATLAB/model_solve_ss.m**

- Line 40: lat
  ```
  alpha_j = Par.alpha_j(:); % Will be changed later
  ```
- Line 104: lon
  ```
  pi_H_vec_long = repelem(pi_H,firm_num);
  ```
- Line 107: lon
  ```
  epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
  ```
- Line 146: lon
  ```
  l_vec_sector_long = repelem(l_vec_sector,firm_num);
  ```
- Line 147: lon
  ```
  s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
  ```
- Line 226: lat
  ```
  % Calculating "weighted" average of wedge
  ```

**/replication-package/Replication_JPE/MATLAB/model_solve_ss_A_j_fix.m**

- Line 25: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```

**/replication-package/Replication_JPE/MATLAB/model_solve_ss_profit_fix.m**

- Line 21: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```

**/replication-package/Replication_JPE/MATLAB/model_solve_ss_tau.m**

- Line 34: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```

**/replication-package/Replication_JPE/MATLAB/model_until_ss.m**

- Line 39: lat
  ```
  alpha_j = Par.alpha_j(:); % Will be changed later
  ```
- Line 99: lon
  ```
  pi_H_vec_long = repelem(pi_H,firm_num);
  ```
- Line 102: lon
  ```
  epsil_y = (1./sigma_vec+(1./rho_vec-1./sigma_vec).*s_y+(1-1./rho_vec).*pi_H_vec_long.*s_y).^(-1);
  ```
- Line 138: lon
  ```
  l_vec_sector_long = repelem(l_vec_sector,firm_num);
  ```
- Line 139: lon
  ```
  s_l = l_vec.^((eta+1)/eta)./l_vec_sector_long;
  ```
- Line 219: lat
  ```
  % Calculating "weighted" average of wedge
  ```

**/replication-package/Replication_JPE/MATLAB/model_until_ss_A_j_fix.m**

- Line 26: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```

**/replication-package/Replication_JPE/MATLAB/model_until_ss_profit_fix.m**

- Line 22: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```

**/replication-package/Replication_JPE/MATLAB/model_until_ss_tau.m**

- Line 34: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```

**/replication-package/Replication_JPE/MATLAB/removing_granular_shocks.m**

- Line 101: name
  ```
  DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(
  ```
- Line 102: name
  ```
  tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 103: name
  ```
  tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 104: name
  ```
  A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(re
  ```
- Line 106: name
  ```
  DF_agg_growth = array2table([df_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',leng
  ```
- Line 107: name
  ```
  tau_l_agg_growth = array2table([tau_l_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 108: name
  ```
  tau_k_agg_growth = array2table([tau_k_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 109: name
  ```
  A_agg_growth = array2table([a_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length
  ```
- Line 112: name
  ```
  = array2table([A_avg_sector_unweighted_entrant(:) repmat(year_vec(1:end),num_sector,1) repelem(secid
  ```
- Line 114: name
  ```
  = array2table([A_avg_year_entrant(:) year_vec(1:end);0 0],'VariableNames',{'a_level_agg','year'});
  ```

**/replication-package/Replication_JPE/MATLAB/removing_granular_shocks_top10.m**

- Line 101: name
  ```
  DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(
  ```
- Line 102: name
  ```
  tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 103: name
  ```
  tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 104: name
  ```
  A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(re
  ```
- Line 106: name
  ```
  DF_agg_growth = array2table([df_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',leng
  ```
- Line 107: name
  ```
  tau_l_agg_growth = array2table([tau_l_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 108: name
  ```
  tau_k_agg_growth = array2table([tau_k_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 109: name
  ```
  A_agg_growth = array2table([a_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length
  ```
- Line 112: name
  ```
  = array2table([A_avg_sector_unweighted_entrant(:) repmat(year_vec(1:end),num_sector,1) repelem(secid
  ```
- Line 114: name
  ```
  = array2table([A_avg_year_entrant(:) year_vec(1:end);0 0],'VariableNames',{'a_level_agg','year'});
  ```

**/replication-package/Replication_JPE/MATLAB/removing_granular_shocks_top4.m**

- Line 101: name
  ```
  DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(
  ```
- Line 102: name
  ```
  tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 103: name
  ```
  tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 104: name
  ```
  A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(re
  ```
- Line 106: name
  ```
  DF_agg_growth = array2table([df_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',leng
  ```
- Line 107: name
  ```
  tau_l_agg_growth = array2table([tau_l_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 108: name
  ```
  tau_k_agg_growth = array2table([tau_k_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 109: name
  ```
  A_agg_growth = array2table([a_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length
  ```
- Line 112: name
  ```
  = array2table([A_avg_sector_unweighted_entrant(:) repmat(year_vec(1:end),num_sector,1) repelem(secid
  ```
- Line 114: name
  ```
  = array2table([A_avg_year_entrant(:) year_vec(1:end);0 0],'VariableNames',{'a_level_agg','year'});
  ```

**/replication-package/Replication_JPE/MATLAB/run_robustness.m**

- Line 2: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```

**/replication-package/Replication_JPE/MATLAB/save_result.m**

- Line 10: name
  ```
  result_file_name = "result_base.csv";
  ```
- Line 14: name
  ```
  result_file_name = "result_base_notruncation_nosmoothing.csv";
  ```
- Line 22: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 49: name
  ```
  warm_file = @(name) fullfile(warm_start_dir,name);
  ```
- Line 58: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 66: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 67: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 92: lat
  ```
  % Calculate wedge and relative productivity
  ```
- Line 93: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block(mom, Par, markup,markdown);
  ```
- Line 94: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 102: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 103: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 108: block, loc
  ```
  lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
  ```
- Line 109: block, loc
  ```
  upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
  ```
- Line 110: block, loc
  ```
  block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 111: block, loc
  ```
  block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 113: block, loc
  ```
  lower_bound = prctile(block_result.tau_k(block_result.year==year), 1.5);
  ```
- Line 114: block, loc
  ```
  upper_bound = prctile(block_result.tau_k(block_result.year==year), 98.5);
  ```
- Line 115: block, loc
  ```
  block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 116: block, loc
  ```
  block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 122: block, loc
  ```
  % writetable(block_result,OUTPUT+'block_result.csv');
  ```
- Line 123: block, loc
  ```
  if sum(isnan(block_result.DF))+sum(isnan(block_result.tau_l))+sum(isnan(block_result.tau_k))>0
  ```
- Line 130: block, loc
  ```
  block_result = sortrows(block_result, {'firmid', 'year'});  % Sort data by ID, then by year
  ```
- Line 131: block, loc
  ```
  unique_id = unique(block_result.firmid);  % Find all unique IDs
  ```
- Line 138: block, loc
  ```
  currentData = block_result(block_result.firmid == unique_id(i), :);
  ```
- Line 146: block, loc
  ```
  block_result.A = A_ma;
  ```
- Line 147: block, loc
  ```
  block_result.tau_l = tau_l_ma;
  ```
- Line 148: block, loc
  ```
  block_result.tau_k = tau_k_ma;
  ```
- Line 149: block, loc
  ```
  block_result.DF = DF_ma;
  ```
- Line 157: block, loc
  ```
  block_result.tau_l_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 158: block, loc
  ```
  = invprctile(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 159: block, loc
  ```
  block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 160: block, loc
  ```
  block_result.tau_k_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 161: block, loc
  ```
  = invprctile(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 162: block, loc
  ```
  block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 166: block, loc
  ```
  block_result = sortrows(block_result, {'year','secid','firmid'});  % Sort data by year, secid, and f
  ```
- Line 167: block, loc
  ```
  % writetable(block_result,OUTPUT+'block_result.csv');
  ```
- Line 193: block, loc
  ```
  x_guess_cell{i} =  [block_result.s_y(block_result.year==year_vec(i));...
  ```
- Line 194: block, loc
  ```
  block_result.s_l(block_result.year==year_vec(i))/length(secid_full)...
  ```
- Line 208: block, loc
  ```
  [diff, A_year_next,x_guess_cell] = model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, b
  ```
- Line 222: block, loc
  ```
  model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,mark
  ```
- Line 261: name
  ```
  writetable(result,fullfile(OUTPUT,result_file_name))
  ```

**/replication-package/Replication_JPE/MATLAB/set_parameters_load_data.m**

- Line 6: city
  ```
  Par.phi = 1/2; % Fricsh elasticity of labor supply
  ```
- Line 29: name
  ```
  seclist = array2table(unique(GO.secid),'VariableNames',{'secid'});
  ```
- Line 121: lat
  ```
  pop = readtable(INPUT+'Lhat.csv'); % Population (working age)
  ```
- Line 122: lat
  ```
  pop_data = readtable(INPUT+'hc.csv'); % Education adjusted population (working age)
  ```
- Line 124: lat
  ```
  pop_tot_data = readtable(INPUT+'population.csv');
  ```
- Line 125: lat
  ```
  pop_tot_data.population = pop_tot_data.population/pop_tot_data.population(1);
  ```
- Line 144: lat
  ```
  % Calculate sale share of fringe firm, and smooth it
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual.m**

- Line 77: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 78: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 93: lon
  ```
  gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
  ```
- Line 128: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics.m**

- Line 91: lat
  ```
  diff = relative_residual(x_next,x_guess);
  ```
- Line 184: lat
  ```
  diff = relative_residual(x_next,x_guess);
  ```
- Line 299: lat
  ```
  % K_implied as K_hat and calculate C differently..
  ```
- Line 378: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```
- Line 389: lat
  ```
  diff = relative_residual(x_next,x_guess);
  ```
- Line 976: second
  ```
  agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
  ```
- Line 1003: second
  ```
  fprintf('[fast] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
  ```
- Line 1004: second
  ```
  agg_result.fast_stats.elapsed_seconds,lmd);
  ```
- Line 1086: loc
  ```
  [is_present,loc] = ismember(balance.secid(balance_index),secid_full);
  ```
- Line 1092: loc
  ```
  firm_counts = accumarray(loc,1,[length(secid_manu),1]);
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics_A_j_fix.m**

- Line 227: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 320: lat
  ```
  % K_implied as K_hat and calculate C differently.. + here, productivity
  ```
- Line 405: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```
- Line 419: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 1028: second
  ```
  agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
  ```
- Line 1042: second
  ```
  fprintf('[fast:A_j] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
  ```
- Line 1043: second
  ```
  agg_result.fast_stats.elapsed_seconds,lmd);
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_dynamics_profit_fix.m**

- Line 234: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 327: lat
  ```
  % K_implied as K_hat and calculate C differently.. + here, productivity
  ```
- Line 412: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```
- Line 425: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 1034: second
  ```
  agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
  ```
- Line 1048: second
  ```
  fprintf('[fast:profit] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
  ```
- Line 1049: second
  ```
  agg_result.fast_stats.elapsed_seconds,lmd);
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_imp_pen.m**

- Line 79: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 80: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 95: lon
  ```
  gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
  ```
- Line 131: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics.m**

- Line 245: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 367: lat
  ```
  % K_implied as K_hat and calculate C differently..
  ```
- Line 461: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```
- Line 475: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 1099: second
  ```
  agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
  ```
- Line 1129: second
  ```
  fprintf('[fast:tau] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
  ```
- Line 1130: second
  ```
  agg_result.fast_stats.elapsed_seconds,lmd);
  ```
- Line 1191: lat
  ```
  relative_tolerance = 1e-3;
  ```
- Line 1203: lat
  ```
  absolute_tolerance + relative_tolerance.*scale);
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics_A_j_fix.m**

- Line 242: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 335: lat
  ```
  % K_implied as K_hat and calculate C differently.. + here, productivity
  ```
- Line 428: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```
- Line 442: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 1053: second
  ```
  agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
  ```
- Line 1067: second
  ```
  fprintf('[fast:tau+A_j] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
  ```
- Line 1068: second
  ```
  agg_result.fast_stats.elapsed_seconds,lmd);
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_tau_dynamics_profit_fix.m**

- Line 248: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 341: lat
  ```
  % K_implied as K_hat and calculate C differently.. + here, productivity
  ```
- Line 434: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```
- Line 447: lat
  ```
  diff = model_relative_residual(x_next,x_guess);
  ```
- Line 1058: second
  ```
  agg_result.fast_stats.elapsed_seconds = toc(fast_timer);
  ```
- Line 1072: second
  ```
  fprintf('[fast:tau+profit] Finished in %.1f seconds. Welfare change=%.6g percent.\n',...
  ```
- Line 1073: second
  ```
  agg_result.fast_stats.elapsed_seconds,lmd);
  ```

**/replication-package/Replication_JPE/MATLAB/solve_counterfactual_wedge.m**

- Line 71: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 72: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 87: lon
  ```
  gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
  ```
- Line 121: name
  ```
  result_final = array2table(zeros(1,21), 'VariableNames',...
  ```

**/replication-package/Replication_JPE/MATLAB/solve_full_model_only_tau_k.m**

- Line 4: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 26: name
  ```
  warm_file = @(name) fullfile(warm_start_dir,name);
  ```
- Line 48: lat
  ```
  %% Calculate wedge and productivity
  ```
- Line 49: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 52: lat
  ```
  % Calculate sale share of fringe firm, and smooth it
  ```
- Line 69: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 70: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 95: lat
  ```
  % Calculate wedge and relative productivity
  ```
- Line 96: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block(mom, Par, markup,markdown);
  ```
- Line 97: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 105: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 106: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 110: block, loc
  ```
  lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
  ```
- Line 111: block, loc
  ```
  upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
  ```
- Line 112: block, loc
  ```
  block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 113: block, loc
  ```
  block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 115: block, loc
  ```
  lower_bound = prctile(block_result.tau_k(block_result.year==year), 1.5);
  ```
- Line 116: block, loc
  ```
  upper_bound = prctile(block_result.tau_k(block_result.year==year), 98.5);
  ```
- Line 117: block, loc
  ```
  block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 118: block, loc
  ```
  block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 120: block, loc
  ```
  lower_bound = prctile(block_result.A(block_result.year==year), 1.5);
  ```
- Line 121: block, loc
  ```
  upper_bound = prctile(block_result.A(block_result.year==year), 98.5);
  ```
- Line 122: block, loc
  ```
  block_result.A(block_result.A < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 123: block, loc
  ```
  block_result.A(block_result.A > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 125: block, loc
  ```
  upper_bound = prctile(block_result.DF(block_result.year==year), 98.5);
  ```
- Line 126: block, loc
  ```
  block_result.DF(block_result.DF > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 132: block, loc
  ```
  block_result.A_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 133: block, loc
  ```
  = invprctile(block_result.A(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 134: block, loc
  ```
  block_result.A(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 139: block, loc
  ```
  block_result=sortrows(block_result,{'firmid','year'});
  ```
- Line 140: block, loc
  ```
  firmlist=unique(block_result.firmid); % & result.firmid~=8973
  ```
- Line 142: block, loc
  ```
  firmRows = find(block_result.firmid==firmlist(i));
  ```
- Line 143: block, loc
  ```
  secid_sample = block_result.secid(firmRows);
  ```
- Line 144: block, loc
  ```
  year_sample = block_result.year(firmRows);
  ```
- Line 146: block, loc
  ```
  block_result.A(firmRows(j)) ...
  ```
- Line 147: block, loc
  ```
  = prctile(block_result.A(block_result.year==year_sample(j) & block_result.secid==secid_sample(j)),bl
  ```
- Line 151: block, loc
  ```
  block_result_temp = block_result;
  ```
- Line 152: block, loc
  ```
  block_result_temp.fringe = (block_result_temp.firmid<0);
  ```
- Line 153: block, loc
  ```
  block_result_temp = sortrows(block_result_temp, {'year','secid','fringe','firmid'}); % put fringe fi
  ```
- Line 156: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 159: lat
  ```
  % Calculate sale share of fringe firm, and smooth it
  ```
- Line 176: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 177: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 202: block, loc
  ```
  mom.A_vec = block_result_temp.A(block_result_temp.secid==j & block_result_temp.year==year_vec(i) & b
  ```
- Line 204: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block_only_tau_k(mom, Par, markup,markdown);
  ```
- Line 205: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 207: block, loc
  ```
  lower_bound = prctile(block_result.tau_k(block_result.year==year & block_result.secid==j), 5);
  ```
- Line 208: block, loc
  ```
  upper_bound = prctile(block_result.tau_k(block_result.year==year & block_result.secid==j), 95);
  ```
- Line 209: block, loc
  ```
  block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year & block_result.secid==
  ```
- Line 210: block, loc
  ```
  block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year & block_result.secid==
  ```
- Line 218: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 219: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 225: block, loc
  ```
  block_result.minus_s_total = -block_result.s_total;
  ```
- Line 226: block, loc
  ```
  block_result.fringe = (block_result.firmid<0);
  ```
- Line 227: block, loc
  ```
  block_result.top3=zeros(length(block_result.s_total),1);
  ```
- Line 228: block, loc
  ```
  block_result_temp.minus_s_total = -block_result_temp.s_total;
  ```
- Line 229: block, loc
  ```
  block_result_temp.fringe = (block_result_temp.firmid<0);
  ```
- Line 230: block, loc
  ```
  block_result_temp.top3=zeros(length(block_result_temp.s_total),1);
  ```
- Line 233: block, loc
  ```
  block_result.year_check=(block_result.year~=year_vec(i));
  ```
- Line 234: block, loc
  ```
  block_result.sector_check=(block_result.secid~=j);
  ```
- Line 235: block, loc
  ```
  block_result = sortrows(block_result, {'year_check','sector_check','fringe','minus_s_total'});
  ```
- Line 236: block, loc
  ```
  block_result.top3(1:3) = 1;
  ```
- Line 237: block, loc
  ```
  block_result_temp.year_check=(block_result_temp.year~=year_vec(i));
  ```
- Line 238: block, loc
  ```
  block_result_temp.sector_check=(block_result_temp.secid~=j);
  ```
- Line 239: block, loc
  ```
  block_result_temp = sortrows(block_result_temp, {'year_check','sector_check','fringe','minus_s_total
  ```
- Line 240: block, loc
  ```
  block_result_temp.top3(1:3) = 1;
  ```
- Line 243: block, loc
  ```
  block_result = sortrows(block_result,{'year','secid','firmid'});
  ```
- Line 244: block, loc
  ```
  block_result_temp = sortrows(block_result_temp,{'year','secid','firmid'});
  ```
- Line 252: block, loc
  ```
  tau_k_top3_vec(i,j) = mean(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j
  ```
- Line 253: block, loc
  ```
  ./mean(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j & block_result.firm
  ```
- Line 254: block, loc
  ```
  tau_k_top3_vec_separate(i,j) = mean(block_result.tau_k(block_result.year==year_vec(i) & block_result
  ```
- Line 255: block, loc
  ```
  tau_k_others_vec_separate(i,j) = mean(block_result.tau_k(block_result.year==year_vec(i) & block_resu
  ```
- Line 256: block, loc
  ```
  s_k_top3_vec(i,j) = sum(block_result.s_k(block_result.year==year_vec(i) & block_result.secid==j & bl
  ```
- Line 257: block, loc
  ```
  s_k_top3_vec_base(i,j) = sum(block_result_temp.s_k(block_result_temp.year==year_vec(i) & block_resul
  ```
- Line 270: block, loc
  ```
  block_result.tau_l_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 271: block, loc
  ```
  = invprctile(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 272: block, loc
  ```
  block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 273: block, loc
  ```
  block_result.tau_k_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 274: block, loc
  ```
  = invprctile(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 275: block, loc
  ```
  block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 314: block, loc
  ```
  x_guess_cell{i} =  [block_result.s_y(block_result.year==year_vec(i));...
  ```
- Line 315: block, loc
  ```
  block_result.s_l(block_result.year==year_vec(i))/length(secid_full)...
  ```
- Line 326: block, loc
  ```
  [diff, A_year_next,x_guess_cell] = model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, b
  ```
- Line 342: block, loc
  ```
  model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,mark
  ```
- Line 387: block, lat, loc
  ```
  result.A_rel = block_result.A / A_year_guess(1);  % Relative productivity in 1972 level
  ```
- Line 390: block, loc
  ```
  result.s_l = block_result.s_l;
  ```
- Line 391: block, loc
  ```
  result.s_k = block_result.s_k;
  ```
- Line 704: name
  ```
  DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(
  ```
- Line 705: name
  ```
  tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 706: name
  ```
  tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 707: name
  ```
  A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(re
  ```
- Line 709: name
  ```
  DF_agg_growth = array2table([df_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',leng
  ```
- Line 710: name
  ```
  tau_l_agg_growth = array2table([tau_l_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 711: name
  ```
  tau_k_agg_growth = array2table([tau_k_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)
  ```
- Line 712: name
  ```
  A_agg_growth = array2table([a_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length
  ```
- Line 715: name
  ```
  = array2table([A_avg_sector_unweighted_entrant(:) repmat(year_vec(1:end),num_sector,1) repelem(secid
  ```
- Line 717: name
  ```
  = array2table([A_avg_year_entrant(:) year_vec(1:end);0 0],'VariableNames',{'a_level_agg','year'});
  ```
- Line 874: name
  ```
  has_granular_warm_start = ~isempty(fieldnames(warm_granular));
  ```
- Line 880: lat
  ```
  strcmp(ME.identifier,'model_relative_residual:NonfiniteIterate')
  ```

**/replication-package/Replication_JPE/MATLAB/solve_full_model_only_tau_l.m**

- Line 3: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 25: name
  ```
  warm_file = @(name) fullfile(warm_start_dir,name);
  ```
- Line 45: lat
  ```
  %% Calculate wedge and productivity
  ```
- Line 46: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 49: lat
  ```
  % Calculate sale share of fringe firm, and smooth it
  ```
- Line 66: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 67: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 93: lat
  ```
  % Calculate wedge and relative productivity
  ```
- Line 94: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block(mom, Par, markup,markdown);
  ```
- Line 95: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 102: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 103: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 107: block, loc
  ```
  lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
  ```
- Line 108: block, loc
  ```
  upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
  ```
- Line 109: block, loc
  ```
  block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 110: block, loc
  ```
  block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 112: block, loc
  ```
  lower_bound = prctile(block_result.tau_k(block_result.year==year), 1.5);
  ```
- Line 113: block, loc
  ```
  upper_bound = prctile(block_result.tau_k(block_result.year==year), 98.5);
  ```
- Line 114: block, loc
  ```
  block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 115: block, loc
  ```
  block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 121: block, loc
  ```
  block_result.A_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 122: block, loc
  ```
  = invprctile(block_result.A(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 123: block, loc
  ```
  block_result.A(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 124: block, loc
  ```
  % block_result.A_pctile(block_result.A_pctile<2.5) = 2.5; % Truncation
  ```
- Line 129: block, loc
  ```
  block_result=sortrows(block_result,{'firmid','year'});
  ```
- Line 130: block, loc
  ```
  firmlist=unique(block_result.firmid); % & result.firmid~=8973
  ```
- Line 132: block, loc
  ```
  firmRows = find(block_result.firmid==firmlist(i));
  ```
- Line 133: block, loc
  ```
  secid_sample = block_result.secid(firmRows);
  ```
- Line 134: block, loc
  ```
  year_sample = block_result.year(firmRows);
  ```
- Line 136: block, loc
  ```
  block_result.A(firmRows(j)) ...
  ```
- Line 137: block, loc
  ```
  = prctile(block_result.A(block_result.year==year_sample(j) & block_result.secid==secid_sample(j)),bl
  ```
- Line 141: block, loc
  ```
  block_result_temp = block_result;
  ```
- Line 142: block, loc
  ```
  block_result_temp.fringe = (block_result_temp.firmid<0);
  ```
- Line 143: block, loc
  ```
  block_result_temp = sortrows(block_result_temp, {'year','secid','fringe','firmid'}); % put fringe fi
  ```
- Line 145: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 148: lat
  ```
  % Calculate sale share of fringe firm, and smooth it
  ```
- Line 165: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 166: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 191: block, loc
  ```
  mom.A_vec = block_result_temp.A(block_result_temp.secid==j & block_result_temp.year==year_vec(i) & b
  ```
- Line 192: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block_only_tau_l(mom, Par, markup,markdown);
  ```
- Line 193: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 202: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 203: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 207: block, loc
  ```
  lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
  ```
- Line 208: block, loc
  ```
  upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
  ```
- Line 209: block, loc
  ```
  block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 210: block, loc
  ```
  block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 212: block, loc
  ```
  % lower_bound = prctile(block_result.tau_k(block_result.year==year), 1);
  ```
- Line 213: block, loc
  ```
  % upper_bound = prctile(block_result.tau_k(block_result.year==year), 99);
  ```
- Line 214: block, loc
  ```
  % block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 215: block, loc
  ```
  % block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 217: block, loc
  ```
  % lower_bound = prctile(block_result.A(block_result.year==year), 0.1);
  ```
- Line 218: block, loc
  ```
  % upper_bound = prctile(block_result.A(block_result.year==year), 99.9);
  ```
- Line 219: block, loc
  ```
  % block_result.A(block_result.A < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 220: block, loc
  ```
  % block_result.A(block_result.A > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 222: block, loc
  ```
  % upper_bound = prctile(block_result.DF(block_result.year==year), 99);
  ```
- Line 223: block, loc
  ```
  % block_result.DF(block_result.DF > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 227: block, loc
  ```
  block_result.minus_s_total = -block_result.s_total;
  ```
- Line 228: block, loc
  ```
  block_result.fringe = (block_result.firmid<0);
  ```
- Line 229: block, loc
  ```
  block_result.top3=zeros(length(block_result.s_total),1);
  ```
- Line 230: block, loc
  ```
  block_result_temp.minus_s_total = -block_result_temp.s_total;
  ```
- Line 231: block, loc
  ```
  block_result_temp.fringe = (block_result_temp.firmid<0);
  ```
- Line 232: block, loc
  ```
  block_result_temp.top3=zeros(length(block_result_temp.s_total),1);
  ```
- Line 235: block, loc
  ```
  block_result.year_check=(block_result.year~=year_vec(i));
  ```
- Line 236: block, loc
  ```
  block_result.sector_check=(block_result.secid~=j);
  ```
- Line 237: block, loc
  ```
  block_result = sortrows(block_result, {'year_check','sector_check','fringe','minus_s_total'});
  ```
- Line 238: block, loc
  ```
  block_result.top3(1:3) = 1;
  ```
- Line 239: block, loc
  ```
  block_result_temp.year_check=(block_result_temp.year~=year_vec(i));
  ```
- Line 240: block, loc
  ```
  block_result_temp.sector_check=(block_result_temp.secid~=j);
  ```
- Line 241: block, loc
  ```
  block_result_temp = sortrows(block_result_temp, {'year_check','sector_check','fringe','minus_s_total
  ```
- Line 242: block, loc
  ```
  block_result_temp.top3(1:3) = 1;
  ```
- Line 245: block, loc
  ```
  block_result = sortrows(block_result,{'year','secid','firmid'});
  ```
- Line 246: block, loc
  ```
  block_result_temp = sortrows(block_result_temp,{'year','secid','firmid'});
  ```
- Line 254: block, loc
  ```
  tau_l_top3_vec(i,j) = mean(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j
  ```
- Line 255: block, loc
  ```
  ./mean(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j & block_result.firm
  ```
- Line 256: block, loc
  ```
  tau_l_top3_vec_separate(i,j) = mean(block_result.tau_l(block_result.year==year_vec(i) & block_result
  ```
- Line 257: block, loc
  ```
  tau_l_others_vec_separate(i,j) = mean(block_result.tau_l(block_result.year==year_vec(i) & block_resu
  ```
- Line 258: block, loc
  ```
  s_l_top3_vec(i,j) = sum(block_result.s_l(block_result.year==year_vec(i) & block_result.secid==j & bl
  ```
- Line 259: block, loc
  ```
  s_l_top3_vec_base(i,j) = sum(block_result_temp.s_k(block_result_temp.year==year_vec(i) & block_resul
  ```
- Line 272: block, loc
  ```
  block_result.tau_l_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 273: block, loc
  ```
  = invprctile(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 274: block, loc
  ```
  block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 275: block, loc
  ```
  block_result.tau_k_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 276: block, loc
  ```
  = invprctile(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 277: block, loc
  ```
  block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 318: block, loc
  ```
  x_guess_cell{i} =  [block_result.s_y(block_result.year==year_vec(i));...
  ```
- Line 319: block, loc
  ```
  block_result.s_l(block_result.year==year_vec(i))/length(secid_full)...
  ```
- Line 329: block, loc
  ```
  [diff, A_year_next,x_guess_cell] = model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, b
  ```
- Line 344: block, loc
  ```
  model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,mark
  ```
- Line 389: block, loc
  ```
  result.A_rel = block_result.A / A_year_guess(1);
  ```
- Line 392: block, loc
  ```
  result.s_l = block_result.s_l;
  ```
- Line 393: block, loc
  ```
  result.s_k = block_result.s_k;
  ```
- Line 674: name
  ```
  DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(
  ```
- Line 675: name
  ```
  tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 676: name
  ```
  tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) re
  ```
- Line 677: name
  ```
  A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(re
  ```
- Line 717: son
  ```
  % comparison with older results. They are not executed.
  ```
- Line 830: name
  ```
  has_granular_warm_start = ~isempty(fieldnames(warm_granular));
  ```
- Line 836: lat
  ```
  strcmp(ME.identifier,'model_relative_residual:NonfiniteIterate')
  ```

**/replication-package/Replication_JPE/MATLAB/solve_full_model_part1.m**

- Line 4: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 22: name
  ```
  warm_file = @(name) fullfile(warm_start_dir,name);
  ```
- Line 56: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 64: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 65: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 90: lat
  ```
  % Calculate wedge and relative productivity
  ```
- Line 91: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block(mom, Par, markup,markdown);
  ```
- Line 92: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 100: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 101: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 106: block, loc
  ```
  lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
  ```
- Line 107: block, loc
  ```
  upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
  ```
- Line 108: block, loc
  ```
  block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 109: block, loc
  ```
  block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 111: block, loc
  ```
  lower_bound = prctile(block_result.tau_k(block_result.year==year), 1.5);
  ```
- Line 112: block, loc
  ```
  upper_bound = prctile(block_result.tau_k(block_result.year==year), 98.5);
  ```
- Line 113: block, loc
  ```
  block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 114: block, loc
  ```
  block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 120: block, loc
  ```
  if sum(isnan(block_result.DF))+sum(isnan(block_result.tau_l))+sum(isnan(block_result.tau_k))>0
  ```
- Line 127: block, loc
  ```
  block_result = sortrows(block_result, {'firmid', 'year'});  % Sort data by ID, then by year
  ```
- Line 128: block, loc
  ```
  unique_id = unique(block_result.firmid);  % Find all unique IDs
  ```
- Line 135: block, loc
  ```
  currentData = block_result(block_result.firmid == unique_id(i), :);
  ```
- Line 143: block, loc
  ```
  block_result.A = A_ma;
  ```
- Line 144: block, loc
  ```
  block_result.tau_l = tau_l_ma;
  ```
- Line 145: block, loc
  ```
  block_result.tau_k = tau_k_ma;
  ```
- Line 146: block, loc
  ```
  block_result.DF = DF_ma;
  ```
- Line 154: block, loc
  ```
  block_result.tau_l_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 155: block, loc
  ```
  = invprctile(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 156: block, loc
  ```
  block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 157: block, loc
  ```
  block_result.tau_k_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 158: block, loc
  ```
  = invprctile(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 159: block, loc
  ```
  block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 163: block, loc
  ```
  block_result = sortrows(block_result, {'year','secid','firmid'});  % Sort data by year, secid, and f
  ```
- Line 187: block, loc
  ```
  x_guess_cell{i} =  [block_result.s_y(block_result.year==year_vec(i));...
  ```
- Line 188: block, loc
  ```
  block_result.s_l(block_result.year==year_vec(i))/length(secid_full)...
  ```
- Line 202: block, loc
  ```
  [diff, A_year_next,x_guess_cell] = model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, b
  ```
- Line 216: block, loc
  ```
  model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,mark
  ```
- Line 320: name
  ```
  cache_file_names = {'warm_counterfactual_a.mat'; 'warm_counterfactual_DF.mat'; ...
  ```
- Line 323: name
  ```
  cache_files = cellfun(warm_file,cache_file_names,'UniformOutput',false);
  ```
- Line 324: name
  ```
  cache_variable_names = {'warm_counterfactual_a'; 'warm_counterfactual_DF'; ...
  ```
- Line 338: name
  ```
  cache_variable_name = cache_variable_names{counterfactual_idx};
  ```
- Line 339: name
  ```
  if isfield(cache_contents,cache_variable_name)
  ```
- Line 341: name
  ```
  cache_contents.(cache_variable_name);
  ```
- Line 343: name
  ```
  % Supports a/DF cache files saved under the earlier generic name.
  ```
- Line 420: name
  ```
  samsung_cache_file_names = {'warm_samsung_a.mat'; 'warm_samsung_DF.mat'; ...
  ```
- Line 422: name
  ```
  samsung_cache_files = cellfun(warm_file,samsung_cache_file_names,'UniformOutput',false);
  ```
- Line 435: name
  ```
  cache_variable_name = samsung_cache_variables{samsung_idx};
  ```
- Line 436: name
  ```
  if isfield(cache_contents,cache_variable_name)
  ```
- Line 437: name
  ```
  warm_samsung_all{samsung_idx} = cache_contents.(cache_variable_name);
  ```
- Line 492: name
  ```
  hyundai_cache_file_names = {'warm_hyundai_a.mat'; 'warm_hyundai_DF.mat'; ...
  ```
- Line 494: name
  ```
  hyundai_cache_files = cellfun(warm_file,hyundai_cache_file_names,'UniformOutput',false);
  ```
- Line 507: name
  ```
  cache_variable_name = hyundai_cache_variables{hyundai_idx};
  ```
- Line 508: name
  ```
  if isfield(cache_contents,cache_variable_name)
  ```
- Line 509: name
  ```
  warm_hyundai_all{hyundai_idx} = cache_contents.(cache_variable_name);
  ```
- Line 646: name
  ```
  'VariableNames',{'sale_gdp','firmid'});
  ```
- Line 715: name
  ```
  'VariableNames',{'delta_CR3','delta_real_income','delta_agg_productivity','delta_gdp','firmid'});
  ```

**/replication-package/Replication_JPE/MATLAB/solve_full_model_part2.m**

- Line 5: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 20: name
  ```
  warm_file = @(name) fullfile(warm_start_dir,name);
  ```
- Line 153: lat
  ```
  % Shock correlation with IO consideration
  ```
- Line 199: name
  ```
  balance2.Properties.VariableNames = {'secid','firmid','year','A_fj_cf','tau_k_cf','tau_l_cf','DF_cf'
  ```
- Line 207: name
  ```
  result_ip = renamevars(result_ip, {'secid_result','firmid_result','year_result'}, {'secid','firmid',
  ```
- Line 226: name
  ```
  balance2.Properties.VariableNames = {'secid','firmid','year','A_fj_cf','tau_k_cf','tau_l_cf','DF_cf'
  ```
- Line 234: name
  ```
  result_ip = renamevars(result_ip, {'secid_result','firmid_result','year_result'}, {'secid','firmid',
  ```
- Line 252: name
  ```
  balance2.Properties.VariableNames = {'secid','firmid','year','A_fj_cf','tau_k_cf','tau_l_cf','DF_cf'
  ```
- Line 260: name
  ```
  result_ip = renamevars(result_ip, {'secid_result','firmid_result','year_result'}, {'secid','firmid',
  ```

**/replication-package/Replication_JPE/MATLAB/solve_full_model_robustness.m**

- Line 4: name
  ```
  spec_name = char(spec);
  ```
- Line 5: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));
  ```
- Line 60: block, loc, name
  ```
  block_result = array2table(zeros(1,14), 'VariableNames',...
  ```
- Line 68: loc
  ```
  [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
  ```
- Line 69: loc
  ```
  firm_counts = accumarray(loc, 1);
  ```
- Line 94: lat
  ```
  % Calculate wedge and relative productivity
  ```
- Line 95: block, loc
  ```
  [to_append,exsh_check(i,j)] = compute_block(mom, Par, markup,markdown);
  ```
- Line 96: block, loc
  ```
  block_result =[block_result; to_append];
  ```
- Line 104: name
  ```
  'VariableNames', {'firmid', 'year','s_total','s_y','s_k','s_l', 'A','tau_l','tau_k', 'mu_y','mu_l','
  ```
- Line 105: block, loc
  ```
  block_result = [block_result; to_append];
  ```
- Line 109: block, loc
  ```
  lower_bound = prctile(block_result.tau_l(block_result.year==year), 1.5);
  ```
- Line 110: block, loc
  ```
  upper_bound = prctile(block_result.tau_l(block_result.year==year), 98.5);
  ```
- Line 111: block, loc
  ```
  block_result.tau_l(block_result.tau_l < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 112: block, loc
  ```
  block_result.tau_l(block_result.tau_l > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 114: block, loc
  ```
  lower_bound = prctile(block_result.tau_k(block_result.year==year), 1.5);
  ```
- Line 115: block, loc
  ```
  upper_bound = prctile(block_result.tau_k(block_result.year==year), 98.5);
  ```
- Line 116: block, loc
  ```
  block_result.tau_k(block_result.tau_k < lower_bound & block_result.year==year) = lower_bound;
  ```
- Line 117: block, loc
  ```
  block_result.tau_k(block_result.tau_k > upper_bound & block_result.year==year) = upper_bound;
  ```
- Line 121: block, loc
  ```
  % writetable(block_result,OUTPUT+'block_result.csv');
  ```
- Line 122: block, loc
  ```
  if sum(isnan(block_result.DF))+sum(isnan(block_result.tau_l))+sum(isnan(block_result.tau_k))>0
  ```
- Line 127: block, loc
  ```
  block_result = sortrows(block_result, {'firmid', 'year'});  % Sort data by ID, then by year
  ```
- Line 128: block, loc
  ```
  unique_id = unique(block_result.firmid);  % Find all unique IDs
  ```
- Line 135: block, loc
  ```
  currentData = block_result(block_result.firmid == unique_id(i), :);
  ```
- Line 143: block, loc
  ```
  block_result.A = A_ma;
  ```
- Line 144: block, loc
  ```
  block_result.tau_l = tau_l_ma;
  ```
- Line 145: block, loc
  ```
  block_result.tau_k = tau_k_ma;
  ```
- Line 146: block, loc
  ```
  block_result.DF = DF_ma;
  ```
- Line 152: block, loc
  ```
  block_result.tau_l_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 153: block, loc
  ```
  = invprctile(block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 154: block, loc
  ```
  block_result.tau_l(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 155: block, loc
  ```
  block_result.tau_k_pctile(block_result.year==year_vec(i) & block_result.secid==j) ...
  ```
- Line 156: block, loc
  ```
  = invprctile(block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j),...
  ```
- Line 157: block, loc
  ```
  block_result.tau_k(block_result.year==year_vec(i) & block_result.secid==j));
  ```
- Line 161: block, loc
  ```
  block_result = sortrows(block_result, {'year','secid','firmid'});  % Sort data by year, secid, and f
  ```
- Line 162: block, loc
  ```
  % writetable(block_result,OUTPUT+'block_result.csv');
  ```
- Line 188: block, loc
  ```
  x_guess_cell{i} =  [block_result.s_y(block_result.year==year_vec(i));...
  ```
- Line 189: block, loc
  ```
  block_result.s_l(block_result.year==year_vec(i))/length(secid_full)...
  ```
- Line 203: block, loc
  ```
  [diff, A_year_next,x_guess_cell] = model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, b
  ```
- Line 217: block, loc
  ```
  model_extract_shock(A_year_guess, x_guess_cell, Par, mom, data, block_result, est_result,markup,mark
  ```
- Line 264: name
  ```
  cache_file = fullfile(warm_cache_dir,[spec_name '_extract.mat']);
  ```
- Line 296: name
  ```
  cache_file = fullfile(warm_cache_dir,[spec_name '_baseline.mat']);
  ```
- Line 335: name
  ```
  cache_file = fullfile(warm_cache_dir,[spec_name '_granular_a.mat']);
  ```
- Line 360: name
  ```
  cache_file = fullfile(warm_cache_dir,[spec_name '_granular_all.mat']);
  ```
- Line 376: name
  ```
  save(fullfile(result_dir,['result_robust_' spec_name '.mat']),'T_robust','-v7.3')
  ```

**/replication-package/Replication_JPE/MATLAB/wmean.m**

- Line 6: lon
  ```
  %   WMEAN(X,W) is the weighted mean value of the elements along the first
  ```
- Line 12: lon
  ```
  %   WMEAN(X,W,DIM) takes the weighted mean along the dimension DIM of X.
  ```

**/replication-package/Replication_JPE/MATLAB_PROD_FUNC/DKL_MARKUP.m**

- Line 4: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
  ```
- Line 38: name
  ```
  filename = 'OUTPUT/DLcoefs.xlsx';
  ```
- Line 39: name
  ```
  sheetname = 'Baseline';
  ```
- Line 40: name
  ```
  writematrix(result, filename, 'Sheet', sheetname);
  ```
- Line 75: name
  ```
  filename = 'OUTPUT/DLcoefs.xlsx';
  ```
- Line 76: name
  ```
  sheetname = num2str('Rolling', num2str(roly));
  ```
- Line 77: name
  ```
  writematrix(resultrolling, filename, 'Sheet', sheetname);
  ```

**/replication-package/Replication_JPE/MATLAB_PROD_FUNC/PROD_FUNC_BW_MARKUP.m**

- Line 4: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
  ```
- Line 196: name
  ```
  filename = 'INPUT/sec_BWpf_results_mu_x.xlsx';
  ```
- Line 197: name
  ```
  vnames = {'sigma' 'gl' 'gk' 'gm' 'g' 'bl' 'bk' 'bm' 'b' 'secid'};
  ```
- Line 198: name
  ```
  T = array2table(result,'VariableNames',vnames);
  ```
- Line 199: name
  ```
  sheetname = strcat('sec',num2str(jjj),'est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0),
  ```
- Line 200: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 227: block, loc
  ```
  % Generate bootstrap sample for each b: Block bootstrap (Pick IDs)
  ```
- Line 333: name
  ```
  filename = 'INPUT/BS_sec_BWpf_results_mu_x.xlsx';
  ```
- Line 334: name
  ```
  vnames = {'sigma' 'se_gl' 'se_gk' 'se_gm' 'se_g' 'se_bl' 'se_bk' 'se_bm' 'se_b' 'secid'};
  ```
- Line 335: name
  ```
  T = array2table(se_result,'VariableNames',vnames);
  ```
- Line 336: name
  ```
  sheetname = strcat('sec', num2str(jjj),'se_est', num2str(est), 's',num2str(sigma0), 'r', num2str(rho
  ```
- Line 337: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 340: name
  ```
  filename = 'INPUT/BS_sec_BWpf_results_mu_x.xlsx';
  ```
- Line 341: name
  ```
  vnames = {'sigma' 'p_gl' 'p_gk' 'p_gm' 'p_g' 'p_bl' 'p_bk' 'p_bm' 'p_b' 'secid'};
  ```
- Line 342: name
  ```
  T = array2table(pval_result,'VariableNames',vnames);
  ```
- Line 343: name
  ```
  sheetname = strcat('sec', num2str(jjj),'pval_est',num2str(est),'s',num2str(sigma0), 'r', num2str(rho
  ```
- Line 344: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 370: name
  ```
  filename = 'INPUT/BWpf_results_mu_x.xlsx';
  ```
- Line 371: name
  ```
  vnames = {'sigma' 'gl' 'gk' 'gm' 'g' 'bl' 'bk' 'bm' 'b' 'secid'};
  ```
- Line 372: name
  ```
  T = array2table(result,'VariableNames',vnames);
  ```
- Line 373: name
  ```
  sheetname = strcat('est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0)
  ```
- Line 374: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 401: name
  ```
  filename = 'INPUT/BS_BWpf_results_mu_x.xlsx';
  ```
- Line 402: name
  ```
  vnames = {'sigma' 'se_gl' 'se_gk' 'se_gm' 'se_g' 'se_bl' 'se_bk' 'se_bm' 'se_b' 'secid'};
  ```
- Line 403: name
  ```
  T = array2table(se_result,'VariableNames',vnames);
  ```
- Line 404: name
  ```
  sheetname = strcat('se_est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(et
  ```
- Line 405: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 408: name
  ```
  filename = 'INPUT/BS_BWpf_results_mu_x.xlsx';
  ```
- Line 409: name
  ```
  vnames = {'sigma' 'p_gl' 'p_gk' 'p_gm' 'p_g' 'p_bl' 'p_bk' 'p_bm' 'p_b' 'secid'};
  ```
- Line 410: name
  ```
  T = array2table(pval_result,'VariableNames',vnames);
  ```
- Line 411: name
  ```
  sheetname = strcat('pval_est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(
  ```
- Line 412: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```

**/replication-package/Replication_JPE/MATLAB_PROD_FUNC/PROD_FUNC_MARKUP.m**

- Line 4: name
  ```
  matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
  ```
- Line 41: city
  ```
  % eta0: labor supply elasticity
  ```
- Line 216: name
  ```
  filename = 'INPUT/sec_pf_results_mu_x.xlsx';
  ```
- Line 217: name
  ```
  vnames = {'sigma' 'gl' 'gk' 'gm' 'g' 'bl' 'bk' 'bm' 'b' 'secid'};
  ```
- Line 218: name
  ```
  T = array2table(result,'VariableNames',vnames);
  ```
- Line 219: name
  ```
  sheetname = strcat('sec',num2str(jjj),'est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0),
  ```
- Line 220: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 245: block, loc
  ```
  % Generate bootstrap sample for each b: Block bootstrap (Pick IDs)
  ```
- Line 352: name
  ```
  filename = 'INPUT/BS_sec_pf_results_mu_x.xlsx';
  ```
- Line 353: name
  ```
  vnames = {'sigma' 'se_gl' 'se_gk' 'se_gm' 'se_g' 'se_bl' 'se_bk' 'se_bm' 'se_b' 'secid'};
  ```
- Line 354: name
  ```
  T = array2table(se_result,'VariableNames',vnames);
  ```
- Line 355: name
  ```
  sheetname = strcat('sec', num2str(jjj),'se_est', num2str(est), 's',num2str(sigma0), 'r', num2str(rho
  ```
- Line 356: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 359: name
  ```
  filename = 'INPUT/BS_sec_pf_results_mu_x.xlsx';
  ```
- Line 360: name
  ```
  vnames = {'sigma' 'p_gl' 'p_gk' 'p_gm' 'p_g' 'p_bl' 'p_bk' 'p_bm' 'p_b' 'secid'};
  ```
- Line 361: name
  ```
  T = array2table(pval_result,'VariableNames',vnames);
  ```
- Line 362: name
  ```
  sheetname = strcat('sec', num2str(jjj),'pval_est',num2str(est),'s',num2str(sigma0), 'r', num2str(rho
  ```
- Line 363: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 388: name
  ```
  filename = 'INPUT/pf_results_mu_x.xlsx';
  ```
- Line 389: name
  ```
  vnames = {'sigma' 'gl' 'gk' 'gm' 'g' 'bl' 'bk' 'bm' 'b' 'secid'};
  ```
- Line 390: name
  ```
  T = array2table(result,'VariableNames',vnames);
  ```
- Line 391: name
  ```
  sheetname = strcat('est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(eta0)
  ```
- Line 392: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 419: name
  ```
  filename = 'INPUT/BS_pf_results_mu_x.xlsx';
  ```
- Line 420: name
  ```
  vnames = {'sigma' 'se_gl' 'se_gk' 'se_gm' 'se_g' 'se_bl' 'se_bk' 'se_bm' 'se_b' 'secid'};
  ```
- Line 421: name
  ```
  T = array2table(se_result,'VariableNames',vnames);
  ```
- Line 422: name
  ```
  sheetname = strcat('se_est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(et
  ```
- Line 423: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```
- Line 426: name
  ```
  filename = 'INPUT/BS_pf_results_mu_x.xlsx';
  ```
- Line 427: name
  ```
  vnames = {'sigma' 'p_gl' 'p_gk' 'p_gm' 'p_g' 'p_bl' 'p_bk' 'p_bm' 'p_b' 'secid'};
  ```
- Line 428: name
  ```
  T = array2table(pval_result,'VariableNames',vnames);
  ```
- Line 429: name
  ```
  sheetname = strcat('pval_est', num2str(est), 's', num2str(sigma0), 'r', num2str(rho0), 'e', num2str(
  ```
- Line 430: name
  ```
  writetable(T, filename, 'Sheet', sheetname);
  ```

**/replication-package/Replication_JPE/STATA/BRIBERY.do**

- Line 1: loc
  ```
  local before  = 4                         // event window = [-`before', +`after']
  ```
- Line 2: loc
  ```
  local after   = 6
  ```
- Line 3: loc
  ```
  local ref     = -1                       // Reference year
  ```
- Line 61: loc
  ```
  local panel_min = r(min)
  ```
- Line 62: loc
  ```
  local panel_max = r(max)
  ```
- Line 79: loc
  ```
  local _ghmin = r(min)
  ```
- Line 80: loc
  ```
  local _nyr   = 1988 - `_ghmin'
  ```
- Line 116: loc
  ```
  levelsof gcode, local(allchun)
  ```
- Line 117: loc
  ```
  foreach g of local allchun {
  ```
- Line 119: loc
  ```
  local ccoh`g' = r(mean)
  ```
- Line 125: loc
  ```
  local firstc = 1
  ```
- Line 127: loc
  ```
  foreach g of local allchun {
  ```
- Line 128: loc
  ```
  local cg = `ccoh`g''
  ```
- Line 172: loc
  ```
  local firstc = 0
  ```
- Line 187: name
  ```
  rename gcode hz_gcode
  ```
- Line 203: name
  ```
  rename gcode roh_gcode
  ```
- Line 233: loc
  ```
  levelsof compg if c_treated==1, local(tgroups)
  ```
- Line 237: loc
  ```
  local _keep
  ```
- Line 238: loc
  ```
  foreach g of local tgroups {
  ```
- Line 239: loc
  ```
  if `g' != 28  local _keep `_keep' `g'
  ```
- Line 241: loc
  ```
  local tgroups `_keep'
  ```
- Line 243: loc
  ```
  foreach g of local tgroups {
  ```
- Line 244: loc
  ```
  local coh_`g' = `ccoh`g''
  ```
- Line 250: loc
  ```
  local outlist
  ```
- Line 252: loc
  ```
  local first = 1
  ```
- Line 253: loc
  ```
  foreach g of local tgroups {
  ```
- Line 254: loc
  ```
  local cg = `coh_`g''
  ```
- Line 286: loc
  ```
  local first = 0
  ```
- Line 293: loc
  ```
  local _npre = (-1) - (-5) + 1
  ```
- Line 311: lat
  ```
  * Relative-time dummies
  ```
- Line 312: loc
  ```
  local relvars
  ```
- Line 316: loc
  ```
  local relvars `relvars' g_m`k'
  ```
- Line 322: loc
  ```
  local relvars `relvars' g_f`k'
  ```
- Line 334: loc
  ```
  local _hv = cond("`y'"=="ln_a_fj","fsize_dom", cond("`y'"=="ln_tau_l","fsize_l", cond("`y'"=="ln_tau
  ```
- Line 337: loc
  ```
  local wgt "[aw=wt]"
  ```
- Line 339: loc
  ```
  local absfe stack#firmid stack#year secid#year
  ```
- Line 340: loc
  ```
  local cl gclus
  ```
- Line 351: loc
  ```
  local _df = e(df_r)
  ```
- Line 352: loc
  ```
  if missing(`_df')  local _df = e(N_clust) - 1
  ```
- Line 353: loc
  ```
  local _z95 = invttail(`_df', .025)
  ```
- Line 354: loc
  ```
  local _z90 = invttail(`_df', .05)
  ```
- Line 355: loc
  ```
  foreach c of local relvars {
  ```
- Line 356: loc
  ```
  local et = .
  ```
- Line 357: loc
  ```
  if regexm("`c'","^g_m([0-9]+)$")  local et = -1*real(regexs(1))
  ```
- Line 358: loc
  ```
  if regexm("`c'","^g_f([0-9]+)$")  local et =    real(regexs(1))
  ```
- Line 359: loc
  ```
  local jc = colnumb(_bb, "`c'")
  ```
- Line 361: loc
  ```
  local b  = _bb[1,`jc']
  ```
- Line 362: loc
  ```
  local se = sqrt(_VV[`jc',`jc'])
  ```
- Line 369: loc, name
  ```
  if "`y'" == "ln_a_fj" local figname FIGUREB11_A
  ```
- Line 370: loc, name
  ```
  if "`y'" == "ln_tau_k" local figname FIGUREB11_B
  ```
- Line 371: loc, name
  ```
  if "`y'" == "ln_tau_l" local figname FIGUREB11_C
  ```
- Line 372: loc, name
  ```
  if "`y'" == "ln_df_tilde" local figname FIGUREB11_D
  ```
- Line 386: name
  ```
  graph export "FIGURE/`figname'.pdf", replace
  ```
- Line 399: name
  ```
  rename g_code3 gcode_key
  ```
- Line 404: name
  ```
  tempfile gi_names
  ```
- Line 405: name
  ```
  save `gi_names'
  ```
- Line 420: name
  ```
  save `gi_names', replace
  ```
- Line 434: loc
  ```
  local Ntreat = r(sum)
  ```
- Line 435: loc
  ```
  local Ntg    = _N
  ```
- Line 446: lon
  ```
  replace group = "(non-group standalone firm)" if _nongrp
  ```
- Line 455: loc
  ```
  local BD = r(mean)
  ```
- Line 465: name
  ```
  rename year_start year
  ```
- Line 469: name
  ```
  rename g_code3 gcode_key
  ```
- Line 502: lat
  ```
  file write _cb "\textbf{(a) Treated groups} (event: first Chun-era bribe/donation) & \textbf{(b) Con
  ```
- Line 511: loc
  ```
  local _btot = string(r(sum), "%12.0fc")
  ```
- Line 517: loc
  ```
  local _ntr = _N
  ```
- Line 519: loc
  ```
  local g = group[`i']
  ```
- Line 520: loc
  ```
  local g : subinstr local g "&" "\&", all
  ```
- Line 521: loc
  ```
  local ch = string(cohort[`i'], "%4.0f")
  ```
- Line 522: loc
  ```
  local nf = n_treat[`i']
  ```
- Line 523: loc
  ```
  local bm = cond(missing(bribe_musd[`i']), "---", string(bribe_musd[`i'], "%12.1fc"))
  ```
- Line 524: loc
  ```
  local rt = cond(missing(bs_pct[`i']), "---", string(bs_pct[`i'], "%5.2f"))
  ```
- Line 539: loc
  ```
  local _ncc = _N
  ```
- Line 541: loc
  ```
  local _ncf = r(sum)
  ```
- Line 543: loc
  ```
  local _ctot = string(r(sum), "%12.0fc")
  ```
- Line 548: loc
  ```
  local g = group[`i']
  ```
- Line 549: loc
  ```
  local g : subinstr local g "&" "\&", all
  ```
- Line 550: loc
  ```
  local nf = n_ctrl_firms[`i']
  ```
- Line 551: loc
  ```
  local bm = cond(missing(bribe_musd[`i']), "---", string(bribe_musd[`i'], "%12.1fc"))
  ```
- Line 552: loc
  ```
  local rt = cond(missing(bs_pct[`i']), "---", string(bs_pct[`i'], "%5.2f"))
  ```
- Line 577: loc
  ```
  foreach g of local allchun {
  ```

**/replication-package/Replication_JPE/STATA/CONCENTRATION.do**

- Line 7: loc
  ```
  local color orange_red%90
  ```
- Line 8: loc
  ```
  local lwidth 0.9
  ```
- Line 77: name
  ```
  rename GO manuGO
  ```
- Line 84: name
  ```
  rename (GO export) (IOmanuGO IOmanuEX)
  ```
- Line 135: lat
  ```
  * Calculate CR*
  ```
- Line 144: loc
  ```
  local crlist 1 3 5 10
  ```
- Line 147: loc
  ```
  local crlist 3
  ```
- Line 152: loc, name
  ```
  local figname FIGURE1_B
  ```
- Line 155: loc, name
  ```
  local figname FIGUREB3_A
  ```
- Line 158: loc, name
  ```
  local figname FIGUREB3_B
  ```
- Line 161: loc, name
  ```
  local figname FIGUREB3_C
  ```
- Line 164: loc, name
  ```
  local figname FIGUREB2_A
  ```
- Line 167: loc, name
  ```
  local figname FIGUREB2_B
  ```
- Line 182: name
  ```
  graph export "FIGURE/`figname'.pdf", as(pdf) replace
  ```
- Line 217: lat
  ```
  * Calculate CR*
  ```
- Line 227: loc, name
  ```
  local figname FIGUREB4_A
  ```
- Line 230: loc, name
  ```
  local figname FIGUREB4_B
  ```
- Line 244: name
  ```
  graph export "FIGURE/`figname'.pdf", as(pdf) replace
  ```
- Line 271: lat
  ```
  * Calculate HHI
  ```

**/replication-package/Replication_JPE/STATA/DATA_CLEANING.do**

- Line 6: name
  ```
  rename EUKLEMScode sec
  ```
- Line 9: name
  ```
  rename K `var'
  ```
- Line 17: name
  ```
  rename (vkw qkw) (K rK)
  ```
- Line 22: name
  ```
  rename EUKLEMScode sec
  ```
- Line 24: name
  ```
  rename YL `var'
  ```
- Line 30: name
  ```
  rename EUKLEMScode sec
  ```
- Line 32: name
  ```
  rename YL rGO
  ```
- Line 51: name
  ```
  rename (EMP H_EMP) (L Lhour)
  ```

**/replication-package/Replication_JPE/STATA/DISTRIBUTED_LAG.do**

- Line 2: loc
  ```
  local qlist      8
  ```
- Line 4: loc
  ```
  local chun_lo  = 1980
  ```
- Line 5: loc
  ```
  local chun_hi  = 1987
  ```
- Line 6: loc
  ```
  local roh_lo   = 1988
  ```
- Line 7: loc
  ```
  local roh_hi   = 1993
  ```
- Line 8: loc
  ```
  local est_lo   = 1970                      // standardization / estimation window (data starts 1972 
  ```
- Line 9: loc
  ```
  local est_hi   = 1995
  ```
- Line 139: name
  ```
  rename g_code3 treatgrp
  ```
- Line 149: name
  ```
  rename yC year
  ```
- Line 155: name
  ```
  rename yR year
  ```
- Line 173: lon
  ```
  egen long fm_treatgrp = mode(treatgrp), by(firmid) maxmode
  ```
- Line 175: lon
  ```
  egen long fm_modal93 = mode(g93), by(firmid) maxmode
  ```
- Line 176: lon
  ```
  gen long grpclu = .
  ```
- Line 183: loc
  ```
  local X cum_tech ht_loan ht_kotnum conn
  ```
- Line 189: loc
  ```
  local qmax = `q'
  ```
- Line 190: loc
  ```
  foreach qq of local qlist {
  ```
- Line 191: loc
  ```
  if `qq' > `qmax'  local qmax = `qq'
  ```
- Line 207: loc
  ```
  local rlab1 "Technology Adoption"
  ```
- Line 208: loc
  ```
  local rlab2 "Ihs Credit"
  ```
- Line 209: loc
  ```
  local rlab3 "Ihs Trade Fair Participation"
  ```
- Line 210: loc
  ```
  local rlab4 "Bribing (ever-affiliated dummy)"
  ```
- Line 211: loc
  ```
  local firstsheet = 1
  ```
- Line 213: loc
  ```
  foreach qq of local qlist {
  ```
- Line 222: loc
  ```
  local Xlag
  ```
- Line 225: loc
  ```
  local Xlag `Xlag' L`l'`v'
  ```
- Line 229: loc
  ```
  local col = 0
  ```
- Line 231: loc
  ```
  local col = `col' + 1
  ```
- Line 237: loc
  ```
  local rr = 0
  ```
- Line 239: loc
  ```
  local rr = `rr' + 1
  ```
- Line 240: loc
  ```
  local ex (_b[L0`x']
  ```
- Line 242: loc
  ```
  local ex `ex' + _b[L`l'`x']
  ```
- Line 244: loc
  ```
  local ex `ex')
  ```
- Line 256: loc, name
  ```
  local shname "cum_b0_b`qq'_firm"
  ```
- Line 257: loc
  ```
  local cldesc "cluster(firmid)"
  ```
- Line 260: name
  ```
  qui: putexcel set "TABLE/TABLE5.xlsx", sheet("`shname'") replace
  ```
- Line 261: loc
  ```
  local firstsheet = 0
  ```
- Line 264: name
  ```
  qui: putexcel set "TABLE/TABLE5.xlsx", sheet("`shname'", replace) modify
  ```
- Line 268: loc
  ```
  local row = 3
  ```
- Line 271: loc
  ```
  local row = `row' + 3
  ```
- Line 275: loc
  ```
  local col = 0
  ```
- Line 277: loc
  ```
  local col = `col' + 1
  ```
- Line 278: loc
  ```
  local L : word `col' of B C D E
  ```
- Line 280: loc
  ```
  local row = 3
  ```
- Line 286: loc
  ```
  local row = `row' + 3
  ```
- Line 299: loc
  ```
  local cl firmid
  ```
- Line 300: loc
  ```
  local FE firmid sec_year_id
  ```
- Line 301: loc
  ```
  local X cum_tech ht_loan ht_kotnum conn
  ```
- Line 315: loc
  ```
  local Xlag
  ```
- Line 318: loc
  ```
  local Xlag `Xlag' L`l'`v'
  ```
- Line 382: loc
  ```
  qui: local X cum_tech ht_loan ht_kotnum conn
  ```
- Line 387: loc
  ```
  local midy = 1979
  ```
- Line 388: loc
  ```
  local iniy = 1972
  ```
- Line 389: loc
  ```
  local breaky =`midy' +`q' + 1
  ```
- Line 390: loc
  ```
  local growthy = `breaky' + 1
  ```
- Line 432: loc
  ```
  local xl_a cum_tech ht_kotnum
  ```
- Line 433: loc
  ```
  local xl_k ht_loan
  ```
- Line 434: loc
  ```
  local xl_l conn
  ```
- Line 435: loc
  ```
  local fx "INPUT/shock_DL_polcon.xlsx"
  ```
- Line 438: loc
  ```
  local xl_a cum_tech ht_kotnum
  ```
- Line 439: loc
  ```
  local xl_k ht_loan
  ```
- Line 440: loc
  ```
  local xl_l
  ```
- Line 441: loc
  ```
  local fx "INPUT/shock_DL_polcon_ind.xlsx"
  ```
- Line 444: loc
  ```
  local xl_a
  ```
- Line 445: loc
  ```
  local xl_k
  ```
- Line 446: loc
  ```
  local xl_l conn
  ```
- Line 447: loc
  ```
  local fx "INPUT/shock_DL_polcon_bribe.xlsx"
  ```
- Line 457: loc
  ```
  local xlist `xl_a'
  ```
- Line 460: loc
  ```
  local xlist `xl_k'
  ```
- Line 463: loc
  ```
  local xlist `xl_l'
  ```
- Line 497: name
  ```
  rename (ca_fj ctau_k ctau_l cdf) (a_fj tau_k tau_l df)
  ```
- Line 541: loc
  ```
  qui: local X cum_tech ht_loan ht_kotnum conn
  ```
- Line 546: loc
  ```
  local midy = 1979
  ```
- Line 547: loc
  ```
  local iniy = 1972
  ```
- Line 548: loc
  ```
  local breaky =`midy' +`q' + 1
  ```
- Line 549: loc
  ```
  local growthy = `breaky' + 1
  ```
- Line 591: loc
  ```
  local xl_a cum_tech ht_kotnum
  ```
- Line 592: loc
  ```
  local xl_k ht_loan
  ```
- Line 593: loc
  ```
  local xl_l conn
  ```
- Line 594: loc
  ```
  local fx "INPUT/shock_DL_polcon_t3.xlsx"
  ```
- Line 597: loc
  ```
  local xl_a cum_tech ht_kotnum
  ```
- Line 598: loc
  ```
  local xl_k ht_loan
  ```
- Line 599: loc
  ```
  local xl_l
  ```
- Line 600: loc
  ```
  local fx "INPUT/shock_DL_polcon_ind_t3.xlsx"
  ```
- Line 603: loc
  ```
  local xl_a
  ```
- Line 604: loc
  ```
  local xl_k
  ```
- Line 605: loc
  ```
  local xl_l conn
  ```
- Line 606: loc
  ```
  local fx "INPUT/shock_DL_polcon_bribe_t3.xlsx"
  ```
- Line 616: loc
  ```
  local xlist `xl_a'
  ```
- Line 619: loc
  ```
  local xlist `xl_k'
  ```
- Line 622: loc
  ```
  local xlist `xl_l'
  ```
- Line 655: name
  ```
  rename (ca_fj ctau_k ctau_l cdf) (a_fj tau_k tau_l df)
  ```

**/replication-package/Replication_JPE/STATA/ESTIMATION_PROD_FUNC.do**

- Line 80: lat
  ```
  ** Input deflators are constructed based on the IO coefficients and PPIs
  ```
- Line 87: name
  ```
  qui: rename `od'sec sec
  ```
- Line 89: name
  ```
  qui: rename sec `od'sec
  ```
- Line 93: name
  ```
  qui: rename `od'sec sec
  ```
- Line 95: name
  ```
  qui: rename sec `od'sec
  ```
- Line 97: name
  ```
  rename osec sec
  ```
- Line 99: name
  ```
  rename sec osec
  ```
- Line 104: name
  ```
  rename dsec sec
  ```
- Line 106: name
  ```
  rename PPI inPPI
  ```
- Line 133: name
  ```
  rename (dsec value) (sec `var')
  ```
- Line 137: name
  ```
  rename (osec value) (sec `var')
  ```
- Line 155: name
  ```
  rename export EX
  ```
- Line 172: name
  ```
  rename value `var'
  ```
- Line 174: name
  ```
  rename osec sec
  ```
- Line 199: loc
  ```
  qui: local min_year = 1985
  ```
- Line 200: loc
  ```
  qui: local max_year = 2011
  ```
- Line 276: loc
  ```
  qui: levelsof secid, local(sec_list)
  ```
- Line 278: loc
  ```
  foreach j of local sec_list {
  ```
- Line 392: name
  ```
  rename (A B C) (secid vcoef kcoef)
  ```
- Line 396: name
  ```
  rename (A B C D) (secid year vcoef_rolling kcoef_rolling)
  ```
- Line 439: loc
  ```
  local poly v1 v2 v3 k1 k2 k3 v1k1 v1k2 v2k1
  ```
- Line 443: loc
  ```
  levelsof secid, local(seclist)
  ```
- Line 444: loc
  ```
  foreach j of local seclist {
  ```
- Line 460: loc
  ```
  local lp 2.5
  ```
- Line 461: loc
  ```
  local up 97.5
  ```

**/replication-package/Replication_JPE/STATA/FIGURE6_scatter_plot_villain.do**

- Line 25: name
  ```
  gen label_cname=""
  ```
- Line 26: name
  ```
  replace label_cname = "LG Chem." if	cname=="주식회
  ```
- Line 27: name
  ```
  replace label_cname = "POSCO" if cname=="포항종
  ```

**/replication-package/Replication_JPE/STATA/HCI_Drive.do**

- Line 15: loc
  ```
  local start_pol = 1973
  ```
- Line 16: loc
  ```
  local end_pol = 1979
  ```
- Line 17: loc
  ```
  local start_imf = 1997
  ```
- Line 52: loc
  ```
  local excel_row = 2
  ```
- Line 54: loc
  ```
  local u = 22
  ```
- Line 55: loc
  ```
  local syear = 1972
  ```
- Line 89: loc
  ```
  local Xhigh high_ltreated1
  ```
- Line 90: loc
  ```
  local Xlow low_ltreated1
  ```
- Line 93: loc
  ```
  local Xhigh `Xhigh' high_ftreated`f'
  ```
- Line 94: loc
  ```
  local Xlow `Xlow' low_ftreated`f'
  ```
- Line 105: loc
  ```
  local cl region_id
  ```
- Line 106: loc
  ```
  local fe reg_sec_id secid##year region_id##year c.ln_inisale#i.year
  ```
- Line 115: loc
  ```
  qui: local excel_row = `excel_row' + 1
  ```
- Line 128: loc
  ```
  local u = 22
  ```
- Line 129: loc
  ```
  local syear = 1972
  ```
- Line 131: loc
  ```
  local specs
  ```
- Line 132: loc
  ```
  local pos = 1
  ```
- Line 165: loc
  ```
  local Xhigh high_ltreated1
  ```
- Line 166: loc
  ```
  local Xlow low_ltreated1
  ```
- Line 169: loc
  ```
  local Xhigh `Xhigh' high_ftreated`f'
  ```
- Line 170: loc
  ```
  local Xlow `Xlow' low_ftreated`f'
  ```
- Line 183: loc
  ```
  local fe reg_sec_id secid##year region_id##year
  ```
- Line 184: loc
  ```
  local cl region_id
  ```
- Line 187: loc
  ```
  local fe `fe' c.ln_inisale#i.year
  ```
- Line 193: loc
  ```
  local high_color #377EB8
  ```
- Line 194: loc
  ```
  local low_color #E41A1C
  ```
- Line 196: loc
  ```
  local xlab 1 "-1"
  ```
- Line 198: loc
  ```
  local j = `i' - 2
  ```
- Line 199: loc
  ```
  local xlab `xlab' `i' "`j'"
  ```
- Line 219: name
  ```
  name(g_high, replace)
  ```
- Line 238: name
  ```
  name(g_low, replace)
  ```
- Line 244: lat
  ```
  b1title("Years relative to the HCI Drive")
  ```
- Line 246: loc, name
  ```
  if "`dep'" == "ln_a_fj"	 local figname FIGUREB10_A
  ```
- Line 247: loc, name
  ```
  if "`dep'" == "ln_tau_k" 	local figname FIGUREB10_B
  ```
- Line 248: loc, name
  ```
  if "`dep'" == "ln_tau_l" 	local figname FIGUREB10_C
  ```
- Line 249: loc, name
  ```
  if "`dep'" == "ln_df_tilde" 	local figname FIGUREB10_D
  ```
- Line 251: name
  ```
  qui: graph export "FIGURE/`figname'.pdf", as(pdf) replace
  ```

**/replication-package/Replication_JPE/STATA/Merger.do**

- Line 5: name
  ```
  keep old_kyel_k g_code4 g_code3 year kis firm_oldname
  ```
- Line 6: name
  ```
  rename (old_kyel_k firm_oldname) (gname cname)
  ```
- Line 22: name
  ```
  keep kis year g_code3 gname
  ```
- Line 29: name
  ```
  keep g_code3 gname
  ```
- Line 37: name
  ```
  keep g_code3 gname sec
  ```
- Line 75: name
  ```
  rename ksic ksic_list
  ```
- Line 90: name
  ```
  rename (Code_All Code_AorT firm_name_k type) (merger_id merger_a cname merger_type)
  ```
- Line 92: name
  ```
  rename year merger_year
  ```
- Line 170: name
  ```
  rename merger_year year
  ```
- Line 172: name
  ```
  rename year merger_year
  ```
- Line 178: name
  ```
  foreach name in 호텔 증권 은행 보험 증권 
  ```
- Line 179: name
  ```
  drop if regexm(cname, "`name'") & missing(manu)
  ```
- Line 181: name
  ```
  keep kis cname merger_status merger_id merger_type merger_year sec* g_code3* ksic*
  ```
- Line 196: name
  ```
  keep kis cname merger_id merger_year
  ```
- Line 197: name
  ```
  rename (kis cname) (kis_A cname_A)
  ```
- Line 202: name
  ```
  keep kis cname merger_id merger_type merger_year
  ```
- Line 203: name
  ```
  rename (cname kis) (cname_T kis_T)
  ```
- Line 205: name
  ```
  keep merger* cname_* kis_*
  ```
- Line 268: name
  ```
  rename merger_year year
  ```
- Line 274: name
  ```
  rename secT sec
  ```
- Line 287: name
  ```
  rename merger_year year
  ```
- Line 351: name
  ```
  rename merger_year ctrl_merger_year
  ```
- Line 357: loc
  ```
  local dmatchvarlist ln_sale ln_emp ln_fasset ht_export d3ln_sale d3ln_emp d3ln_fasset d3ht_export
  ```
- Line 358: loc
  ```
  local ematchvarlist sec year
  ```
- Line 407: name
  ```
  rename (panelid kis) (panelid_w kis_w)
  ```
- Line 412: name
  ```
  rename (`var' ln_`var' ht_`var' dum_`var') (`var'_w ln_`var'_w ht_`var'_w dum_`var'_w)
  ```
- Line 418: name
  ```
  rename (d`l'ln_`var' d`l'ht_`var') (d`l'ln_`var'_w d`l'ht_`var'_w)
  ```
- Line 481: name
  ```
  rename kis_w kis
  ```
- Line 540: loc
  ```
  local dlist ln_a_fj // ln_tau_l ln_tau_k ln_df_tilde
  ```
- Line 541: loc
  ```
  local specs
  ```
- Line 557: loc
  ```
  local before 5
  ```
- Line 558: loc
  ```
  local after 7
  ```
- Line 560: loc
  ```
  local normal before1
  ```
- Line 565: loc
  ```
  local treat
  ```
- Line 567: loc
  ```
  local treat `treat' treat_before`iii'
  ```
- Line 570: loc
  ```
  local treat `treat' treat_after`iii'
  ```
- Line 575: loc
  ```
  local cluster treat_id panelid
  ```
- Line 576: loc
  ```
  local FE match_yearFE mpanelid
  ```

**/replication-package/Replication_JPE/STATA/PF_EST_RESULT.do**

- Line 5: loc
  ```
  local sheet est4s5r2e4p1IV5
  ```
- Line 11: loc
  ```
  local sheet est4s5r2e4p1IV5
  ```
- Line 23: loc
  ```
  local npanel 5
  ```
- Line 26: loc
  ```
  local sheet  est4s5r2e4p1IV5
  ```
- Line 27: loc
  ```
  local ptitle `"Panel A. Baseline Estimates"'
  ```
- Line 30: loc
  ```
  local sheet  est2s5r2e4p1IV5
  ```
- Line 31: loc
  ```
  local ptitle `"Panel B. Only Non-exporters"'
  ```
- Line 34: loc
  ```
  local sheet  est5s5r2e4p1IV5
  ```
- Line 35: loc
  ```
  local ptitle `"Panel C. Only Exporters"'
  ```
- Line 38: loc
  ```
  local sheet  est4s5r2e4p1IV3
  ```
- Line 39: loc
  ```
  local ptitle `"Panel D. \(\mathbf{Z}_{fjt} = [\ln k_{fj,t-1}, \ln l_{fj,t-1}, 1, \ln a_{fj,t-1}]'\)"
  ```
- Line 42: loc
  ```
  local sheet  est4s5r2e4p3IV5
  ```
- Line 43: loc
  ```
  local ptitle `"Panel E. \(\ln a_{fjt} = \sum_{p=0}^{3} \iota_{p} (\ln a_{fj,t-1})^{p}\)"'
  ```
- Line 55: loc
  ```
  if "`s'" == "mean" local rlab "Mean"
  ```
- Line 56: loc
  ```
  if "`s'" == "p50"  local rlab "Median"
  ```
- Line 57: loc
  ```
  if "`s'" == "sd"   local rlab "SD"
  ```
- Line 58: loc
  ```
  if "`s'" == "min"  local rlab "Min"
  ```
- Line 59: loc
  ```
  if "`s'" == "max"  local rlab "Max"
  ```
- Line 61: loc
  ```
  local row "`rlab' &"
  ```
- Line 64: loc
  ```
  local x : di %4.2f r(`s')
  ```
- Line 65: loc
  ```
  local row "`row' & `x'"
  ```
- Line 80: loc
  ```
  local wbE "INPUT/pf_results_mu_x.xlsx"
  ```
- Line 81: loc
  ```
  local wbS "INPUT/BS_pf_results_mu_x.xlsx"
  ```
- Line 83: loc
  ```
  local spec est4s5r2e4p1IV5
  ```
- Line 86: loc
  ```
  local wbE "INPUT/BWpf_results_mu_x.xlsx"
  ```
- Line 87: loc
  ```
  local wbS "INPUT/BS_BWpf_results_mu_x.xlsx"
  ```
- Line 89: loc
  ```
  local spec est4s5r2e4p1IV5
  ```
- Line 96: name
  ```
  qui: rename (sigma gl gk gm g) (sig_`blk' b_gl_`blk' b_gk_`blk' b_gm_`blk' b_g_`blk')
  ```
- Line 104: name
  ```
  qui: rename (se_gl se_gk se_gm se_g) (s_gl_`blk' s_gk_`blk' s_gm_`blk' s_g_`blk')
  ```
- Line 112: name
  ```
  qui: rename (p_gl p_gk p_gm p_g) (p_gl_`blk' p_gk_`blk' p_gm_`blk' p_g_`blk')
  ```
- Line 129: name
  ```
  gen str60 secname = ""
  ```
- Line 130: name
  ```
  replace secname = "Food, Beverage, \& Tobacco"                     if secid == 1
  ```
- Line 131: name
  ```
  replace secname = "Textile, Apparel, \& Leather"                   if secid == 2
  ```
- Line 132: name
  ```
  replace secname = "Wood"                                           if secid == 3
  ```
- Line 133: name
  ```
  replace secname = "Pharmaceuticals"                                if secid == 5
  ```
- Line 134: name
  ```
  replace secname = "Chemicals, Plastics, \& Rubber (Petrochemical)" if secid == 6
  ```
- Line 135: name
  ```
  replace secname = "Non-metallic minerals"                          if secid == 7
  ```
- Line 136: name
  ```
  replace secname = "Metal"                                          if secid == 8
  ```
- Line 137: name
  ```
  replace secname = "Machinery, \& Trans. equip."                    if secid == 9
  ```
- Line 138: name
  ```
  replace secname = "Electronics"                                    if secid == 10
  ```
- Line 139: name
  ```
  replace secname = "Mfg. nec"                                       if secid == 11
  ```
- Line 145: loc, name
  ```
  local est "`=secname[`i']'"
  ```
- Line 146: loc
  ```
  local ses " "
  ```
- Line 148: loc
  ```
  local sg : di %4.2f sig_`blk'[`i']
  ```
- Line 149: loc
  ```
  local est "`est' & `sg'"
  ```
- Line 150: loc
  ```
  local ses "`ses' & "
  ```
- Line 152: loc
  ```
  local b : di %4.2f b_`v'_`blk'[`i']
  ```
- Line 153: loc
  ```
  local s : di %4.2f s_`v'_`blk'[`i']
  ```
- Line 154: loc
  ```
  local p = p_`v'_`blk'[`i']
  ```
- Line 155: loc
  ```
  local st = cond(`p' < .01, "\sym{***}", cond(`p' < .05, "\sym{**}", cond(`p' < .1, "\sym{*}", "")))
  ```
- Line 156: loc
  ```
  local est "`est' & `b'`st'"
  ```
- Line 157: loc
  ```
  local ses "`ses' & (`s')"
  ```
- Line 165: loc
  ```
  local avg "Mfg. average"
  ```
- Line 168: loc
  ```
  local m : di %4.2f r(mean)
  ```
- Line 169: loc
  ```
  local avg "`avg' & `m'"
  ```
- Line 172: loc
  ```
  local m : di %4.2f r(mean)
  ```
- Line 173: loc
  ```
  local avg "`avg' & `m'"
  ```

**/replication-package/Replication_JPE/STATA/SHELL.do**

- Line 11: name
  ```
  else if c(username) == "jaedo" {
  ```
- Line 14: name
  ```
  else if c(username) == "jc224773" {
  ```
- Line 65: lat
  ```
  qui: do STATA/SHOCK_CORR.do  // Robustness regarding shock correlation; Construct shock-series (Pane
  ```

**/replication-package/Replication_JPE/STATA/SHOCK_CORR.do**

- Line 2: lat
  ```
  ** Shock Correlation: Table B10
  ```
- Line 10: loc
  ```
  local IOyear = 1973
  ```
- Line 36: name
  ```
  rename (kis sale_vec ln_* ht_* dln_* dht_*) (kis_r`n' sale_vec_r`n' ln_*_r`n' ht_*_r`n' dln_*_r`n' d
  ```
- Line 60: name
  ```
  rename (ln_* ht_* dln_* dht_*) (t3_ln_* t3_ht_* t3_dln_* t3_dht_*)
  ```
- Line 133: name
  ```
  rename dsec sec
  ```
- Line 134: name
  ```
  rename value `var'
  ```
- Line 151: name
  ```
  rename `od'sec sec
  ```
- Line 153: name
  ```
  rename (sec secid) (`od'sec `od'secid)
  ```
- Line 155: name
  ```
  rename dsec sec
  ```
- Line 159: name
  ```
  rename sec dsec
  ```
- Line 168: name
  ```
  rename (osec osecid) (sec secid)
  ```
- Line 170: name
  ```
  rename (sec secid) (osec osecid)
  ```
- Line 171: name
  ```
  rename (dsec dsecid) (sec secid)
  ```
- Line 187: name
  ```
  rename `od'sec sec
  ```
- Line 189: name
  ```
  rename (sec secid) (`od'sec `od'secid)
  ```
- Line 191: name
  ```
  rename osec sec
  ```
- Line 194: name
  ```
  rename sec osec
  ```
- Line 205: name
  ```
  rename (osecid osec `var') (secid sec own_`var')
  ```
- Line 212: name
  ```
  rename (dsec dsecid) (sec secid)
  ```
- Line 214: name
  ```
  rename (sec secid) (dsec dsecid)
  ```
- Line 215: name
  ```
  rename (osec osecid) (sec secid)
  ```
- Line 251: name
  ```
  rename (t3_*) (own_t3_*)
  ```
- Line 276: name
  ```
  rename (osecid osec dsecid dsec) (secid sec other_secid other_sec)
  ```
- Line 280: name
  ```
  rename (osecid osec dsecid dsec) (other_secid other_sec secid sec)
  ```
- Line 298: lat
  ```
  ** Shock Correlation Regression
  ```
- Line 302: loc
  ```
  local dep F1ln_a_fj
  ```
- Line 303: loc
  ```
  local X1 ln_a_fj t3_ln_a_fj
  ```
- Line 304: loc
  ```
  local X2 ln_a_fj t3_ln_a_fj upt3_ln_a_fj downt3_ln_a_fj
  ```
- Line 306: loc
  ```
  local own_var ln_a_fj ln_tau_l ln_tau_k ht_df_real
  ```
- Line 307: loc
  ```
  local t3_var t3_ln_a_fj t3_ln_tau_l t3_ln_tau_k t3_ht_df_real
  ```
- Line 312: loc
  ```
  local cl secid
  ```
- Line 313: loc
  ```
  local FE i.year i.secid
  ```
- Line 315: loc
  ```
  local specs
  ```
- Line 323: loc
  ```
  local specs `specs' s`s'
  ```
- Line 325: name
  ```
  tempname BP
  ```
- Line 326: loc
  ```
  local nX : word count `X`s''
  ```
- Line 328: lname, name
  ```
  matrix colnames `BP' = `X`s''
  ```
- Line 329: loc
  ```
  local j = 0
  ```
- Line 331: loc
  ```
  local ++j
  ```
- Line 348: second
  ```
  ** LASSO-data: Second-order polynomials
  ```
- Line 353: loc
  ```
  local dep F1ln_a_fj
  ```
- Line 355: loc
  ```
  local own_var ln_tau_l ln_tau_k ht_df_real
  ```
- Line 356: loc
  ```
  local t3_var t3_ln_tau_l t3_ln_tau_k t3_ht_df_real
  ```
- Line 357: loc
  ```
  local upt3_var upt3_ln_tau_l upt3_ln_tau_k upt3_ht_df_real
  ```
- Line 358: loc
  ```
  local downt3_var downt3_ln_tau_l downt3_ln_tau_k downt3_ht_df_real
  ```
- Line 364: loc
  ```
  local own_lag ln_a_fj
  ```
- Line 365: loc
  ```
  local own_t3_lag t3_ln_a_fj
  ```
- Line 366: loc
  ```
  local own_upt3_lag upt3_ln_a_fj
  ```
- Line 367: loc
  ```
  local own_downt3_lag downt3_ln_a_fj
  ```
- Line 369: loc
  ```
  local FE i.year i.secid
  ```
- Line 370: loc
  ```
  local cl secid
  ```
- Line 372: loc
  ```
  local manyX1 `own_var' `t3_var'
  ```
- Line 373: loc
  ```
  local manyX2
  ```
- Line 375: loc
  ```
  local i = 1
  ```
- Line 376: loc
  ```
  local toexclude
  ```
- Line 378: loc
  ```
  local loopvarlist `own_var' `t3_var'
  ```
- Line 381: loc
  ```
  local loopvarlist `own_var' `t3_var' `upt3_var' `downt3_var'
  ```
- Line 385: loc
  ```
  qui: local sec_own_var: list loopvarlist - toexclude
  ```
- Line 392: loc
  ```
  qui: local manyX2 `manyX2' X2_`i'
  ```
- Line 393: loc
  ```
  qui: local i = `i' + 1
  ```
- Line 395: loc
  ```
  qui: local toexclude `toexclude' `var1'
  ```
- Line 403: loc
  ```
  qui: local toexclude `dep'
  ```
- Line 404: loc
  ```
  qui: local remain_t3: list t3_var - own_t3_lag
  ```
- Line 405: loc
  ```
  qui: local remain_own: list own_var - own_lag
  ```
- Line 406: loc
  ```
  qui: local remain_downt3: list downt3_var - own_downt3_lag
  ```
- Line 407: loc
  ```
  qui: local remain_upt3: list upt3_var - own_upt3_lag
  ```
- Line 410: loc
  ```
  qui: local must_var `own_lag' `own_t3_lag'
  ```
- Line 411: loc
  ```
  qui: local select_var `remain_own' `remain_t3' `remain_upt3' `remain_downt3' `manyX2'
  ```
- Line 414: loc
  ```
  qui: local must_var `own_lag' `own_t3_lag' `own_upt3_lag' `own_downt3_lag'
  ```
- Line 415: loc
  ```
  qui: local select_var `remain_own' `remain_t3' `remain_upt3' `remain_downt3' `manyX2'
  ```
- Line 418: loc
  ```
  local select_var `e(xselected)'
  ```
- Line 428: name
  ```
  tempname BP
  ```
- Line 429: loc
  ```
  local nX : word count `X`must''
  ```
- Line 431: lname, name
  ```
  matrix colnames `BP' = `X`must''
  ```
- Line 432: loc
  ```
  local j = 0
  ```
- Line 434: loc
  ```
  local ++j
  ```
- Line 441: loc
  ```
  qui: local specs `specs' lasso_m`must'
  ```
- Line 444: loc
  ```
  local keep_var `X2'
  ```
- Line 481: name
  ```
  rename log_a_fj log_a_fj_counter
  ```
- Line 503: name
  ```
  rename (secid other_secid) (secid_org secid)
  ```

**/replication-package/Replication_JPE/STATA/SHOCK_VALIDATION.do**

- Line 6: name
  ```
  rename (hscombinedproductcode isicrevision3productcode) (hs6 isic3)
  ```
- Line 34: country, loc
  ```
  local country KOR
  ```
- Line 37: country, loc
  ```
  local country TWN
  ```
- Line 48: country, name
  ```
  rename value export`country'
  ```
- Line 49: country
  ```
  keep year export`country' sec
  ```
- Line 50: country
  ```
  save DATA/TEMP/export`country', replace
  ```
- Line 58: country
  ```
  foreach country in KOR TWN{
  ```
- Line 60: country
  ```
  replace export`country' = 0 if export`country' == .
  ```
- Line 69: name
  ```
  rename value TWNex_to_KOR
  ```
- Line 76: name
  ```
  rename value TWNim_from_KOR
  ```
- Line 123: name
  ```
  rename value export`cty'
  ```
- Line 138: name
  ```
  rename value TWNim_from_KOR
  ```
- Line 144: name
  ```
  rename value TWNex_to_KOR
  ```
- Line 284: lat
  ```
  ** Table B6: Correlation between firm size and industry policy-related observables
  ```
- Line 292: lon
  ```
  gen long _rid = _n
  ```
- Line 313: name
  ```
  rename byear year
  ```
- Line 323: loc
  ```
  local d1 dum_tech
  ```
- Line 324: loc
  ```
  local d2 ht_loan
  ```
- Line 325: loc
  ```
  local d3 ht_kotnum
  ```
- Line 327: loc
  ```
  local X ln_sale
  ```
- Line 329: loc
  ```
  local fe1 noa
  ```
- Line 330: loc
  ```
  local fe2 a(sec_year_id)
  ```
- Line 332: loc
  ```
  local specs
  ```
- Line 333: loc
  ```
  local pos = 1
  ```
- Line 341: loc
  ```
  local specs `specs' s`pos'
  ```
- Line 342: loc
  ```
  local pos = `pos' + 1
  ```
- Line 359: loc
  ```
  local specs `specs' s`pos'
  ```
- Line 360: loc
  ```
  local pos = `pos' + 1
  ```
- Line 399: loc
  ```
  local rrr1 = 2
  ```
- Line 430: loc
  ```
  qui: local rrr1 = `rrr1' + 1
  ```
- Line 471: lat
  ```
  ** FIGURE B12: Correlation between firm size and wedges over time
  ```
- Line 496: loc
  ```
  local specs
  ```
- Line 499: loc
  ```
  local cl firmid
  ```
- Line 500: loc
  ```
  local FE firmid year
  ```
- Line 502: loc
  ```
  local X dexshock_TWN
  ```
- Line 507: loc
  ```
  local pre_var L1dln_a_fj L1dln_tau_k L1dln_tau_l L1dln_df_tilde
  ```
- Line 510: loc
  ```
  local pre_var L1dln_a_fj L1dln_tau_k L1dln_tau_l L1dht_df_tilde
  ```
- Line 516: loc
  ```
  local bp = string(r(p), "%4.2f")
  ```
- Line 517: loc
  ```
  qui: estadd local bootp "$[`bp']$" : s`dep'
  ```
- Line 519: loc
  ```
  local specs `specs' s`dep'
  ```
- Line 531: loc
  ```
  local cl firmid
  ```
- Line 532: loc
  ```
  local FE secid
  ```
- Line 533: loc
  ```
  local X dratio
  ```
- Line 534: loc
  ```
  local specs
  ```
- Line 537: loc
  ```
  local cond inlist(year, 1997, 2001)
  ```
- Line 540: loc
  ```
  local cond inlist(year, 1990, 1994)
  ```
- Line 545: lon
  ```
  bysort firmid (year): gen long_dln_`var' = ln_`var' - ln_`var'[_n-1]
  ```
- Line 550: lon
  ```
  reghdfe long_d`dep' `X', a(`FE') cluster(`cl')
  ```
- Line 555: loc
  ```
  local specs `specs' `time'_`dep'
  ```
- Line 624: loc, name
  ```
  if "`var'" == "l" local figname FIGUREB2_C
  ```
- Line 625: loc, name
  ```
  if "`var'" == "k" local figname FIGUREB2_D
  ```
- Line 629: name
  ```
  graph export "FIGURE/`figname'.pdf", as(pdf) replace
  ```

**/replication-package/Replication_JPE/STATA/TO_MATLAB.do**

- Line 5: name
  ```
  ** Names of sectors
  ```
- Line 25: name
  ```
  qui: rename `od'sec sec
  ```
- Line 27: name
  ```
  qui: rename (sec secid) (`od'sec `od'secid )
  ```
- Line 35: country
  ```
  qui: gen dcountry = "KOR"
  ```
- Line 36: country
  ```
  qui: gen ocountry = ""
  ```
- Line 37: country
  ```
  qui: replace ocountry = "KOR" if dsec == "export"
  ```
- Line 38: country
  ```
  qui: replace dcountry = "ROW" if dsec == "export"
  ```
- Line 41: country
  ```
  qui: sort osec dsec ocountry dcountry
  ```
- Line 48: name
  ```
  qui: rename (osec osecid) (sec secid)
  ```
- Line 64: name
  ```
  qui: rename (osec osecid value) (sec secid imports)
  ```
- Line 77: name
  ```
  qui: rename (osec osecid value) (sec secid expen )
  ```
- Line 97: name
  ```
  qui: rename (osecid osec value) (secid sec exports)
  ```
- Line 108: name
  ```
  qui: rename value GO
  ```
- Line 109: name
  ```
  qui: rename (dsec dsecid) (sec secid)
  ```
- Line 118: name
  ```
  qui: rename value TOT
  ```
- Line 119: name
  ```
  qui: rename (dsec dsecid) (sec secid)
  ```
- Line 129: lat
  ```
  * Export shares relative to GO
  ```
- Line 144: name
  ```
  qui: rename dsec sec
  ```
- Line 147: name
  ```
  qui: rename sec dsec
  ```
- Line 219: name
  ```
  rename dsec sec
  ```
- Line 226: name
  ```
  rename sec dsec
  ```
- Line 246: lat
  ```
  qui: gen rGDP = rgdppc * population
  ```
- Line 349: name
  ```
  qui: keep firmid cname
  ```
- Line 351: name
  ```
  qui: save "DATA/firmid_cname", replace
  ```
- Line 393: name
  ```
  qui: rename (GO K L EX) (GOimpu Kimpu Limpu EXimpu)
  ```
- Line 421: country, sex
  ```
  keep if country == "Republic of Korea" & sex == "MF"
  ```

**/replication-package/Replication_JPE/STATA/spillover_region.do**

- Line 3: name
  ```
  rename a_fj a_fj_counter
  ```
- Line 12: loc
  ```
  local sigma=5
  ```

**/replication-package/Replication_JPE/STATA/subcode/SUB_CLASSIFICATION.do**

- Line 4: loc
  ```
  local seclist
  ```

**/replication-package/Replication_JPE/STATA/subcode/SUB_SECTOR_AGG.do**

- Line 54: lat
  ```
  _313	…………Insula
  ```
- Line 102: city
  ```
  _40x	……Electricity su
  ```
- Line 121: house
  ```
  ……Retail trade, except of motor vehicles and motorcycles; repair of household g
  ```
- Line 140: social
  ```
  ……Insurance and pension funding, except compulsory social secu
  ```
- Line 141: lat
  ```
  ……Activities related to financial intermedia
  ```
- Line 146: lat
  ```
  _72	………Computer and related acti
  ```
- Line 157: social
  ```
  _L	…PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURI
  ```
- Line 159: social
  ```
  _N	…HEALTH AND SOCIAL WO
  ```
- Line 169: house, son
  ```
  …PRIVATE HOUSEHOLDS WITH EMPLOYED PERSO
  ```

**/replication-package/Replication_JPE/TABLE/TABLEB4.tex**

- Line 2: son
  ```
  & Oligopoly & Oligopsony & Monopolistic Competition \\  \hline
  ```

**/replication-package/Replication_JPE/TABLE/TABLEB5.tex**

- Line 5: lat
  ```
  \textbf{(a) Treated groups} (event: first Chun-era bribe/donation) & \textbf{(b) Control groups (lat
  ```
- Line 33: lon
  ```
  Kolon & 4 & 4.6 & 0.16 \\
  ```

