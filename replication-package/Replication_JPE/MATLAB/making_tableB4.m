% Table B4
% Welfare - market structure

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
    error('making_tableB4:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
table = string(fullfile(project_root,'TABLE')) + filesep;
if ~isfolder(table)
    mkdir(table);
end

Fid = fopen(table+'TABLEB4.tex', 'w');
fprintf(Fid,'%s\n', '\begin{tabular}{lrrr}' );
fprintf(Fid,'%s\n', ' & Oligopoly & Oligopsony & Monopolistic Competition \\  \hline' );
fprintf(Fid,'%s\n', 'Welfare (\%)');
fprintf(Fid,'& %2.2f & %2.2f & %2.2f   \\\\ ',lmd_mkt_str(2),lmd_mkt_str(3),lmd_mkt_str(4));
% fprintf(Fid,'GDP in 2011 & %2.2f & %2.2f & %2.2f & %2.2f & %2.2f  \\\\ ',GDP_granular1(end)/gdp_hat(end),GDP_granular2(end)/gdp_hat(end),GDP_granular3(end)/gdp_hat(end),GDP_granular4(end)/gdp_hat(end),GDP_granular5(end)/gdp_hat(end));
% fprintf(Fid,'CR10 in 2011 & %2.2f & %2.2f & %2.2f & %2.2f & %2.2f  \\\\ ',CR10_granular1(end)/CR10_result(end,1),CR10_granular2(end)/CR10_result(end,1),CR10_granular3(end)/CR10_result(end,1),CR10_granular4(end)/CR10_result(end,1),CR10_granular5(end)/CR10_result(end,1));
fprintf(Fid,'%s\n', '\end{tabular}   ');
fclose(Fid);
