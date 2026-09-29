function [diff_tau,tau_level_next,x_guess] = model_until_ss_tau(x_guess,tau_level_guess,tau_level_target,K,Par, mom, shock_firm, shock_agg, markup, markdown, type)
firm_num = mom.firm_num(:);
num_sector = length(firm_num);
x_guess = x_guess(:);
tau_level_guess = tau_level_guess(:);
tau_level_target = tau_level_target(:);
shock_firm.tau_k_vec = shock_firm.tau_k_vec(:);
shock_firm.tau_l_vec = shock_firm.tau_l_vec(:);

if type==1
    tau_k_level_guess = tau_level_guess;
    shock_firm.tau_k_vec = shock_firm.tau_k_vec.*repelem(tau_k_level_guess,firm_num);
elseif type==2
    tau_l_level_guess = tau_level_guess;
    shock_firm.tau_l_vec = shock_firm.tau_l_vec.*repelem(tau_l_level_guess,firm_num);
elseif type==3
    tau_k_level_guess = tau_level_guess(1:num_sector);
    tau_l_level_guess = tau_level_guess(num_sector+1:end);
    shock_firm.tau_k_vec = shock_firm.tau_k_vec.*repelem(tau_k_level_guess,firm_num);
    shock_firm.tau_l_vec = shock_firm.tau_l_vec.*repelem(tau_l_level_guess,firm_num);
end

    % shock_firm.tau_l_vec = shock_firm.tau_l_vec;
    
iter = 0;
diff = 10;
dmp = 0.05;
dmp_small = 0.025;
diff_previous = Inf;
total_firm = sum(firm_num);

while diff > 1e-4 && iter<1e+4
    x_next = model_until_ss(x_guess, K, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff = model_relative_residual(x_next,x_guess);
    [dmp,dmp_small] = model_adapt_damping(...
        dmp,dmp_small,diff,diff_previous);
    x_guess = model_damped_update(x_next,x_guess,total_firm,...
        dmp,dmp_small,'model_until_ss_tau');
    diff_previous = diff;
    iter = iter+1;
    if mod(iter,500)==0
        fprintf('[fast:tau:transition-inner] iteration=%d residual=%.3e\n',...
            iter,diff);
    end
end

if iter==1e+4 && diff>1e-4
    warning('model_until_ss_tau:NoConvergence',...
        'The inner transition solve reached its iteration limit.');
end

if type==1
    [~, ~,~, ~, ~,tau_k_wtd_avg,~]...
        = model_until_ss(x_guess, K, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff_tau = max(abs(tau_level_target-tau_k_wtd_avg) );
    tau_level_next  = tau_level_guess.*tau_k_wtd_avg./tau_level_target;
elseif type==2
    [~, ~,~, ~, ~,~,tau_l_wtd_avg]...
        = model_until_ss(x_guess, K, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff_tau = max(abs(tau_level_target-tau_l_wtd_avg) );
    tau_level_next  = tau_level_guess.*tau_l_wtd_avg./tau_level_target;
elseif type==3
    [~, ~,~, ~, ~,tau_k_wtd_avg,tau_l_wtd_avg]...
        = model_until_ss(x_guess, K, Par, mom, shock_firm, shock_agg, markup, markdown);
    diff_tau = max(abs(tau_level_target-[tau_k_wtd_avg; tau_l_wtd_avg]) );
    tau_level_next  = tau_level_guess.*[tau_k_wtd_avg; tau_l_wtd_avg]./tau_level_target;
end

end
