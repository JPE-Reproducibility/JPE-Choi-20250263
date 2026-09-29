%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Table 3 %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    error('making_table3:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
table = string(fullfile(project_root,'TABLE')) + filesep;
if ~isfolder(table)
    mkdir(table);
end

outputFile = fullfile(table, ...
    'TABLE3.tex');
Fid = fopen(outputFile, 'w');
fprintf(Fid, '%s\n', '\begin{tabular}{lccccc}');
fprintf(Fid, '%s\n', '\toprule');
fprintf(Fid, '%s\n', '  & (1) & (2) & (3) & (4) & (5) \\');
fprintf(Fid, '%s\n', ...
    'Shocks & All shocks & Productivity & Foreign demand & Labor distortions & Capital distortions \\');
fprintf(Fid, '%s\n', ...
    ' & & $a_{fjt}$ & $D_{fjt}^{f}$ & $1 + \tau_{fjt}^{L}$ & $1 + \tau_{fjt}^{K}$ \\');
fprintf(Fid, '%s\n', '\midrule');

fprintf(Fid, '%s\n', ...
    '& \multicolumn{4}{l}{\textit{\underline{Panel A. Top 3 firms within sectors}}} \\[0.5em]');

top3_welfare = format_welfare_values([lmd_granular_top3(5), ...
    lmd_granular_top3(1),lmd_granular_top3(2), ...
    lmd_granular_top3(4),lmd_granular_top3(3)]);
fprintf(Fid, ...
    '$\\triangle$ Welfare (\\%%) & %s & %s & %s & %s & %s \\\\[1em]\n', ...
    top3_welfare{:});

fprintf(Fid, '%s\n', ...
    '& \multicolumn{4}{l}{\textit{\underline{Panel B. Samsung Electronics}}} \\');

samsung_welfare = format_welfare_values([lmd_samsung(5), ...
    lmd_samsung(1),lmd_samsung(2),lmd_samsung(4),lmd_samsung(3)]);
fprintf(Fid, ...
    '$\\triangle$ Welfare (\\%%) & %s & %s & %s & %s & %s \\\\[1em]\n', ...
    samsung_welfare{:});

fprintf(Fid, '%s\n', ...
    '& \multicolumn{4}{l}{\textit{\underline{Panel C. Hyundai Motors}}} \\');

hyundai_welfare = format_welfare_values([lmd_hyundai(5), ...
    lmd_hyundai(1),lmd_hyundai(2),lmd_hyundai(4),lmd_hyundai(3)]);
fprintf(Fid, ...
    '$\\triangle$ Welfare (\\%%) & %s & %s & %s & %s & %s \\\\\n', ...
    hyundai_welfare{:});

fprintf(Fid, '%s\n', '\bottomrule');
fprintf(Fid, '%s\n', '\end{tabular}');

fclose(Fid);

function formatted_values = format_welfare_values(values)
formatted_values = cell(1,numel(values));
for value_index = 1:numel(values)
    value = values(value_index);
    if value < 0
        formatted_values{value_index} = sprintf('$-$%.2f',abs(value));
    else
        formatted_values{value_index} = sprintf('%.2f',value);
    end
end
end
