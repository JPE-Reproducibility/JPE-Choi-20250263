clear

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
    error('MATLAB_part1:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);
save_result("base")
save_result("notruncation_nosmoothing")
% These make input for STATA: result_base.csv, result_base_notruncation_nosmoothing.csv 
run solve_full_model_part1.m
run solve_full_model_only_tau_k.m
run solve_full_model_only_tau_l.m
run making_table4.m
run run_robustness.m

