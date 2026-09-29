function ret = prod_obj_sep_ar1(theta0, betam0, sig0, rho0, dt, p, IVtype, est)
 
    id_list = unique(dt(:, 2));
 
    rd = dt(:, 4);
    l = dt(:, 5);
    k = dt(:, 6); 
    m = dt(:, 7); 
    Y = dt(:, 8);
    Yd = dt(:, 9);
    Hsh = dt(:, 10); 
    s = dt(:, 11);
    sd = dt(:, 12); 
    sL = dt(:, 13);
    sx = dt(:, 14);
    wb = dt(:, 15);
 
    % Export correction term
    eps = ((1/sig0)  + (1/rho0 - 1/sig0) .* sd + (1 - 1/rho0) .* Hsh .* sd).^(-1);
    
    muH = eps ./ (eps - 1); % Domestic markup
    muF = sig0 ./ (sig0 - 1); % Foreign markup
    r = dt(:, 18); 
 
    Lambda = ((exp(rd) ./ muH) ./ (exp(rd) ./ muH + (exp(r) - exp(rd)) ./ muF));
    Lambdax = 1 - Lambda; 
    clear muF muH eps 
 
    dt(:, 18) = Lambda; 

    D = dummyvar(dt(:, 3));
    D = D(:, 1:end - 1);
 
    %% Step 2: Contrl function approach
    y = rd - betam0 .* m ;
    N = size(dt, 1);
    
    if est == 1 || est == 2
        n = 7; % Number of variables/features
     
        vars = cell(n,1);
        [vars{1:n}] = ndgrid(0:p);
        exp_comb = reshape(cat(n+1, vars{:}), [], n);
        exp_comb = exp_comb(sum(exp_comb,2) <= p & sum(exp_comb,2) > 0, :);
     
        X = horzcat(l, k, m, Yd, Hsh, sd, sL);
        Xp = zeros(N, size(exp_comb, 1));
        for ppp = 1:size(exp_comb, 1)
           expc = exp_comb(ppp, :);
           Xp(:, ppp) =  prod(X.^(expc), 2);
        end
     
        Xp = horzcat(ones(N, 1), Xp);
        b = lsqminnorm(Xp, y);
        yhat = Xp * b;
    elseif est >= 3
        n = 8; % Number of variables/features
     
        vars = cell(n,1);
        [vars{1:n}] = ndgrid(0:p);
        exp_comb = reshape(cat(n+1, vars{:}), [], n);
        exp_comb = exp_comb(sum(exp_comb,2) <= p & sum(exp_comb,2) > 0, :);
     
        X = horzcat(l, k, m, Yd, Hsh, sd, sL, Lambda);
        Xp = zeros(N, size(exp_comb, 1));
        for ppp = 1:size(exp_comb, 1)
           expc = exp_comb(ppp, :);
           Xp(:, ppp) =  prod(X.^(expc), 2);
        end
     
        Xp = horzcat(ones(N, 1), Xp);
        b = lsqminnorm(Xp, y);
        yhat = Xp * b;
    end
 
    % 15th column yhat. 
    dt = horzcat(dt, yhat);
    L1yhat = horzcat(dt(:, 1:18), yhat);

    % Generate lagged variables 
    for i = 1:length(id_list)
        id = id_list(i);
        temp = dt(dt(:, 2) == id, :);
        temp = temp(2:end, :); 

        temp1 = L1yhat(L1yhat(:, 2) == id, :);
        temp1 = temp1(1:end - 1, :);
 
        temp = horzcat(temp, temp1(:, 4:19));
        if i == 1
            dt_new = temp;
        elseif i > 1
            dt_new = vertcat(dt_new, temp); 
        end
    end
 
    rd = dt_new(:, 4);
    l = dt_new(:, 5);
    k = dt_new(:, 6); 
    m = dt_new(:, 7); 
    Y = dt_new(:, 8);
    Yd = dt_new(:, 9); 
    Hsh = dt_new(:, 10);
 
    D = dummyvar(dt_new(:, 3));
    D = D(:, 1:end - 1);

    exterm = log(dt_new(:, 18)); 
    L1exterm = log(dt_new(:, end - 1));
 
    yhat = dt_new(:, 19); 
    L1yhat = dt_new(:, end);
 
    L1rd = dt_new(:, 20);
    L1l = dt_new(:, 21);
    L1k = dt_new(:, 22); 
    L1m = dt_new(:, 23); 
    L1Y = dt_new(:, 24);
    L1Yd = dt_new(:, 25); 
  
    a =  (yhat -  theta0(1) * l - theta0(2) * k  - (1/sig0) .* Yd - ((sig0 - 1)/ sig0) .* exterm);
    L1a =  (L1yhat -  theta0(1) * L1l -  theta0(2) * L1k - (1/sig0) .* L1Yd - ((sig0 - 1)/ sig0) .* L1exterm);  % 
    L1a2 = (L1a).^2; 
    L1a3 = (L1a).^3;
    L1a4 = (L1a).^4;
    L1a5 = (L1a).^5;
 
    % IV 
 
    if p == 3
        if IVtype == 3
            Z = horzcat(L1l, L1k, L1a, L1a2, L1a3, ones(size(L1l)));
        elseif IVtype == 5
            Z = horzcat(L1l, L1k, L1a, L1a2, L1a3, L1m, ones(size(L1l)));
        end
        xi = a - theta0(3) * L1a - theta0(4) * L1a2 - theta0(5) * L1a3 - theta0(6);
    elseif p == 2
        if IVtype == 3
            Z = horzcat(L1l, L1k, L1a, L1a2, ones(size(L1l)));
        elseif IVtype == 5
            Z = horzcat(L1l, L1k, L1a, L1a2, L1m, ones(size(L1l)));
        end
        xi = a - theta0(3) * L1a - theta0(4) * L1a2 - theta0(5);    
    elseif p == 1
        if IVtype == 3
            Z = horzcat(L1l, L1k, L1a, ones(size(L1m)));
        elseif IVtype == 5
            Z = horzcat(L1l, L1k, L1a, L1m, ones(size(L1m)));
        end
        xi = a - theta0(3) * L1a - theta0(4);    
    end        


    % Moments
    nnn = size(dt_new, 1);
    mom = Z' * xi / nnn;
    W = eye(length(mom));
    ret = (mom'*W*mom); 
end
