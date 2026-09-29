function [x_next, s_l, mu_l] = tau_l_iter(x,s_d,emp,mu_y,eta,theta,Gamma_d,s_total,mu_tilde,markdown)

    tau_l = x;
%     options = optimset('Display','off');
%     s_l_fringe = fsolve(@(s) s_fringe_iter(s, tau_l, s_y, ex, mu_y, emp, eta, theta,markdown), s_y(end),options);
    % Gamma_d = (1./(1+ex));
    diff=1;
    x_guess = s_d(end);
    iter=0;
    dmp = 0.25;
    while diff>1e-8 && iter<1e+5
        x_next= s_fringe_iter(x_guess, tau_l, s_d, Gamma_d, mu_y, emp, eta, theta,markdown);
        diff = norm(x_next-x_guess)/norm(x_next+x_guess);
        x_guess=x_next*dmp + x_guess*(1-dmp);
        iter=iter+1;
    end
    [~,s_l,mu_l] = s_fringe_iter(x_guess, tau_l, s_d, Gamma_d, mu_y, emp, eta, theta,markdown);

    tau_l_next = s_d(1:end-1)./Gamma_d(1:end-1)./( mu_y(1:end-1).*mu_l(1:end-1).*s_l(1:end-1)...
        *sum(s_d./Gamma_d./(mu_y .* tau_l .* mu_l ) ) );
    tau_l_next(end+1)=1;
    % tau_l_next(end+1) = 1/wmean(1./(mu_tilde(1:end-1).*mu_l(1:end-1).*tau_l_next),s_total(1:end-1));
    % tau_l_next(end+1) = wmean(tau_l_next,s_total(1:end-1));
   % tau_l_next(end+1) = wmean(tau_l_next,s_l(1:end-1));

    x_next = tau_l_next;

end