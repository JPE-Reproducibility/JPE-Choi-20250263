function [to_append,exsh_check,tau_l_vec,tau_k_vec,A_rel_vec,mu_l,mu_y] = compute_block_only_tau_l(mom, Par, markup,markdown)

% Parameter
rho = Par.rho;
sigma = Par.sigma;
eta = Par.eta;
theta = Par.theta;
gamma_L = Par.gamma_L;
gamma_K = Par.gamma_K;
gamma_M = Par.gamma_M;
gamma_j = gamma_L+gamma_K+gamma_M;

% Data
sale = mom.sale;
G_sale = mom.G_sale;
% G_K = mom.G_K;
% exsh = mom.exsh;
fasset = mom.fasset;
emp = mom.emp;
pi_H = mom.pi_H;
export = mom.export;
G_export = mom.G_export;
exsh = G_export / G_sale;
% pi_H = 1-exsh;
age_bin = mom.age_bin;
A_vec = mom.A_vec;
% G_export = G_sale * exsh;

tol = 1e-6; % Tolerance
dmp=0.25; % Damping factor
iter_max = 1e+5;

% % truncate if export share>0.8
% exsh_firm = export ./ sale;
% export(exsh_firm>0.8) = 0.8*sale(exsh_firm>0.8);

% Fringe firm sale and export
sale(end+1) = max(G_sale-sum(sale),0);
% fringe_share = sale(end)/sum(sale);

% % Guarantee fringe firm's minimum sale share as 1%
% if sale(end)/sum(sale)<0.01
%     disp("touched threshold")
%     sale(end)=sum(sale)*0.01;
% end

% % We adjust fringe firms' sale, otherwise the code may not converge
% % Guarantee fringe firm's minimum sale share as 0.01%
% if sale(end)/sum(sale)<0.0001
%     disp("touched threshold")
%     sale(end)=0.0001*sum(sale(1:end-1))/(1-0.0001);
% end
% 
% % Guarantee fringe firm's maximum sale share as 95%
% if sale(end)/sum(sale)>0.95
%     disp("touched threshold")
%     sale(end)=0.95*sum(sale(1:end-1))/(1-0.95);
% end

sale(end) = mom.fringe_share*sum(sale(1:end-1))/(1-mom.fringe_share);
export(end+1) = mom.fringe_share*sum(export(1:end))/(1-mom.fringe_share);
% export(end+1) = max(G_export-sum(export),0);

% % truncate if export share>0.9
% exsh_firm = export ./ sale;
% export(exsh_firm>0.9) = 0.9*sale(exsh_firm>0.9);

% Impute fringe firm's export using export share
% export(end+1) = sale(end)*exsh;
% Note that the sectoral export value will not change here (it will be adjusted later)

% % Correction when export resid share is too small(need to be changed later)
% if export(end)/sum(export) < 0.01
%     export(end) = sum(export) * 0.01;
% end

% % Correction when export resid share is too small(need to be changed later)
% if export(end)/sale(end) < exsh
%     export(end) = sale(end) * exsh;
% end

% export(end) = sale(end)*exsh;
% if export(end)<1e-5
%     export(end)=1e-5;
% end

% Domestic sale
sale_d = max(sale - export,0);

% % Correction (should be changed later)
% if sale_d(end)<=1e-5
%     export(end)=0.5*sale(end);
%     sale_d(end) = 0.5*sale(end);
% end

s_d = sale_d / sum(sale_d);
s_x = export / sum(export);

% % Truncate if s_x./s_y is too high
% ratio = s_x./s_y;
% s_x(ratio>5) = 5*s_y(ratio>5);
% % s_x(ratio>2) = 2*s_y(ratio>2);
% s_x = s_x/sum(s_x);
% export = s_x*sum(export);

% sale_d = sale-export;%
% s_y = sale_d/sum(sale_d);%

s_total = (sale_d+export) / (sum(sale_d)+sum(export));
% s_total = ones(length(s_total),1);
exsh_check = sum(export)/sum(sale);
% pi_H = 1-exsh_check;

epsil_y = (1/sigma+(1/rho-1/sigma).*s_d+(1-1/rho)*pi_H.*s_d).^(-1);
if markup==1
    mu_y = epsil_y./(epsil_y-1);
else
    mu_y = sigma / (sigma-1) * ones(length(epsil_y),1);
end
mu_y(end) = sigma/(sigma-1);

mu_x = sigma/(sigma-1) * ones(length(mu_y),1);
% ex = mu_y./mu_x.*export./sale_d;
Gamma_d = (sale_d./mu_y)./(sale_d./mu_y + export./mu_x);
% ex(end)=0;
mu_tilde = mu_y.* (1-export./sale) + mu_x .* export./sale;
% Equation (3.16)
% Solve for the vector of s_x using contraction mapping
diff=1;
x_guess = ones(length(s_d),1);
x_guess(export==0)=0;
iter=0;
while diff>tol && iter<iter_max
    x_next= D_iter(x_guess,s_x,s_d,mu_y,Gamma_d,sigma,gamma_j);
    diff = max(abs(x_next-x_guess))/max(abs(x_next));
    x_guess=x_next*dmp + x_guess*(1-dmp);
    iter=iter+1;
%     min(tau_next)
end
if iter==iter_max
    disp("Iteration reached threshold")
end
DF = x_guess;
norm_factor = DF(end);
DF = DF./norm_factor; % normalize fringe firms' DF = 1

% % Removing outliers
% DF(DF>10) = 10;

% Equation (3.14)
% Solve for the vector of tau_k and s_k_fringe using contraction mapping
diff=1;
x_guess = ones(length(s_d),1);
iter=0;
while diff>tol && iter<iter_max
    [x_next,s_k]= tau_k_iter(x_guess,s_d,fasset,mu_y,Gamma_d,s_total,mu_tilde);
    diff = max(abs(x_next-x_guess))/max(abs(x_next));
    x_guess=x_next*dmp + x_guess*(1-dmp);
    iter=iter+1;
%     min(tau_next)
end
if iter==iter_max
    disp("Iteration reached threshold")
end
tau_k = x_guess;
norm_factor=1/wmean(1./(mu_tilde.*tau_k),s_total);
% norm_factor = wmean(tau_k,s_total);
tau_k = tau_k/norm_factor;

% tau_k = tau_k / tau_k(end); % normalizing by fringe firm's wedge (sale-weighted average value)

% % Removing outliers
% diff=1;
% while diff>tol
%     tau_k(tau_k>10) = 10;
%     tau_k(tau_k<0.1) = 0.1;
%     tau_k(end) = wmean(tau_k(1:end-1),s_total(1:end-1));
%     % tau_k(end) = wmean(tau_k(1:end-1),s_k(1:end-1));
%     diff = abs(tau_k(end)-1);
%     tau_k = tau_k / tau_k(end); % normalizing by fringe firm's wedge (sale-weighted average value)
% end

% % Equation (3.13)
% % Solve for the vector of tau_l and s_l_fringe using contraction mapping
% diff=1;
% x_guess = ones(length(s_d),1);
% iter=0;
% while diff>tol && iter<iter_max
%     [x_next,~,mu_l]= tau_l_iter(x_guess,s_d,emp,mu_y,eta,theta,Gamma_d,s_total,mu_tilde,markdown);
%     diff = max(abs(x_next-x_guess))/max(abs(x_next));
%     x_guess=x_next*dmp + x_guess*(1-dmp);
%     iter=iter+1;
% end
% if iter==iter_max
%     disp("Iteration reached threshold")
% end
% tau_l = x_guess;
% norm_factor = 1/wmean(1./(mu_tilde.*mu_l.*tau_l),s_total);
% % norm_factor = wmean(tau_l,s_total);
% tau_l = tau_l / norm_factor; % normalizing by fringe firm's wedge (sale-weighted average value)
% 
% % tau_l = tau_l / tau_l(end); % normalizing by fringe firm's wedge (sale-weighted average value)
% 
% [~, s_l, mu_l] =  tau_l_iter(tau_l,s_d,emp,mu_y,eta,theta,Gamma_d,s_total,mu_tilde,markdown);

% Equation (3.12)
% Adjust tau_l to target s_d

diff=1;
tau_l_guess = ones(length(s_d),1);
iter=0;
while diff>tol && iter<iter_max
    [tau_l_next,~,mu_l]= tau_l_target_s_d(tau_l_guess,A_vec, Gamma_d,s_d,emp,mu_y,tau_k,sigma,eta,theta,gamma_L,gamma_K,gamma_j,markdown);
    diff = max(abs(tau_l_next-tau_l_guess))/max(abs(tau_l_next));
    % diff = norm(A_next-A_guess)
    tau_l_guess=tau_l_next*dmp + tau_l_guess*(1-dmp);
    iter=iter+1;
end
if iter==iter_max
    disp("Iteration reached threshold")
end
tau_l = tau_l_guess;
norm_factor = 1/wmean(1./(mu_tilde.*mu_l.*tau_l),s_total);
% norm_factor = wmean(tau_l,s_total);
tau_l = tau_l / norm_factor; % normalizing by fringe firm's wedge (sale-weighted average value)
[~, s_l, mu_l] =  tau_l_target_s_d(tau_l, A_vec, Gamma_d,s_d,emp,mu_y,tau_k,sigma,eta,theta,gamma_L,gamma_K,gamma_j,markdown);


% % Removing outliers
% A_next(A_next>10)=10;

tau_l_vec = tau_l;
tau_k_vec = tau_k;
A_rel_vec = [A_vec;1];
DF_vec = DF;
            
to_append = array2table([mom.firmid mom.year s_total s_d s_k s_l A_rel_vec tau_l_vec tau_k_vec mu_y, mu_l, DF_vec, mom.secid, age_bin],...
        'VariableNames', {'firmid', 'year', 's_total','s_y', 's_k', 's_l', 'A','tau_l','tau_k', 'mu_y','mu_l','DF','secid','age_bin'});
