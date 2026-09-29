
function ret = dleurolling(theta0, jjj, rawdata, ttt, roly)
    % Subset of firms whose industry code is jjj 
    data = rawdata(rawdata(:, 1) == jjj, :) ;  
    id_list = unique(data(:, 2));
    
    data = data(data(:, 3) >= ttt, :);
    data = data(data(:, 3) <= ttt + roly - 1, :);
    
    r = data(:, 4); 
    k = data(:, 5);
    v = data(:, 6);
 
    v3 = v.^3;
    v2 = v.^2;
    v1 = v; 
    k1 = k;
    k2 = k.^2;
    k3 = k.^3; 
    v1k1 = v .* k; 
    v1k2 = v .* k.^2; 
    v2k1 = v.^2 .* k;
    
    Xp = horzcat(ones(length(v), 1), v1, k1, v2, k2, v1k1, v3, k3, v1k2, v2k1);
    b = regress(r, Xp);
    phi = Xp * b;    
    resid = r - phi; 
    
    dt = horzcat(data, phi, resid);

     % Generate lagged variables 
    for i = 1:length(id_list)
        id = id_list(i);
        temp = dt(dt(:, 2) == id, :);
        temp = temp(2:end, :); 

        temp1 = dt(dt(:, 2) == id, :);
        temp1 = temp1(1:end - 1, :);

        temp = horzcat(temp, temp1(:, 4:8));
        if i == 1
            dt_new = temp;
        elseif i > 1
            dt_new = vertcat(dt_new, temp); 
        end
    end
    
    r = dt_new(:, 4); 
    k = dt_new(:, 5);
    v = dt_new(:, 6); 
    phi = dt_new(:, 7); 
 
    L1r = dt_new(:, 9);
    L1k = dt_new(:, 10);
    L1v = dt_new(:, 11); 
    L1phi = dt_new(:, 12); 
 
    % IV 
    Z = horzcat(L1v, k);
    
    % Productivity
    a = phi - theta0(1) * v - theta0(2) * k;
    L1a = L1phi - theta0(1) * L1v - theta0(2) * L1k;
    L1a2 = (L1a).^2; 
    L1a3 = (L1a).^3;

    X = horzcat(ones(length(L1a), 1), L1a, L1a2, L1a3);
    y = a;
    
    nnn = size(dt_new, 1);
    
    % Innovtations of productivity process 
    ba = regress(y, X); 
    
    xi = y - X * ba;
    mom = (Z' * xi) / nnn;
 
    % Moment conditions
    W = eye(length(mom)); 
    ret = (mom'*W*mom); 
end