% Robustness exercises and Table B11.
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
    error('run_robustness:InvalidProjectRoot', ...
        'Expected INPUT/ at the Replication_JPE root; resolved root: %s',project_root);
end
addpath(matlab_dir);

spec_vec = {"sigma_3","sigma_7","eta_3","eta_6","theta_15", ...
    "theta_25","phi_1","phi_0","chi_0","chi_05","rho_15", ...
    "rho_25","BW","non_exporter","only_exporter","CRS","with_variety"};

for i = 1:length(spec_vec)
    solve_full_model_robustness(spec_vec{i});
end

run making_tableB11.m;
