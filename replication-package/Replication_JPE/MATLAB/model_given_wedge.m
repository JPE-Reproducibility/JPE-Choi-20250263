function [diff_tau,tau_level_next,x_guess] = model_given_wedge(tau_level_guess,tau_level_target,x_guess,Par, mom, shock_firm, shock_agg, year, result_pre,markup, markdown)
num_sector = length(mom.firm_num);

tau_k_level_guess = tau_level_guess(1:num_sector);
tau_l_level_guess = tau_level_guess(num_sector+1:2*num_sector);

shock_firm.tau_k_vec = shock_firm.tau_k_vec.*repelem(tau_k_level_guess,mom.firm_num);
shock_firm.tau_l_vec = shock_firm.tau_l_vec.*repelem(tau_l_level_guess,mom.firm_num);

iter = 0;
diff = 10;
dmp=0.025;

while diff > 1e-4 && iter<1e+4
    [x_next] = model_given_shock(x_guess, Par, mom, shock_firm, shock_agg, year, result_pre,...
        0, markup, markdown);
    % diff = max(abs(x_next-x_guess) ./ abs(x_guess) ) + norm(x_next(end)-x_guess(end));
    diff = norm(x_next-x_guess);
    x_guess = dmp*x_next+(1-dmp)*x_guess;
    iter = iter+1;
end
if iter>1e+4
disp("maximum iteration reached")
end

[~, ~,~, ~, ~, ~, ~,~,~,~,~,~,~,~,~,~,~,~,~, tau_k_wtd_avg, tau_l_wtd_avg]...
    = model_given_shock(x_guess, Par, mom, shock_firm, shock_agg, year, result_pre,...
        0, markup, markdown);

diff_tau = max(abs(tau_level_target-[tau_k_wtd_avg; tau_l_wtd_avg]) );

tau_level_next  = tau_level_guess.*[tau_k_wtd_avg; tau_l_wtd_avg]./tau_level_target;
