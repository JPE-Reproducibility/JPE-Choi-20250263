function [to_append,exsh_check,tau_l_vec,tau_k_vec,A_rel_vec,mu_l,mu_y] = compute_block(mom, Par, markup,markdown)

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
fasset = mom.fasset;
emp = mom.emp;
% pi_H = 1-mom.pi_H; % Domestic share
pi_H = mom.pi_H;
export = mom.export;
G_export = mom.G_export;
exsh = G_export / G_sale;
age_bin = mom.age_bin;

tol = 1e-6; % Tolerance
dmp=0.25; % Damping factor
iter_max = 1e+5;

sale(end+1) = max(G_sale-sum(sale),0);


sale(end) = mom.fringe_share*sum(sale(1:end-1))/(1-mom.fringe_share);
export(end+1) = mom.fringe_share*sum(export(1:end))/(1-mom.fringe_share);

% Domestic sale
sale_d = max(sale - export,0);

s_d = sale_d / sum(sale_d);
s_x = export / sum(export);

s_total = (sale_d+export) / (sum(sale_d)+sum(export));
exsh_check = sum(export)/sum(sale);

epsil_y = (1/sigma+(1/rho-1/sigma).*s_d+(1-1/rho)*pi_H.*s_d).^(-1);
if markup==1
    mu_y = epsil_y./(epsil_y-1);
else
    mu_y = sigma / (sigma-1) * ones(length(epsil_y),1);
end
mu_y(end) = sigma/(sigma-1);

mu_x = sigma/(sigma-1) * ones(length(mu_y),1);
Gamma_d = (sale_d./mu_y)./(sale_d./mu_y + export./mu_x);
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
end
if iter==iter_max
    disp("Iteration reached threshold")
end
DF = x_guess;
norm_factor = DF(end);
DF = DF./norm_factor; % normalize fringe firms' DF = 1


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
end
if iter==iter_max
    disp("Iteration reached threshold")
end
tau_k = x_guess;
norm_factor=1/wmean(1./(mu_tilde.*tau_k),s_total);
tau_k = tau_k/norm_factor;

% Equation (3.13)
% Solve for the vector of tau_l and s_l_fringe using contraction mapping
diff=1;
x_guess = ones(length(s_d),1);
iter=0;
while diff>tol && iter<iter_max
    [x_next,~,mu_l]= tau_l_iter(x_guess,s_d,emp,mu_y,eta,theta,Gamma_d,s_total,mu_tilde,markdown);
    diff = max(abs(x_next-x_guess))/max(abs(x_next));
    x_guess=x_next*dmp + x_guess*(1-dmp);
    iter=iter+1;
end
if iter==iter_max
    disp("Iteration reached threshold")
end
tau_l = x_guess;
norm_factor = 1/wmean(1./(mu_tilde.*mu_l.*tau_l),s_total);
tau_l = tau_l / norm_factor; % normalizing by fringe firm's wedge (sale-weighted average value)

[~, s_l, mu_l] =  tau_l_iter(tau_l,s_d,emp,mu_y,eta,theta,Gamma_d,s_total,mu_tilde,markdown);

% Equation (3.12)
% Solve for the vector of A using contraction mapping

diff=1;
A_guess = ones(length(s_d)-1,1);
iter=0;
while diff>tol && iter<iter_max
    A_next= A_iter(A_guess,Gamma_d,s_d,s_l,mu_y,mu_l,tau_l,tau_k,sigma,eta,gamma_L,gamma_K,gamma_j);
    diff = max(abs(A_next-A_guess))/max(abs(A_next));
    A_guess=A_next*dmp + A_guess*(1-dmp);
    iter=iter+1;
end
if iter==iter_max
    disp("Iteration reached threshold")
end

tau_l_vec = tau_l;
tau_k_vec = tau_k;
A_rel_vec = [A_next;1];
DF_vec = DF;
            
to_append = array2table([mom.firmid mom.year s_total s_d s_k s_l A_rel_vec tau_l_vec tau_k_vec mu_y, mu_l, DF_vec, mom.secid, age_bin],...
        'VariableNames', {'firmid', 'year', 's_total','s_y', 's_k', 's_l', 'A','tau_l','tau_k', 'mu_y','mu_l','DF','secid','age_bin'});
    
