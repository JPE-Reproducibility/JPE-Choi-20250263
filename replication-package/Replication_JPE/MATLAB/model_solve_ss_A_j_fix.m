function [diff_A_j,A_j_level_next,x_guess,Y,P,K,R,tau_k_wtd_avg,tau_l_wtd_avg,A_j] = model_solve_ss_A_j_fix(x_guess,A_j_level_guess,A_j_level_target,Par, mom, shock_firm, shock_agg, markup, markdown)

num_sector = length(mom.firm_num);
firm_num = mom.firm_num(:);
secid_manu = mom.secid_manu;
x_guess = x_guess(:);
A_j_level_guess = A_j_level_guess(:);
A_j_level_target = A_j_level_target(:);
shock_firm.A_fj_vec = shock_firm.A_fj_vec(:);
shock_firm.top3_vec = shock_firm.top3_vec(:);

shock_firm.A_fj_vec(~shock_firm.top3_vec) = repelem(A_j_level_guess,[firm_num(secid_manu)-3 ...
    ;ones(num_sector-length(secid_manu),1)]).*shock_firm.A_fj_vec(~shock_firm.top3_vec);
    % shock_firm.tau_l_vec = shock_firm.tau_l_vec;
    
iter = 0;
diff = 10;
dmp = 0.05;
dmp_small = 0.025;
diff_previous = Inf;
total_firm = sum(firm_num);

while diff > 1e-4 && iter<1e+4
    x_next = model_solve_ss(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff = model_relative_residual(x_next,x_guess);
    [dmp,dmp_small] = model_adapt_damping(...
        dmp,dmp_small,diff,diff_previous);
    x_guess = model_damped_update(x_next,x_guess,total_firm,...
        dmp,dmp_small,'model_solve_ss_A_j_fix');
    diff_previous = diff;
    iter = iter+1;
    if mod(iter,500)==0
        fprintf('[fast:A_j:ss-inner] iteration=%d residual=%.3e\n',iter,diff);
    end
end
[~,Y,P,K,R,L,tau_k_wtd_avg,tau_l_wtd_avg,A_j] = model_solve_ss(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);

if iter==1e+4 && diff>1e-4
    warning('model_solve_ss_A_j_fix:NoConvergence',...
        'The inner steady-state solve reached its iteration limit.');
end


diff_A_j = max(abs(A_j_level_target-A_j) );
A_j_level_next  = A_j_level_guess.*A_j_level_target./A_j;


end
