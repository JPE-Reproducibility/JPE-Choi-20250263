% Table 6: industrial-policy counterfactuals for all firms and top-3 firms.

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
    error('making_table6:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
if ~exist('table','var') || isempty(table)
    table = string(fullfile(project_root,'TABLE')) + filesep;
end
if ~isfolder(table)
    mkdir(table);
end

% Columns 1--3 are all firms; columns 4--6 are top-3 firms.
table_values = [ ...
    (agg_granular_ip{1}.CR3_vec(end)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_ip_vec(end,1)/GDP_result(end)-1)*100, ...
    lmd_ip(1), ...
    (agg_granular_ip{2}.CR3_vec(end)-agg_result.CR3_vec(end))*100, ...
    (GDP_granular_ip_vec(end,2)/GDP_result(end)-1)*100, ...
    lmd_ip(2)];

formatted_values = cell(1,6);
for value_idx = 1:6
    value = table_values(value_idx);
    if value < 0
        formatted_values{value_idx} = sprintf('$-$%.2f',abs(value));
    else
        formatted_values{value_idx} = sprintf('%.2f',value);
    end
end

table_file = fullfile(table,'TABLE6.tex');
fid = fopen(table_file,'w');
if fid == -1
    error('making_table6:CannotWriteTable',...
        'Cannot write table to %s.',table_file);
end

fprintf(fid,'%s\n','\begin{tabular}{ccc c ccc}');
fprintf(fid,'%s\n','\toprule');
fprintf(fid,'%s\n','(1) & (2) & (3) & & (4) & (5) & (6)\\');
fprintf(fid,'%s\n','\multicolumn{3}{c}{All firms} & & \multicolumn{3}{c}{Top-3 only} \\');
fprintf(fid,'%s\n','\cline{1-3} \cline{5-7}');
fprintf(fid,'%s\n','$\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) & & $\triangle$ CR in & $\triangle$ Real GDP per & $\triangle$ Welfare (\%) \\');
fprintf(fid,'%s\n','2011 (pp) & capita in 2011 (\%) & & & 2011 (pp) & capita in 2011 (\%) & \\');
fprintf(fid,'%s\n','& & & & & & \\');
fprintf(fid,'%s\n',[formatted_values{1} ' & ' formatted_values{2} ' & ' formatted_values{3} ...
    ' & & ' formatted_values{4} ' & ' formatted_values{5} ' & ' formatted_values{6} ' \\']);
fprintf(fid,'%s\n','& & & & & & \\');
fprintf(fid,'%s\n','\bottomrule');
fprintf(fid,'%s\n','\end{tabular}');
fclose(fid);

fprintf('Wrote Table 6: %s\n',table_file);
