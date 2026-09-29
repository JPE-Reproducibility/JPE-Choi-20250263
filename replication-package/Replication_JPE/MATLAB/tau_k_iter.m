function [x_next,s_k] = tau_k_iter(x,s_d,fasset,mu_y,Gamma_d,s_total,mu_tilde)

    tau_k = x;
%     s_k_fringe = x(end);
    % Gamma_d = (1./(1+ex));
    s_k_fringe = s_d(end)/Gamma_d(end)/(mu_y(end)*tau_k(end))...
        /sum(s_d./Gamma_d./ (mu_y .* tau_k));
    s_k = fasset/sum(fasset)*(1-s_k_fringe);
    s_k(end+1) = s_k_fringe; % sum(s_k) should be one
    
    tau_k_next = s_d(1:end-1)./Gamma_d(1:end-1)./(mu_y(1:end-1).*s_k(1:end-1)...
        *sum(s_d./Gamma_d./(mu_y .* tau_k)) );
    tau_k_next(end+1)=1;
    % tau_k_next(end+1) = 1/wmean(1./(mu_tilde(1:end-1).*tau_k_next),s_total(1:end-1)); 

    % tau_k_next = s_y./Gamma_d./(mu_y.*s_k...
    %     *sum(s_y./Gamma_d./(mu_y .* tau_k)) );

    % Sale weighted average wedge = fringe firm's wedge
    % tau_k_next(end+1) = wmean(tau_k_next,s_total(1:end-1)); 
    % tau_k_next(end+1) = wmean(tau_k_next,s_k(1:end-1)); 

    x_next = tau_k_next;

end
