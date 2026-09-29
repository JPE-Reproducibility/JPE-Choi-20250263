% Table: counterfactuals that remove only capital or labor distortions.

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
    error('making_table4:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
result_dir = fullfile(matlab_dir,'result');
table_dir = fullfile(project_root,'TABLE');
if ~isfolder(table_dir)
    mkdir(table_dir);
end

capital_file = fullfile(result_dir,'result_only_tau_k.mat');
labor_file = fullfile(result_dir,'result_only_tau_l.mat');
if ~isfile(capital_file) || ~isfile(labor_file)
    error('making_table_only_tau:MissingResultFile',...
        'Run both solve_full_model_only_tau_k.m and solve_full_model_only_tau_l.m first.');
end

capital_result = load(capital_file,'T_result');
labor_result = load(labor_file,'T_result');
if ~isfield(capital_result,'T_result') || numel(capital_result.T_result) < 3 || ...
        ~isfield(labor_result,'T_result') || numel(labor_result.T_result) < 3
    error('making_table_only_tau:InvalidResultFile',...
        'Each tau-only result file must contain at least three T_result values.');
end

% Columns 1--3: capital distortions; columns 4--6: labor distortions.
table_values = [capital_result.T_result(1:3),labor_result.T_result(1:3)];
formatted_values = cell(1,6);
for value_idx = 1:6
    value = table_values(value_idx);
    if value < 0
        formatted_values{value_idx} = sprintf('$-$%.2f',abs(value));
    else
        formatted_values{value_idx} = sprintf('%.2f',value);
    end
end

table_file = fullfile(table_dir,'TABLE4.tex');
fid = fopen(table_file,'w');
if fid == -1
    error('making_table_only_tau:CannotWriteTable',...
        'Cannot write table to %s.',table_file);
end

fprintf(fid,'%s\n','\begin{tabular}{ccc ccc }');
fprintf(fid,'%s\n','\toprule');
fprintf(fid,'%s\n','(1) & (2) & (3) & (4) & (5) & (6) \\');
fprintf(fid,'%s\n','\multicolumn{3}{c}{Capital Distortions} & \multicolumn{3}{c}{Labor Distortions}\\');
fprintf(fid,'%s\n','\cmidrule(lr){1-3} \cmidrule(lr){4-6}');
fprintf(fid,'%s\n','$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\');
fprintf(fid,'%s\n','2011 (pp) & capita in 2011 (\%) & & 2011 (pp) & capita in 2011 (\%) & \\');
fprintf(fid,'%s\n','& & & & & \\');
fprintf(fid,'%s\n',[strjoin(formatted_values,' & ') ' \\']);
fprintf(fid,'%s\n','\bottomrule');
fprintf(fid,'%s\n','\end{tabular}');
fclose(fid);

fprintf('Wrote tau-distortion table: %s\n',table_file);
