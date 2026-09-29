% Table B11: robustness results assembled from saved six-element vectors.

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
    error('making_tableB11:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
result_dir = fullfile(matlab_dir,'result');
table_dir = fullfile(project_root,'TABLE');
if ~isfolder(result_dir)
    error('making_tableB11:MissingResultFolder', ...
        'Result folder not found: %s',result_dir);
end
if ~isfolder(table_dir)
    mkdir(table_dir);
end

scenario_files = {
    {'result_base.mat','T_result_base.mat'}
    {'result_robust_exo_capital.mat'}
    {'result_robust_BW.mat'}
    {'result_robust_sigma_3.mat'}
    {'result_robust_sigma_7.mat'}
    {'result_robust_rho_15.mat'}
    {'result_robust_rho_25.mat'}
    {'result_robust_eta_3.mat'}
    {'result_robust_eta_6.mat'}
    {'result_robust_theta_15.mat'}
    {'result_robust_theta_25.mat'}
    {'result_robust_phi_0.mat'}
    {'result_robust_phi_1.mat'}
    {'result_robust_chi_05.mat'}
    {'result_robust_chi_0.mat'}
    {'result_robust_CRS.mat'}
    {'result_robust_with_variety.mat'}
    {'result_robust_non_exporter.mat'}
    {'result_robust_only_exporter.mat'}
    {'result_robust_top4.mat'}
    {'result_robust_top10.mat'} };

table_values = zeros(numel(scenario_files),6);
for scenario_idx = 1:numel(scenario_files)
    table_values(scenario_idx,:) = load_result_vector( ...
        result_dir,scenario_files{scenario_idx});
end

table_file = fullfile(table_dir,'TABLEB11.tex');
fid = fopen(table_file,'w');
if fid == -1
    error('making_tableB11:CannotWriteTable', ...
        'Cannot write Table B11 to %s.',table_file);
end
file_cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>

write_table_line(fid,'\begin{tabular}{l ccc ccc }');
write_table_line(fid,'\toprule');
write_table_line(fid,'& \multicolumn{6}{c}{Counterfactual vs. Factual Shocks} \\');
write_table_line(fid,'\cmidrule(lr){2-7}');
write_table_line(fid,'& \multicolumn{3}{c}{All shocks} & \multicolumn{3}{c}{Productivity shocks}\\');
write_table_line(fid,'\cmidrule(lr){2-4} \cmidrule(lr){5-7}');
write_table_line(fid,['& $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & ' ...
    '$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\']);
write_table_line(fid,'& 2011 (pp) & capita in 2011 (\%) & & 2011 (pp) & capita in 2011 (\%) & \\');
write_table_line(fid,'\cmidrule(lr){2-2} \cmidrule(lr){3-3} \cmidrule(lr){4-4} \cmidrule(lr){5-5} \cmidrule(lr){6-6} \cmidrule(lr){7-7}');
write_table_line(fid,'& (1) & (2) & (3) & (4) & (5) & (6) \\');
write_table_line(fid,'\midrule');

panel_titles = { ...
    'Panel A. Baseline'; ...
    'Panel B. Exogenous capital'; ...
    'Panel C. Sector-specific $\sigma_j$ \citep{Broda_Weinstein:06}'; ...
    'Panel D. $\sigma$'; ...
    'Panel E. $\rho$'; ...
    'Panel F. $\eta$'; ...
    'Panel G. $\theta$'; ...
    'Panel H. $\psi$'; ...
    'Panel I. $\zeta$'; ...
    'Panel J. Constant returns to scale $\gamma_j = 1$, $\forall j$'; ...
    'Panel K. Allowing for love-of-variety'; ...
    'Panel L. Production Function Estimation'; ...
    'Panel M. The number of top firms'};

write_panel(fid,panel_titles{1});
write_result_row(fid,'',table_values(1,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{2});
write_result_row(fid,'',table_values(2,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{3});
write_result_row(fid,'',table_values(3,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{4});
write_result_row(fid,'$\sigma = 3$',table_values(4,:));
write_result_row(fid,'$\sigma = 7$',table_values(5,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{5});
write_result_row(fid,'$\rho = 1.5$',table_values(6,:));
write_result_row(fid,'$\rho = 2.5$',table_values(7,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{6});
write_result_row(fid,'$\eta = 3$',table_values(8,:));
write_result_row(fid,'$\eta = 6$',table_values(9,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{7});
write_result_row(fid,'$\theta = 1.5$',table_values(10,:));
write_result_row(fid,'$\theta = 2.5$',table_values(11,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{8});
write_result_row(fid,'$\psi = 0$',table_values(12,:));
write_result_row(fid,'$\psi = 1$',table_values(13,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{9});
write_result_row(fid,'$\zeta = 0.5$',table_values(14,:));
write_result_row(fid,'$\zeta = 1$',table_values(15,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{10});
write_result_row(fid,'',table_values(16,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{11});
write_result_row(fid,'',table_values(17,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{12});
write_result_row(fid,'Only Non-exporters',table_values(18,:));
write_result_row(fid,'Only Exporters',table_values(19,:));
write_table_line(fid,'[1em]');
write_panel(fid,panel_titles{13});
write_result_row(fid,'Top-4 firms',table_values(20,:));
write_result_row(fid,'Top-10 firms',table_values(21,:));
write_table_line(fid,'\bottomrule');
write_table_line(fid,'\end{tabular}');

fprintf('Wrote robustness table: %s\n',table_file);

function result_vector = load_result_vector(result_dir,file_candidates)
for file_idx = 1:numel(file_candidates)
    result_file = fullfile(result_dir,file_candidates{file_idx});
    if isfile(result_file)
        loaded_result = load(result_file);
        result_vector = find_six_element_result(loaded_result,result_file);
        return
    end
end
error('making_tableB11:MissingResultFile', ...
    'None of these result files exists: %s',strjoin(file_candidates,', '));
end

function result_vector = find_six_element_result(loaded_result,result_file)
preferred_variables = {'T_robust','T_result_base','T_top4','T_top10','T_result'};
for variable_idx = 1:numel(preferred_variables)
    variable_name = preferred_variables{variable_idx};
    if isfield(loaded_result,variable_name)
        candidate = loaded_result.(variable_name);
        if isnumeric(candidate) && numel(candidate) == 6
            result_vector = double(candidate(:))';
            return
        end
    end
end

variable_names = fieldnames(loaded_result);
matching_variables = {};
for variable_idx = 1:numel(variable_names)
    candidate = loaded_result.(variable_names{variable_idx});
    if isnumeric(candidate) && numel(candidate) == 6
        matching_variables{end+1} = variable_names{variable_idx}; %#ok<AGROW>
    end
end
if numel(matching_variables) ~= 1
    error('making_tableB11:InvalidResultFile', ...
        'Expected one six-element numeric result vector in %s.',result_file);
end
result_vector = double(loaded_result.(matching_variables{1})(:))';
end

function write_panel(fid,panel_title)
write_table_line(fid,['& \multicolumn{6}{l}{\underline{\textit{' panel_title '}}} \\']);
end

function write_result_row(fid,row_label,result_vector)
formatted_values = cell(1,6);
for value_idx = 1:6
    formatted_values{value_idx} = format_latex_number(result_vector(value_idx));
end
write_table_line(fid,[row_label ' & ' strjoin(formatted_values,' & ') ' \\']);
end

function formatted_value = format_latex_number(value)
if value < 0
    formatted_value = sprintf('$-$%.2f',abs(value));
else
    formatted_value = sprintf('%.2f',value);
end
end

function write_table_line(fid,line)
fprintf(fid,'%s\n',line);
end
