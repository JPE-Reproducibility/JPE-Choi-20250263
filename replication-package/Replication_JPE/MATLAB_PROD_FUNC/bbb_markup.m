function betam0 = bbb_markup(dt, dt_full, sigma0, rho0, est)
    % For exporter sample, due to small number of observations, use the
    % full sample when estimating beta_m
    if est == 5 
        tdt = dt_full;
    else
        tdt = dt;
    end
    rd = tdt(:, 4);
    l = tdt(:, 5);
    k = tdt(:, 6); 
    m = tdt(:, 7); 
    Y = tdt(:, 8);
    Yd = tdt(:, 9);
    Hsh = tdt(:, 10); 
    s = tdt(:, 11);
    sd = tdt(:, 12);
    sL = tdt(:, 13);
    sx = tdt(:, 14);
    wb = tdt(:, 15);
    mratio = tdt(:, 16); 
    r = tdt(:, 18);
 
    eps = (1/sigma0 + (1/rho0 - 1/sigma0) .* sd + (1 - 1/rho0) .*sd .* Hsh).^(-1);
    muH = eps ./ (eps - 1); 
    muF = sigma0 / (sigma0 - 1);

    % Quantity share
    ysh = (exp(rd) ./ muH) ./ (exp(rd) ./ muH + (exp(r) - exp(rd)) ./ muF); 
    mu_tilde = muH .* ysh + muF .* (1 - ysh);
 
    temp = (1 ./ muF) .* ((mratio .* exp(r)) ./ (exp(rd) ./ muH  + (exp(r) - exp(rd)) ./ muF)); 
 
    betam0 = mean(temp);
    disp(strcat('Betam :', num2str(betam0)));
end
