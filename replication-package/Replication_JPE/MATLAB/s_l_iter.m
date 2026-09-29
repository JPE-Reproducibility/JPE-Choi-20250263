function [s_l_next,mu_l] = s_l_iter(s_l_guess, tau_l, s_d, Gamma_d, mu_y, emp, eta, theta,markdown )

% Given tau_l and s_l_guess, compute s_l_next
s_l = s_l_guess;
if markdown==1
    epsil_l = (1/eta+(1/theta-1/eta).*s_l).^(-1);
else
    epsil_l = eta*ones(length(s_l),1);
end

mu_l = (epsil_l+1) ./ epsil_l;
mu_l(end) = (eta+1) / eta;

s_l_next = s_d./Gamma_d./(mu_y.*tau_l.*mu_l) ...
    / sum( s_d./Gamma_d./(mu_y.*tau_l.*mu_l) );

end

