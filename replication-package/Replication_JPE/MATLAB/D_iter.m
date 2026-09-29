function DF_next = D_iter(DF,s_x,s_d,mu_y,Gamma_d,sigma,gamma_j)
    DF_next = zeros(length(DF),1);
    sample = find(s_x>0);
    s_x = s_x(sample);
    s_d = s_d(sample);
    mu_y = mu_y(sample);
    % ex = ex(sample);
    Gamma_d = Gamma_d(sample);
    DF = DF(sample);
    mu_x = sigma/(sigma-1);
    X = -gamma_j / ( sigma/(sigma-1)-gamma_j );
    % DF_next(sample) = ...
    %     ((s_x.*sum(s_d.*(1./mu_y.*((1-Gamma_d)./Gamma_d).^((gamma_j-1)/gamma_j)...
    %     .*DF.^(1/(gamma_j*(1-sigma)))).^X)./s_d).^(1/X)...
    %     .*(mu_y.*((1-Gamma_d)./Gamma_d).^(-(gamma_j-1)/gamma_j))).^(gamma_j*(1-sigma));
    DF_next(sample) = s_x.*sum(s_d.*(mu_x./mu_y).^(1-sigma).*DF)./(s_d.*((mu_x./mu_y).^(1-sigma)));
end
