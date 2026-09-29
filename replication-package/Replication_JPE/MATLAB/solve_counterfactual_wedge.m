function [lmd,delta,welfare,CR3_vec,HHI_vec,util_vec,GDP_vec,agg_result,result_final]...
    = solve_counterfactual_wedge(result,result_agg,est_result,Par,data,markup,markdown,x_guess_cell,tau_k_wtd_avg_mat,tau_l_wtd_avg_mat)

intsh = data.intsh;
pop_data = data.pop_data;
balance = data.balance;
% fcons = data.fcons;
K_hat = data.K_hat;
num_sector = data.num_sector;
secid_service = data.secid_service;
secid_full = data.secid_full;
secid_manu = data.secid_manu;
eta = Par.eta;
alpha_j_mat = data.alpha_j_mat;
GO = data.GO;
hour_data = data.hour_data;

% top3_list_base = data.top3_list;

year_vec = (min(balance.year):1:max(balance.year))';

util_vec = zeros(length(year_vec),1);
C_vec = zeros(length(year_vec),1);
L_vec = zeros(length(year_vec),1);
pop_vec = zeros(length(year_vec),1);
HHI_vec = zeros(length(year_vec),1);
def_test = zeros(length(year_vec),num_sector);
real_wage_vec = zeros(length(year_vec),1);
profit_vec = zeros(length(year_vec),1);
RER_vec = zeros(length(year_vec),1); 
P_vec = zeros(length(year_vec),1);
GDP_nominal_vec = zeros(length(year_vec),1);
P_j_H_mat = zeros(length(year_vec),num_sector);
R_vec = zeros(length(year_vec),1);
domar_weight = zeros(length(year_vec),num_sector);
domar_weight_given = zeros(length(year_vec),num_sector);
tau_level_guess_mat = zeros(length(year_vec),2*num_sector);
s_M = zeros(length(year_vec),num_sector);
real_output_sector_hat = zeros(length(year_vec),num_sector);
M_vec_hat = zeros(length(year_vec),num_sector);

firm_num_mat = zeros(length(year_vec),num_sector);

% A_avg_sector = zeros(length(year_vec),num_sector);

phi_bar_vec = zeros(length(year_vec),1);
GDP_vec = zeros(length(year_vec),1);
% A_avg_vec = zeros(length(year_vec),1);
% w_base = result_agg.w_base;
C_base = result_agg.C_base;
L_base = result_agg.L_base;

phi = Par.phi;
Par.sigma = est_result.sigma;
Par.rho = Par.rho_base;
Par.gamma_L = est_result.gl;
Par.gamma_K = est_result.gk;
Par.gamma_M = est_result.gm;
gamma_j = est_result.gl + est_result.gk + est_result.gm;

for i=1:length(year_vec)
        year=year_vec(i);
        year
        gamma_j_i_vec = [];
        % Sectoral variables (sector_num x 1)
        % Domestic sale / (Domestic + Import)
        mom.pop = pop_data.Lhat(pop_data.year==year_vec(i));
        mom.secid_full = secid_full;

        % Get the number of firms in each sector
        [~, loc] = ismember(balance.secid(balance.year==year_vec(i)), secid_full);
        firm_counts = accumarray(loc, 1);
        firm_num = firm_counts + 1; % Number of firms + fringe firm
        firm_num = [firm_num; ones(length(secid_service),1)]; % Add fringe firms from service sector
        firm_num_mat(i,:) = firm_num';
        total_firm = sum(firm_num);
        
        % Par.alpha_j =  fcons.fcons(fcons.year==year_vec(i)) / sum(fcons.fcons(fcons.year==year_vec(i)));        

        gamma_j_i_vec = [];    
        for j=1:num_sector
                    gamma_j_i = zeros(num_sector,1); % Share of int buying from sector j to i
            for k=1:num_sector
                gamma_j_i(k) = intsh.intsh(intsh.dsecid==secid_full(j) & intsh.osecid==secid_full(k) & intsh.year==year_vec(i));
            end
            gamma_j_i  = gamma_j_i / sum(gamma_j_i); % Make it sum up to one (excluding sectors outside manufacturing)
            gamma_j_i_vec = [gamma_j_i_vec;gamma_j_i]; % Long vector with num_sector x num_sector
        end
       
        shock_firm.tau_l_vec = result.tau_l( result.year==year_vec(i));
        shock_firm.tau_k_vec = result.tau_k( result.year==year_vec(i));
        shock_firm.A_fj_vec = result.A_fj( result.year==year_vec(i));
        shock_firm.DF_vec = result.DF(result.year==year_vec(i));
        shock_firm.DF_real = result.DF_real(result.year==year_vec(i));
        shock_firm.firmid = result.firmid( result.year==year_vec(i)); 
        
        shock_agg.P_j_F = result_agg.P_j_F_vec(i,:)';
%         shock_agg.D_j_F = result_agg.D_j_F_vec(i,:)';
        shock_agg.def_vec = result_agg.def_vec(i,:)';
        shock_agg.phi_bar = result_agg.phi_bar_vec(i);
        shock_agg.hour_data = hour_data(i);
        if i==1
            shock_agg.domar_weight = result_agg.domar_weight(1,:)';
            shock_agg.s_M = result_agg.s_M(1,:)';
        else
            shock_agg.domar_weight = result_agg.domar_weight(i-1,:)';
            shock_agg.s_M = result_agg.s_M(i-1,:)';
        end

        mom.gamma_j_i_vec = gamma_j_i_vec;
        mom.firm_num = firm_num;
%         mom.K =  sum(balance.fasset( balance.year==year_vec(i) ))/1e+9; % in billion won
        mom.K = K_hat(i);
        Par.alpha_j = alpha_j_mat(i,:)';

        % x_guess = [ones(total_firm,1);ones(total_firm,1)/total_firm; ones(num_sector,1);1];
        x_guess_year = x_guess_cell{i};
        x_guess = [x_guess_year(1:2*total_firm+2*num_sector);1];
        % x_guess = [x_next(1:2*total_firm+num_sector);ones(num_sector*2,1);1]
        if i==1
            result_final = array2table(zeros(1,21), 'VariableNames',...
                {'firmid','p_d','y_d','p_x','y_x','p_m','m','A_fj','k','l','w_vec','tau_l','tau_k','mu_l','mu_y','DF','DF_real','R','year','secid','pi'});
            result_pre = [];
        end
        A_fj_vec = shock_firm.A_fj_vec;
        
        iter = 0;
        diff = 10;
        dmp=0.5;
        tau_level_target = [tau_k_wtd_avg_mat(i,:)';tau_l_wtd_avg_mat(i,:)'];
        tau_level_guess = ones(length(tau_level_target),1);

        if i>1
            while diff>1e-4 && iter<1e+3
                    [diff,tau_level_next,x_guess] = model_given_wedge(tau_level_guess,tau_level_target,x_guess,Par, mom, shock_firm, shock_agg, year, result_pre,markup, markdown);
                    tau_level_guess = dmp*tau_level_next+(1-dmp)*tau_level_guess;
                    iter = iter+1;
                    if iter>1e+4
                        disp("maximum iteration reached")
                    end
            end
        else % In the initial year, we don't change the level of tau
            dmp = 0.1;
            while diff > 1e-8 && iter<1e+3
                    [x_next] = model_given_shock(x_guess, Par, mom, shock_firm, shock_agg, year, result_pre, 0, markup, markdown);
                    diff = max(abs(x_next-x_guess) ./ abs(x_guess) ) + norm(x_next(end)-x_guess(end));
                    x_guess = dmp*x_next+(1-dmp)*x_guess;
                    iter = iter+1;
            end
        end
        x_next = x_guess;
        shock_firm.tau_k_vec = shock_firm.tau_k_vec.*repelem(tau_level_guess(1:num_sector),firm_num);
        shock_firm.tau_l_vec = shock_firm.tau_l_vec.*repelem(tau_level_guess(num_sector+1:2*num_sector),firm_num);
        [x_next,norm_factor,P_j_F, phi_bar, GDP, sale_vec, to_append,util,real_wage,C,L,P,...
            GDP_nominal,def,profit_sum,P_j_H,RER,result_next,R] =...
            model_given_shock(x_next, Par, mom, shock_firm, shock_agg, year, result_pre, 1, markup, markdown);
        result_final = [result_final;to_append];
        result_pre = result_next; % This contains previous period domar weight, etc.

        % p = x_next(1:total_firm); % price level
        % l_vec_share = x_next(total_firm+1:2*total_firm); % wage
        % E_j_vec = x_next( 2*total_firm+1:2*total_firm+num_sector); % E_j
        % h = x_next(end); % labor hour
        
        GDP_vec(i) = GDP;
        R_vec(i) = R;
        % if ~isreal(GDP)
        %     disp("GDP is imaginery number");
        %     break
        % end

        % P_j_F_vec(i,:) = P_j_F';
        % D_j_F_vec(i,:) = D_j_F';
        % phi_bar_vec(i) = phi_bar;
        % def_vec(i) = def;
        % total_firm_vec(i) = total_firm;
%         A_avg_vec(i) = wmean(A_fj_vec,sale_vec);
%         A_avg_vec(i) = mean(A_fj_vec);
        util_vec(i) = util;
        C_vec(i) = C;
        L_vec(i) = L;
        phi_bar_vec(i) = phi_bar;
        pop_vec(i) = mom.pop;
        P_vec(i) = P;
        GDP_nominal_vec(i) = GDP_nominal;
        def_test(i,:) = def';
        real_wage_vec(i) = real_wage;
        profit_vec(i) = profit_sum;
        P_j_H_mat(i,:)=P_j_H';
        RER_vec(i) = RER;        
        % domar_weight(i,:) = result_next.domar_weight';
        domar_weight(i,:) = result_next.domar_weight';
        domar_weight_given(i,:) = result_agg.domar_weight(i,:)';
        tau_level_guess_mat(i,:) = tau_level_guess';
        % s_M(i,:) = result_next.s_M';
        % if i>1
        %     real_output_sector_hat(i,:) = result_next.real_output_sector_hat';
        %     M_vec_hat(i,:) = result_next.M_vec_hat';
        % end
end
result_final.top3_prev = result.top3;

% domar_weight = movmean(domar_weight,[5 5]);
% s_M = movmean(s_M,[5 5]);
% 
% for i=2:length(year_vec)
%     gdp_growth = domar_weight(i-1,:)* (real_output_sector_hat(i,:)-s_M(i,:).*M_vec_hat(i,:))';
%     GDP_vec(i) = GDP_vec(i-1)*gdp_growth;
% end

GDP_vec = GDP_vec/GDP_vec(1); % normalizing by the first year's GDP

% Welfare
beta = 0.97;
discount_vec = beta.^(0:1:length(year_vec)-1);
welfare = discount_vec * util_vec;

% Consumption equivalent welfare measure
f = @(lmd) discount_vec* log( (1+lmd)*C_base - phi_bar_vec.*(L_base).^(1+1/phi)/(1+1/phi)) ...
        - welfare; 
lmd = fsolve(f,0);

% Excluding fringe firms
result_final.sale = result_final.p_d.*result_final.y_d + result_final.p_x.*result_final.y_x;
result_final.export = result_final.p_x .* result_final.y_x;
result_final.sale_dom = result_final.sale - result_final.export;
result_final.sale_dom = result_final.p_d.*result_final.y_d;
result_final.wage_bill = result_final.w_vec.*result_final.l;
result_nofringe = result_final(result_final.firmid>0,:);
result_nofringe.minus_sale = -1*result_nofringe.sale;
result_nofringe = sortrows(result_nofringe, {'year','minus_sale'});  % Sort data by year, secid, and firmid 

CR3_vec = zeros(length(year_vec),1);
CR3_vec_fix = zeros(length(year_vec),1);
CR3_sector = zeros(length(year_vec),length(secid_manu));

CR3_dom_vec = zeros(length(year_vec),1);
mu_l_others_sector = zeros(length(year_vec),length(secid_manu));
mu_y_others_sector = zeros(length(year_vec),length(secid_manu));
tau_l_top3_sector = zeros(length(year_vec),length(secid_manu));
tau_k_top3_sector = zeros(length(year_vec),length(secid_manu));
tau_l_others_sector = zeros(length(year_vec),length(secid_manu));
tau_k_others_sector = zeros(length(year_vec),length(secid_manu));
mu_l_avg_top3 = zeros(length(year_vec),1);
mu_y_avg_top3 = zeros(length(year_vec),1);
mu_l_avg_others = zeros(length(year_vec),1);
mu_y_avg_others = zeros(length(year_vec),1);
mu_l_avg_all = zeros(length(year_vec),1);
mu_y_avg_all = zeros(length(year_vec),1);

tau_l_avg_top3 = zeros(length(year_vec),1);
tau_k_avg_top3 = zeros(length(year_vec),1);
tau_l_avg_others = zeros(length(year_vec),1);
tau_k_avg_others = zeros(length(year_vec),1);
A_avg_top3 = zeros(length(year_vec),1);
DF_avg_top3 = zeros(length(year_vec),1);
A_avg_others = zeros(length(year_vec),1);
DF_avg_others = zeros(length(year_vec),1);
%%
A_top3 = zeros(length(year_vec),1);
A_others = zeros(length(year_vec),1);
A_others_sector = zeros(length(year_vec),length(secid_manu));
DF_top3 = zeros(length(year_vec),1);
DF_others = zeros(length(year_vec),1);
DF_others_sector = zeros(length(year_vec),num_sector);
pi_avg_sector = zeros(length(year_vec),num_sector); 
mu_y_agg_sector = zeros(length(year_vec),num_sector);
mu_l_agg_sector = zeros(length(year_vec),num_sector);
A_j = zeros(length(year_vec),num_sector);
sale_sector = zeros(length(year_vec),num_sector);
wage_bill_sector = zeros(length(year_vec),num_sector);
pi_avg = zeros(length(year_vec),1);
pi_avg_unweighted = zeros(length(year_vec),1);
mu_y_agg = zeros(length(year_vec),1);
mu_l_agg = zeros(length(year_vec),1);
mu_l_agg_top3 = zeros(length(year_vec),1);
mu_y_agg_top3 = zeros(length(year_vec),1);
A_agg = zeros(length(year_vec),1);
s_y_top3_avg = zeros(length(year_vec),1);
num_top = 3;
% num_sector = length(secid_manu);
% secid_top3_year = zeros (length(year_vec),num_top3*num_sector);
s_y_top3_year  = zeros (length(year_vec),num_top*length(secid_manu));
mu_y_top3_year = zeros(length(year_vec),num_top*length(secid_manu));
mu_y_dom_top3_year = zeros(length(year_vec),num_top*length(secid_manu)); 
firmid_top3_year = zeros(length(year_vec),num_top*length(secid_manu));
export_year = zeros(length(year_vec),1);
dom_sale_year = zeros(length(year_vec),1);
top3_list = zeros(length(year_vec),num_top*length(secid_manu));
sale_sector_year = zeros(length(year_vec),num_sector);
GO_share = zeros(length(year_vec),length(secid_manu));
sale_sector_share = zeros(length(year_vec),length(secid_manu));
CR3_check = zeros(length(year_vec),1);


% % Define top3 by 10 year rolling average
% result_final = sortrows(result_final,{'firmid','year'});
% for i=1:height(result_final)
%     result_final.sale_10yrs_avg(i) = mean(result_final.sale(result_final.firmid==result_final.firmid(i) & result_final.year<=result_final.year(i)+9 & result_final.year>=result_final.year(i)));
% end
% result_final.top3 = zeros(height(result_final),1);
% top3_list = zeros(length(year_vec),10);
% for i=1:length(year_vec)
%     result_final.minus_sale_10yrs_avg = -result_final.sale_10yrs_avg;
%     result_final.fringe = (result_final.firmid<0);
%     result_final.year_check=(result_final.year~=year_vec(i));
%     result_final = sortrows(result_final, {'year_check','fringe','minus_sale_10yrs_avg'});  
%     result_final.top3(1:10) = 1;
%     result_final = sortrows(result_final,{'firmid'});
%     top3_list(i,:) = result_final.firmid(result_final.top3==1 & result_final.year==year_vec(i))';
% end
% result_final = sortrows(result_final,{'year','secid','firmid'});

for i=1:length(year_vec)
    GO_share(i,:) = GO.GO(GO.year==year_vec(i) & ismember(GO.secid,secid_manu))...
        ./sum(GO.GO(GO.year==year_vec(i) & ismember(GO.secid,secid_manu)));
    result_all = result_final(result_final.year==year_vec(i),:);
    result_all.minus_sale = -result_all.sale;
    result_all.fringe = (result_all.firmid<0);
    result_all.top3 = zeros(height(result_all),1);
    % Pick top3 3 firms for each sector-year
    for j=1:length(secid_manu)
        sale_sector_share(i,j) = sum(result_all.sale(result_all.secid==j))...
            ./sum(result_all.sale(ismember(result_all.secid,secid_manu)));
        result_all.secid_check = -1*(result_all.secid==j);
        result_all = sortrows(result_all, {'secid_check','fringe','minus_sale'});  
        result_all.top3(1:num_top) = 1;
        CR3_sector(i,j) = sum(result_all.sale(result_all.top3==1 & result_all.secid==j))...
            /sum(result_all.sale(result_all.secid==j));
    end
    CR3_check(i) = GO_share(i,:)*CR3_sector(i,:)';

    result_top3 = result_all(result_all.top3==1,:);
    result_others = result_all(result_all.top3==0,:);

    % If want to fix top3 list in counterfactuals
    % result_all = result_final(result_final.year==year_vec(i),:);
    % result_all.top3 = ismember(result_all.firmid,top3_list_base(i,:));
    % result_top3 = result_all(result_all.top3==1,:);
    % result_others = result_all(result_all.top3==0,:);
    CR3_vec_fix(i) =  sum(result_all.sale(result_all.top3_prev==1)) ...
        / sum(result_all.sale(ismember(result_all.secid,secid_manu) ));
    CR3_vec(i) =  sum(result_all.sale(result_all.top3==1)) ...
        / sum(result_all.sale(ismember(result_all.secid,secid_manu) ));
    CR3_dom_vec(i) =  sum(result_all.sale_dom(result_all.top3==1)) ...
        / sum(result_all.sale_dom(ismember(result_all.secid,secid_manu) ));  
    dom_sale_year(i) = sum(result_all.p_d.*result_all.y_d)/P_vec(i);
    export_year(i) = sum(result_all.export)/P_vec(i);
    % A_top3(i) = wmean(result_top3.A_fj,result_top3.sale);
    % A_others(i) = wmean(result_others.A_fj,result_others.sale);
    % DF_top3(i) = wmean(result_top3.DF_real,result_top3.export);
    % DF_others(i) = wmean(result_others.DF_real,result_others.export);

    % A_top3(i) = mean(result_top3.A_fj);
    % A_others(i) = wmean(result_others.A_fj,result_others.sale);
    % DF_top3(i) = mean(result_top3.DF_real);
    % DF_others(i) = wmean(result_others.DF_real,result_others.export);

    mu_l_top3 = [];
    mu_y_top3 = [];
    mu_y_dom_top3 = [];
    tau_l_top3 = [];
    tau_k_top3 = [];
    A_top3 = [];
    DF_top3 = [];
    sale_top3 = [];
    s_y_top3 = [];
    secid_top3 = [];
    firmid_top3 = [];
    sigma = Par.sigma(1);
    firm_num = firm_num_mat(i,:)';

    for j=1:num_sector
        result_all = sortrows(result_all,{'secid','firmid'});
        sale_vec = result_all.sale(result_all.secid==j);
        sale_dom_vec = result_all.sale_dom(result_all.secid==j);
        wage_bill_vec = result_all.wage_bill(result_all.secid==j);
        export_vec = result_all.export(result_all.secid==j);
        tau_l_vec = result_all.tau_l(result_all.secid==j);
        tau_k_vec = result_all.tau_k(result_all.secid==j);
        a_fj_vec = result_all.A_fj(result_all.secid==j);
        y_d_vec = result_all.y_d(result_all.secid==j);
        y_x_vec = result_all.y_x(result_all.secid==j);
        

        s_y = sale_vec./sum(sale_vec);
        % s_y_dom = sale_dom_vec./ sum(sale_dom_vec);
        s_l = wage_bill_vec./sum(wage_bill_vec);
        mu_y_vec = result_all.mu_y(result_all.secid==j);
        mu_l_vec = result_all.mu_l(result_all.secid==j);
        mu_y_tilde = mu_y_vec.*(y_d_vec./(y_d_vec+y_x_vec))...
            + Par.sigma(j)./(Par.sigma(j)-1)* (y_x_vec./(y_d_vec+y_x_vec));
        % mu_y_tilde = mu_y_vec;
        pi_vec = result_all.pi(result_all.secid==j & result_all.top3_prev==0 & result_all.firmid>0);
        pi_avg_sector(i,j) = mean(pi_vec);
        mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec) ;
        mu_y_agg_sector_others = 1/wmean(mu_y_tilde(result_all.top3(result_all.secid==j)==0).^(-1),sale_vec(result_all.top3(result_all.secid==j)==0)) ;
        % mu_l_tilde = mu_y_tilde.*mu_l_vec./mu_y_agg_sector(i,j);
        mu_l_agg_sector(i,j) =  1/wmean( mu_l_vec.^(-1), sale_vec./mu_y_tilde );
        mu_l_agg_sector_others =  1/wmean( mu_l_vec(result_all.top3(result_all.secid==j)==0).^(-1), sale_vec(result_all.top3(result_all.secid==j)==0)./mu_y_tilde(result_all.top3(result_all.secid==j)==0) );

        % mu_y_dom_top3_temp = mu_y_vec(result_all.top3(result_all.secid==j)==1);
        % mu_y_top3_temp = mu_y_tilde(result_all.top3(result_all.secid==j)==1) ;
        % mu_l_top3_temp = mu_l_vec(result_all.top3(result_all.secid==j)==1) ;
        mu_y_top3_temp = mu_y_tilde(result_all.top3(result_all.secid==j)==1) ./ mu_y_agg_sector_others;
        mu_l_top3_temp = mu_l_vec(result_all.top3(result_all.secid==j)==1) ./ mu_l_agg_sector_others;
        sale_top3_temp = sale_vec(result_all.top3(result_all.secid==j)==1);
        s_y_top3_temp = sale_dom_vec(result_all.top3(result_all.secid==j)==1) / sum(sale_dom_vec);
        
        sale_sector(i,j) = sum(result_all.sale(result_all.secid==j) );
        wage_bill_sector(i,j) = sum(result_all.wage_bill(result_all.secid==j) );
        mrpl_tilde = mu_y_tilde.*tau_l_vec.*mu_l_vec.*(s_l.^(1/(Par.eta+1)));
        mrpk_tilde = mu_y_tilde.*tau_k_vec;
        mrpm_tilde = mu_y_tilde;
        tfpr = sale_vec.^(1-gamma_j(j)).* ( mrpl_tilde ).^(Par.gamma_L(j))...
                    .*( (mrpk_tilde).^(Par.gamma_K(j)) ).*( (mrpm_tilde).^(Par.gamma_M(j)) );
        MRPL_tilde = (firm_num(j)^(1/eta)*sum( (s_y./ mrpl_tilde).^((eta+1)/eta) ) )^(-eta/(eta+1));
        MRPK_tilde = sum(s_y./ mrpk_tilde)^(-1);
        MRPM_tilde = sum(s_y./mrpm_tilde)^(-1);
        TFPR_bar = sum(sale_vec)^(1-gamma_j(j)) *MRPL_tilde^(Par.gamma_L(j))...
                             * MRPK_tilde^(Par.gamma_K(j))*MRPM_tilde^(Par.gamma_M(j));
        A_j(i,j) = (sum( (a_fj_vec.*TFPR_bar./tfpr).^(Par.sigma(j)-1) )/firm_num(j) )^(1/(Par.sigma(j)-1));

        mu_l_others_sector(i,j) = wmean(result_others.mu_l(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        % mu_l_top3_temp = result_top3.mu_l(result_top3.secid==j) / mu_l_agg_sector(i,j);
        mu_l_top3 = [mu_l_top3;mu_l_top3_temp];
        mu_y_others_sector(i,j) = wmean(result_others.mu_y(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        mu_y_dom_top3_temp = result_top3.mu_y(result_top3.secid==j) / mu_y_others_sector(i,j);
        mu_y_top3 = [mu_y_top3;mu_y_top3_temp];
        mu_y_dom_top3 = [mu_y_dom_top3;mu_y_dom_top3_temp];

        sale_top3 = [sale_top3; sale_top3_temp];
        s_y_top3 = [s_y_top3; s_y_top3_temp];
        tau_l_top3_temp = result_top3.tau_l(result_top3.secid==j);
        tau_l_top3 = [tau_l_top3;tau_l_top3_temp];

        tau_k_top3_temp = result_top3.tau_k(result_top3.secid==j);
        tau_k_top3 = [tau_k_top3;tau_k_top3_temp];
        A_others_sector(i,j) = wmean(result_others.A_fj(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        A_top3_temp = result_top3.A_fj(result_top3.secid==j) / A_others_sector(i,j);
        A_top3 = [A_top3;A_top3_temp];
        DF_others_sector(i,j) = wmean(result_others.DF_real(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        DF_top3_temp = result_top3.DF_real(result_top3.secid==j) / DF_others_sector(i,j);
        DF_top3 = [DF_top3;DF_top3_temp];
        secid_top3 = [secid_top3;j*ones(length(DF_top3_temp),1)];
        firmid_top3 = [firmid_top3;result_all.firmid(result_all.top3==1 & result_all.secid==j)];
        sale_sector_year(i,j) = sum( result_all.sale(result_all.secid==j) );
        if ismember(j,secid_manu)
            tau_l_top3_sector(i,j) = wmean(result_top3.tau_l(result_top3.secid==j),...
            result_top3.sale(result_top3.secid==j))...
            ./wmean(result_others.tau_l(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
            tau_k_top3_sector(i,j) = wmean(result_top3.tau_k(result_top3.secid==j),...
            result_top3.sale(result_top3.secid==j))...
            ./wmean(result_others.tau_k(result_others.secid==j),...
            result_others.sale(result_others.secid==j));
        end

    end
    tau_k_avg_top3(i) = wmean(result_top3.tau_k,result_top3.sale);
    tau_k_avg_others(i) = wmean(result_others.tau_k,result_others.sale);
    tau_l_avg_top3(i) = wmean(result_top3.tau_l,result_top3.sale);
    tau_l_avg_others(i) = wmean(result_others.tau_l,result_others.sale);
    mu_l_avg_others(i) = wmean(result_others.mu_l,result_others.sale);
    mu_y_avg_others(i) = wmean(result_others.mu_y,result_others.sale);
    A_avg_top3(i) = wmean(result_top3.A_fj,result_top3.sale);
    A_avg_others(i) = wmean(result_others.A_fj(result_others.firmid>0),result_others.sale(result_others.firmid>0));
    DF_avg_top3(i) = wmean(result_top3.DF_real,result_top3.sale  );
    DF_avg_others(i) = wmean(result_others.DF_real,result_others.sale);
    mu_l_avg_all(i) = wmean(result_all.mu_l,result_all.sale);
    mu_y_avg_all(i) = wmean(result_all.mu_y,result_all.sale);
    if i==1
        pi_avg(i) = wmean( pi_avg_sector(i,secid_manu),domar_weight(1,secid_manu) );
        mu_y_agg(i) = wmean( (mu_y_agg_sector(i,:)).^(-1),domar_weight(1,:))^(-1);
        mu_l_agg(i) = wmean( (mu_l_agg_sector(i,:).*mu_y_agg_sector(i,:)).^(-1),domar_weight(1,:))^(-1) / mu_y_agg(i);
        A_agg(i) = sum(A_j(i,:).*domar_weight(1,:));
        % A_agg(i) = wmean(A_j(i,:),sale_sector_year(1,:));
    else
        pi_avg(i) = wmean( pi_avg_sector(i,secid_manu),domar_weight(1,secid_manu) );
        mu_y_agg(i) = wmean( (mu_y_agg_sector(i,:)).^(-1),domar_weight(i-1,:))^(-1);
        mu_l_agg(i) = wmean( (mu_l_agg_sector(i,:).*mu_y_agg_sector(i,:)).^(-1),domar_weight(i-1,:))^(-1) / mu_y_agg(i);
        A_agg(i) = sum(A_j(i,:).*domar_weight(i-1,:));
        % A_agg(i) = wmean(A_j(i,:),sale_sector_year(i-1,:));
    end

    pi_avg_unweighted(i) = mean(result_all.pi(result_all.top3_prev==0));
    mu_y_agg_top3(i) = wmean(mu_y_top3,result_top3.sale);
    mu_l_agg_top3(i) = wmean(mu_l_top3,result_top3.sale);
    s_y_top3_avg(i) = mean(s_y_top3);
    % secid_top3_year(i,:) = secid_top3';
    s_y_top3_year(i,:) = s_y_top3';
    mu_y_top3_year(i,:) = mu_y_top3';
    mu_y_dom_top3_year(i,:) = mu_y_dom_top3';
    firmid_top3_year(i,:) = firmid_top3';
    result_all=sortrows(result_all,'firmid');
    top3_list(i,:) = result_all.firmid(result_all.top3==1)';
end
%%
agg_result.CR10_vec = CR3_vec;
agg_result.CR10_dom_vec = CR3_dom_vec;
agg_result.CR10_vec_fix = CR3_vec_fix;
% agg_result.CR10_vec_hyundai = CR10_vec_hyundai;
% agg_result.CR10_vec_sk = CR10_vec_sk;
agg_result.mu_l_others_sector = mu_l_others_sector;
agg_result.mu_y_others_sector = mu_y_others_sector ;
agg_result.mu_l_avg_top3 = mu_l_avg_top3;
agg_result.mu_y_avg_top3 = mu_y_avg_top3;
agg_result.tau_l_avg_top3 = tau_l_avg_top3;
agg_result.tau_k_avg_top3 = tau_k_avg_top3;
agg_result.tau_l_avg_others = tau_l_avg_others;
agg_result.tau_k_avg_others = tau_k_avg_others;
agg_result.A_top3 = A_avg_top3;
agg_result.A_others = A_avg_others;
agg_result.DF_top3 = DF_avg_top3;
agg_result.DF_others = DF_avg_others;
agg_result.mu_l_avg_others = mu_l_avg_others;
agg_result.mu_y_avg_others = mu_y_avg_others;

agg_result.pi_avg = pi_avg;
agg_result.pi_avg_unweighted = pi_avg_unweighted;
agg_result.mu_l_avg_all = mu_l_avg_all;
agg_result.mu_y_avg_all = mu_y_avg_all;
agg_result.mu_y_agg = mu_y_agg;
agg_result.mu_l_agg = mu_l_agg;
agg_result.mu_y_agg_top3 = mu_y_agg_top3;
agg_result.mu_l_agg_top3 = mu_l_agg_top3;
agg_result.A_agg = A_agg;
agg_result.export_year = export_year;
agg_result.dom_sale_year = dom_sale_year;
agg_result.real_wage_vec = real_wage_vec;
agg_result.top3_list = top3_list;
agg_result.sale_sector_year = sale_sector_year;
agg_result.RER_vec = RER_vec;
agg_result.C_vec = C_vec;
agg_result.L_vec = L_vec;
agg_result.R_vec = R_vec;
agg_result.CR3_check = CR3_check;
agg_result.pi_avg_sector = pi_avg_sector;
agg_result.tau_level_guess_mat = tau_level_guess_mat;

% CR10 = mean(CR10_vec(end-4:end));
% CR10 = CR10_vec(end) - CR10_vec(1);
% Consumption equivalent welfare from 1972 to 2011
f = @(delta) log( (1+delta)*C_vec(1) - phi_bar_vec(1).*(L_vec(1)).^(1+1/phi)/(1+1/phi)) ...
        - util_vec(end); 
delta = fsolve(f,0);
delta = delta*100;
lmd = lmd*100;

% writetable(result_final,OUTPUT+'result_DF.csv')
% check3 = result_final(result_final.firmid==7349,:);
% writetable(check3,OUTPUT+'check3.csv')

% bar(year_vec,CR10_vec)