clear; clc;  
 
%% Set directory 
matlab_dir = fileparts(mfilename('fullpath'));   % .../Replication_JPE/MATLAB_PROD_FUNC
if isempty(matlab_dir)
    matlab_dir = pwd;                            % fallback: run from Command Window
end
project_root = fileparts(matlab_dir);            % .../Replication_JPE

cd(project_root);
addpath(matlab_dir);
addpath(fullfile(project_root, 'INPUT'));
addpath(fullfile(project_root, 'OUTPUT'));

%% Importing data
rawdata =  table2array(readtable('DKLmu.csv')); 
J = size(unique(rawdata(:, 1)), 1); 

%% Basline estimation procedure: time-invarying
secid = zeros(J, 1); 
vcoef = zeros(J, 1);
kcoef = zeros(J, 1);

for jjj = 1:J
    mmobj = @(x) dleu(x, jjj, rawdata); 
    theta0 = [0.9, 0.1]; 
    lb = [0.01 0.01]; 
    options = optimset('Display', 'off');
    [theta, fval] = fmincon(mmobj, theta0, [], [], [], [], lb, [], [], options);
    vcoef(jjj) = theta(1);
    kcoef(jjj) = theta(2);
    secid(jjj) = jjj; 
    
    disp(strcat('Done: Sector', num2str(jjj)));
end

result = horzcat(secid, vcoef, kcoef); 
filename = 'OUTPUT/DLcoefs.xlsx';
sheetname = 'Baseline';
writematrix(result, filename, 'Sheet', sheetname);

 
%% Rolling over 5-year average 
miny = min(rawdata(:, 3));
maxy = max(rawdata(:, 3));
roly_list = [5];

for roly = roly_list 
    secid = zeros(J * (maxy - roly + 1), 1);
    years = zeros(J * (maxy - roly + 1), 1);
    vcoef = zeros(J * (maxy - roly + 1), 1);
    kcoef = zeros(J * (maxy - roly + 1), 1); 

    for jjj = 1:J
        for ttt = [1:maxy - roly + 1]
            mmobj = @(x) dleurolling(x, jjj, rawdata, ttt, roly); 
            theta0 = [0.9, 0.1]; 
            lb = [0.01 0.01]; 
            options = optimset('Display', 'off');
            [theta, fval] = fmincon(mmobj, theta0, [], [], [], [], lb, [], [], options);

            iii = (jjj - 1) * (maxy - roly + 1) + ttt; 
            vcoef(iii) = theta(1);
            kcoef(iii) = theta(2);
            secid(iii) = jjj;     
            years(iii) = ttt;

            if ttt == maxy - roly + 1
                disp(strcat('Done: Rolling', num2str(roly), '-Sector', num2str(jjj)));
            end
        end
    end

    resultrolling = horzcat(secid, years, vcoef, kcoef); 
    filename = 'OUTPUT/DLcoefs.xlsx';
    sheetname = num2str('Rolling', num2str(roly));
    writematrix(resultrolling, filename, 'Sheet', sheetname);
end


