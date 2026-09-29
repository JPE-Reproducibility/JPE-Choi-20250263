function [s_l_fringe_next,s_l,mu_l] = s_fringe_iter(s_l_fringe, tau_l, s_y, Gamma_d, mu_y, emp, eta, theta,markdown )
% Gamma_d = (1./(1+ex));
s_l = [emp.^((eta+1)/eta)/sum(emp.^((eta+1)/eta)) * (1-s_l_fringe) ; s_l_fringe];

if markdown==1
    epsil_l = (1/eta+(1/theta-1/eta).*s_l).^(-1);
else
    epsil_l = eta*ones(length(s_l),1);
end

mu_l = (epsil_l+1) ./ epsil_l;
mu_l(end) = (eta+1) / eta;

s_l_fringe_next = s_y(end)/Gamma_d(end)/(mu_y(end)*tau_l(end)*mu_l(end)) ...
    / sum( s_y./Gamma_d./(mu_y.*tau_l.*mu_l) );
% diff = abs(s_l_fringe - s_l_fringe_next);

end

