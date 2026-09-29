function [tau_l_next, s_l, mu_l] = tau_l_target_s_d(tau_l,A_vec,Gamma_d,s_d,emp,mu_y,tau_k,sigma,eta,theta,gamma_L,gamma_K,gamma_j,markdown)
    % Given tau_l, compute mu_l and s_l
    diff=1;
    s_l_guess = s_d;
    iter=0;
    dmp = 0.25;
    while diff>1e-8 && iter<1e+5
        [s_l_next,mu_l] = s_l_iter(s_l_guess,  tau_l, s_d, Gamma_d, mu_y, emp, eta, theta,markdown);
        diff = norm(s_l_next-s_l_guess)/norm(s_l_next+s_l_guess);
        s_l_guess=s_l_next*dmp + s_l_guess*(1-dmp);
        iter=iter+1;
    end
    s_l = s_l_guess;
    
    X = -gamma_j / ( sigma/(sigma-1)-gamma_j );
    A = [A_vec;1];
    tau_l_next =( (s_d(1:end-1)...
        *sum( ( A.^(-1/gamma_j).*mu_y.*(mu_l.*tau_l.*(s_l.^(1/(eta+1)))).^(gamma_L/gamma_j)...
        .*tau_k.^(gamma_K/gamma_j).*Gamma_d.^((gamma_j-1)/gamma_j)).^X ) ).^(1/X)...
        ./( A(1:end-1).^(-1/gamma_j).*mu_y(1:end-1).*(tau_k(1:end-1)).^(gamma_K/gamma_j).*Gamma_d(1:end-1).^((gamma_j-1)/gamma_j) ) ).^(gamma_j/gamma_L)...
        ./ (mu_l(1:end-1).*s_l(1:end-1).^(1/(1+eta)));
    tau_l_next(end+1)=1;
end

% 1/(1+ex) = Gamma

% s_y_check=( ( [A;1].^(-1/gamma_j).*mu_y.*(mu_l.*tau_l).^(gamma_L/gamma_j).*tau_k.^(gamma_K/gamma_j)...
%         .*s_l.^(gamma_L/(gamma_j*(eta+1))).*(1+ex).^((1-gamma_j)/gamma_j) ).^X )./...
%  sum( ( [A;1].^(-1/gamma_j).*mu_y.*(mu_l.*tau_l).^(gamma_L/gamma_j).*tau_k.^(gamma_K/gamma_j)...
%         .*s_l.^(gamma_L/(gamma_j*(eta+1))).*(1+ex).^((1-gamma_j)/gamma_j) ).^X );