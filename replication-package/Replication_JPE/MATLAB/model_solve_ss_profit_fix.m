function [x_next,ratio_next,ratio_diff,Y,P,K,R,tau_k_wtd_avg,tau_l_wtd_avg,A_j] = model_solve_ss_profit_fix(x_guess,ratio_guess,Par, mom, shock_firm, shock_agg, markup, markdown)

secid_manu = mom.secid_manu;
pi_avg_sector_given = shock_agg.pi_avg_sector_given(:);
x_guess = x_guess(:);
ratio_guess = ratio_guess(:);
shock_firm.A_fj_vec = shock_firm.A_fj_vec(:);
shock_firm.fringe_vec = shock_firm.fringe_vec(:);

shock_firm.A_fj_vec(shock_firm.fringe_vec) = ratio_guess.*shock_firm.A_fj_vec(shock_firm.fringe_vec);
    
iter = 0;
diff = 10;
dmp = 0.05;
dmp_small = 0.025;
diff_previous = Inf;
total_firm = sum(mom.firm_num);

while diff > 1e-4 && iter<1e+4
    x_next = model_solve_ss(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff = model_relative_residual(x_next,x_guess);
    [dmp,dmp_small] = model_adapt_damping(...
        dmp,dmp_small,diff,diff_previous);
    x_guess = model_damped_update(x_next,x_guess,total_firm,...
        dmp,dmp_small,'model_solve_ss_profit_fix');
    diff_previous = diff;
    iter = iter+1;
    if mod(iter,500)==0
        fprintf('[fast:profit:ss-inner] iteration=%d residual=%.3e\n',...
            iter,diff);
    end
end
[~,Y,P,K,R,L,tau_k_wtd_avg,tau_l_wtd_avg,A_j,pi_avg_sector] = model_solve_ss(x_guess, Par, mom, shock_firm, shock_agg, markup, markdown);

if iter==1e+4 && diff>1e-4
    warning('model_solve_ss_profit_fix:NoConvergence',...
        'The inner steady-state solve reached its iteration limit.');
end


ratio_next = (pi_avg_sector(secid_manu)./pi_avg_sector_given(secid_manu)).*ratio_guess;
ratio_diff = norm((pi_avg_sector(secid_manu)./pi_avg_sector_given(secid_manu)) - 1); % For now, ignore the case when pi decreased


end
