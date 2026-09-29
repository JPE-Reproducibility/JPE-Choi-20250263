% Table 7: alternative assumptions.
% This script is run by solve_full_model_p2.m after its five
% counterfactual exercises have finished.

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
    error('making_table7:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
if ~exist('table','var') || isempty(table)
    table = string(fullfile(project_root,'TABLE')) + filesep;
end
if ~isfolder(table)
    mkdir(table);
end

base_file = fullfile(matlab_dir,'result','result_base.mat');
if ~isfile(base_file)
    error('making_table7:MissingBaselineResult',...
        'Baseline result file not found: %s',base_file);
end
base_results = load(base_file);
if ~isfield(base_results,'T_result') || numel(base_results.T_result) ~= 6
    error('making_table7:InvalidBaselineResult',...
        'result_base.mat must contain a six-element T_result vector.');
end

% Columns 1--3 are all shocks; columns 4--6 are productivity shocks.
table_values = zeros(5,6);
table_values(1,:) = base_results.T_result(:)';
table_values(2,:) = [ ...
    (CR3_granular_top3_profit_fix(end,5)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_top3_profit_fix(end,5)/GDP_result(end)-1)*100, ...
    lmd_granular_top3_profit_fix(5), ...
    (CR3_granular_top3_profit_fix(end,1)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_top3_profit_fix(end,1)/GDP_result(end)-1)*100, ...
    lmd_granular_top3_profit_fix(1)];
table_values(3,:) = [ ...
    (CR3_granular_top3_A_j_fix(end,5)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_top3_A_j_fix(end,5)/GDP_result(end)-1)*100, ...
    lmd_granular_top3_A_j_fix(5), ...
    (CR3_granular_top3_A_j_fix(end,1)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_top3_A_j_fix(end,1)/GDP_result(end)-1)*100, ...
    lmd_granular_top3_A_j_fix(1)];
table_values(4,:) = [ ...
    (CR3_granular_spillover(end,5)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_spillover(end,5)/GDP_result(end)-1)*100, ...
    lmd_granular_spillover(5), ...
    (CR3_granular_spillover(end,1)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_spillover(end,1)/GDP_result(end)-1)*100, ...
    lmd_granular_spillover(1)];
table_values(5,:) = [ ...
    (CR3_granular_shock_corr_io(end,5)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_shock_corr_io(end,5)/GDP_result(end)-1)*100, ...
    lmd_granular_shock_corr_io(5), ...
    (CR3_granular_shock_corr_io(end,1)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_shock_corr_io(end,1)/GDP_result(end)-1)*100, ...
    lmd_granular_shock_corr_io(1)];

% Format negatives as "$-$15.41", matching the paper's LaTex convention.
formatted_values = cell(size(table_values));
for row_idx = 1:size(table_values,1)
    for column_idx = 1:size(table_values,2)
        value = table_values(row_idx,column_idx);
        if value < 0
            formatted_values{row_idx,column_idx} = sprintf('$-$%.2f',abs(value));
        else
            formatted_values{row_idx,column_idx} = sprintf('%.2f',value);
        end
    end
end

table_file = fullfile(table,'TABLE7.tex');
Fid = fopen(table_file,'w');
if Fid == -1
    error('making_table7:CannotWriteTable',...
        'Cannot write Table 7 to %s',table_file);
end

fprintf(Fid,'%s\n','\begin{tabular}{ccc ccc }');
fprintf(Fid,'%s\n','\toprule');
fprintf(Fid,'%s\n','(1) & (2) & (3) & (4) & (5) & (6) \\');
fprintf(Fid,'%s\n','\multicolumn{6}{c}{Counterfactual vs. Factual Shocks}\\');
fprintf(Fid,'%s\n','\cmidrule(lr){1-6}');
fprintf(Fid,'%s\n','\multicolumn{3}{c}{All shocks} & \multicolumn{3}{c}{Productivity shocks}\\');
fprintf(Fid,'%s\n','\cmidrule(lr){1-3} \cmidrule(lr){4-6}');
fprintf(Fid,'%s\n','$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\');
fprintf(Fid,'%s\n','2011 (pp) & capita in 2011 (\%) & & 2011 (pp) & capita in 2011 (\%) & \\');
fprintf(Fid,'%s\n','\midrule');

panel_labels = { ...
    '\multicolumn{3}{l}{\underline{\textit{Panel A. Baseline}}} & & &\\'
    '\multicolumn{3}{l}{\underline{\textit{Panel B. Free entry}}} & & &\\'
    '\multicolumn{3}{l}{\underline{\textit{Panel C. Constant sectoral productivity}}} & & &\\'
    '\multicolumn{3}{l}{\underline{\textit{Panel D. Productivity spillovers: Structural \citep{Choi_Shim:25}}}} & & &\\'
    '\multicolumn{5}{l}{\underline{\textit{Panel E. Productivity spillovers: Reduced-form empirical}}} &\\'};

for row_idx = 1:size(table_values,1)
    fprintf(Fid,'%s\n',panel_labels{row_idx});
    fprintf(Fid,'%s\n',[strjoin(formatted_values(row_idx,:),' & ') ' \\']);
end

fprintf(Fid,'%s\n','\bottomrule');
fprintf(Fid,'%s\n','\end{tabular}');
fclose(Fid);

fprintf('Wrote Table 7: %s\n',table_file);
