function [continuing_margin,entry_exit_margin,sector_margin,productivity_margin,export_margin] = CR3_decompose(p,Par,est_result,result)

p=1;
eta = Par.eta;
secid_manu = Par.secid_manu;
year_vec = Par.year_vec;

result_manu=result(ismember(result.secid,secid_manu),:);
result_manu.wage_bill = result_manu.w.*result_manu.l;

gamma_j_vec = est_result.g;

firm_num_mat = zeros(length(year_vec),length(secid_manu));
A_j_mat = zeros(length(year_vec),length(secid_manu));

for j=1:length(secid_manu)
    result_manu.gamma_L(result_manu.secid==j) = est_result.gl(est_result.secid==j);
    result_manu.gamma_K(result_manu.secid==j) = est_result.gk(est_result.secid==j);
    result_manu.gamma_M(result_manu.secid==j) = est_result.gm(est_result.secid==j);    
    result_manu.sigma(result_manu.secid==j) = est_result.sigma(est_result.secid==j);
    for i=1:length(year_vec)
        firm_num_mat(i,j) ...
            = sum(result_manu.year==year_vec(i) & result_manu.secid==j);
        result_manu.R_j(result_manu.year==year_vec(i) & result_manu.secid==j) ...
            = sum(result_manu.sale_vec(result_manu.year==year_vec(i) & result_manu.secid==j ));
        result_manu.s_fj(result_manu.secid==j & result_manu.year==year_vec(i)) ...
            = result_manu.sale_vec(result_manu.secid==j & result_manu.year==year_vec(i)) ...
            ./result_manu.R_j(result_manu.secid==j & result_manu.year==year_vec(i));
        result_manu.s_l(result_manu.secid==j & result_manu.year==year_vec(i)) ... % s_l needs to be remade here
            = result_manu.wage_bill(result_manu.secid==j & result_manu.year==year_vec(i)) ...
            /sum(result_manu.wage_bill(result_manu.secid==j & result_manu.year==year_vec(i)));
        result_manu.firm_num(result_manu.secid==j & result_manu.year==year_vec(i)) =...
            firm_num_mat(i,j);
    end
end
result_manu.gamma_j = result_manu.gamma_L + result_manu.gamma_K + result_manu.gamma_M;

result_manu.mu_x = (result_manu.sigma./(result_manu.sigma-1));
result_manu.mu_y_tilde = result_manu.mu_y.*(result_manu.y_d./(result_manu.y_d+result_manu.y_x))...
    + result_manu.mu_x.* result_manu.y_x./(result_manu.y_d+result_manu.y_x);
result_manu.mrpl_tilde = result_manu.mu_y_tilde.*result_manu.tau_l.*result_manu.mu_l.*(result_manu.s_l.^(1/(eta+1)));
result_manu.mrpk_tilde = result_manu.mu_y_tilde.*result_manu.tau_k;
result_manu.mrpm_tilde = result_manu.mu_y_tilde;
result_manu.DF_MA = (result_manu.mu_y_tilde./result_manu.mu_y).^(result_manu.sigma-1)...
    + (result_manu.mu_y_tilde./result_manu.mu_x ).^(result_manu.sigma-1).*result_manu.DF_tilde;
result_manu.DF_RTS = (result_manu.mu_y_tilde./result_manu.mu_y).^(result_manu.sigma)...
    + (result_manu.mu_y_tilde./result_manu.mu_x ).^(result_manu.sigma).*result_manu.DF_tilde;
result_manu.phi_fj = result_manu.DF_MA.^(result_manu.sigma./(result_manu.sigma-1)-result_manu.gamma_j) ...
    ./ result_manu.DF_RTS.^(1-result_manu.gamma_j); 

for i=1:length(year_vec)
    for j=1:length(secid_manu)
        result_manu.MRPL_tilde(result_manu.year==year_vec(i) & result_manu.secid==j)...
            = (firm_num_mat(i,j)^(1/eta).*sum( (result_manu.s_fj(result_manu.year==year_vec(i) & result_manu.secid==j)...
            .* result_manu.mrpl_tilde(result_manu.year==year_vec(i) & result_manu.secid==j)).^((eta+1)/eta) ) ).^(eta/(eta+1));
        result_manu.MRPK_tilde(result_manu.year==year_vec(i) & result_manu.secid==j) ...
            = sum(result_manu.s_fj(result_manu.year==year_vec(i) & result_manu.secid==j)...
            .*result_manu.mrpk_tilde(result_manu.year==year_vec(i) & result_manu.secid==j));
        result_manu.MRPM_tilde(result_manu.year==year_vec(i) & result_manu.secid==j) ...
            = sum(result_manu.s_fj(result_manu.year==year_vec(i) & result_manu.secid==j)...
            .*result_manu.mrpm_tilde(result_manu.year==year_vec(i) & result_manu.secid==j));
        result_manu.Phi_j(result_manu.year==year_vec(i) & result_manu.secid==j)...
            = (sum(result_manu.s_fj(result_manu.year==year_vec(i) & result_manu.secid==j)...
            .* result_manu.phi_fj(result_manu.year==year_vec(i) & result_manu.secid==j).^(1-Par.sigma(j)) ) ).^(1/(1-Par.sigma(j)));
    end
end

result_manu.a_fj_tilde = result_manu.A_fj.*(result_manu.MRPL_tilde./result_manu.mrpl_tilde).^(result_manu.gamma_L)...
    .*(result_manu.MRPK_tilde./result_manu.mrpk_tilde).^(result_manu.gamma_K) ...
    .*(result_manu.MRPM_tilde./result_manu.mrpm_tilde).^(result_manu.gamma_M);
result_manu.tfpr = result_manu.sale_vec.^(1-result_manu.gamma_j).* ( result_manu.mrpl_tilde ).^(result_manu.gamma_L)...
            .*( (result_manu.mrpk_tilde).^(result_manu.gamma_K) ).*( (result_manu.mrpm_tilde).^(result_manu.gamma_M) );
result_manu.TFPR_bar = result_manu.R_j.^(1-result_manu.gamma_j).* result_manu.MRPL_tilde.^(result_manu.gamma_L)...
                             .* result_manu.MRPK_tilde.^(result_manu.gamma_K).*result_manu.MRPM_tilde.^(result_manu.gamma_M );


for i=1:length(year_vec)
    for j=1:length(secid_manu)
        A_j_mat(i,j) = (1/firm_num_mat(i,j) * sum( (result_manu.A_fj(result_manu.year==year_vec(i) & result_manu.secid==j)...
           .*result_manu.TFPR_bar(result_manu.year==year_vec(i) & result_manu.secid==j)...
           ./result_manu.tfpr(result_manu.year==year_vec(i) & result_manu.secid==j)).^(Par.sigma(j)-1) ) ).^(1./(Par.sigma(j)-1));
        result_manu.A_j(result_manu.year==year_vec(i) & result_manu.secid==j) = firm_num_mat(i,j).^(1/(Par.sigma(j)-1)) * A_j_mat(i,j);
    end
end

% result_manu.tfpr = result_manu.sale_vec.^(1-result_manu.gamma_j).* ( result_manu.mrpl_tilde ).^(result_manu.gamma_L)...
%             .*( (result_manu.mrpk_tilde).^(result_manu.gamma_K) ).*( (result_manu.mrpm_tilde).^(result_manu.gamma_M ) );

result_manu = sortrows(result_manu,{'firmid', 'year'});

firmid_temp = result_manu.firmid;
year_temp = result_manu.year;
top3_temp = result_manu.top3;
top3_pre_temp = [zeros(p,1);top3_temp(1:end-p)];

result_manu.continuing =[zeros(p,1); ( (firmid_temp(1+p:end) == firmid_temp(1:end-p)) & (year_temp(1+p:end) == year_temp(1:end-p)+p) )];
result_manu.top3_continuing =...
    [ zeros(p,1); ( (firmid_temp(1+p:end) == firmid_temp(1:end-p)) & (year_temp(1+p:end) == year_temp(1:end-p)+p)...
            & (top3_temp(1+p:end)==1)  & (top3_temp(1:end-p)==1)  ) ];
result_manu.top3_pre(result_manu.continuing==1) = top3_pre_temp(result_manu.continuing==1);

CR3=zeros(length(year_vec),1);
CR3_sector = zeros(length(year_vec),1);
omega_top3 = zeros(length(year_vec),length(secid_manu));
S_j_top3 = zeros(length(year_vec),length(secid_manu));
S_j_top3_continuing_t = zeros(length(year_vec),length(secid_manu));
S_j_top3_continuing_t_minus_p = zeros(length(year_vec),length(secid_manu));
S_j = zeros(length(year_vec),length(secid_manu));
sale_top3 = zeros(length(year_vec),length(secid_manu));
sale_top3_continuing = zeros(length(year_vec),length(secid_manu));
sale_pre_top3_continuing = zeros(length(year_vec),length(secid_manu));

sale_temp = result_manu.sale_vec;
sale_pre_temp= [zeros(p,1);sale_temp(1:end-p)];
result_manu.sale_pre(result_manu.continuing==1) = sale_pre_temp(result_manu.continuing==1);

for i=1:length(year_vec)
    CR3(i)=sum(result_manu.sale_vec(result_manu.top3==1 & result_manu.year==year_vec(i)))...
        /sum(result_manu.sale_vec(result_manu.year==year_vec(i))); % Share of top3 firms in total sales
    for j=1:length(secid_manu)
        sale_top3(i,j) = sum(result_manu.sale_vec(result_manu.top3==1 & result_manu.year==year_vec(i) & result_manu.secid==j) );
        CR3_sector(i,j) = sale_top3(i,j) / sum(result_manu.sale_vec(result_manu.year==year_vec(i) & result_manu.secid==j));
        sale_top3_continuing(i,j) = sum(result_manu.sale_vec(result_manu.top3_continuing==1 & result_manu.year==year_vec(i) & result_manu.secid==j) );
        sale_pre_top3_continuing(i,j) = sum(result_manu.sale_pre(result_manu.top3_continuing==1 & result_manu.year==year_vec(i) & result_manu.secid==j) );
        omega_top3(i,j) = sum(result_manu.sale_vec(result_manu.top3==1 & result_manu.secid==j & result_manu.year==year_vec(i)) )...
            / sum(result_manu.sale_vec(result_manu.top3==1 & result_manu.year==year_vec(i))); % Share of sector j in top3 firms' sale
        S_j_top3(i,j) = sum(result_manu.sale_vec(result_manu.top3==1 & result_manu.secid==j & result_manu.year==year_vec(i)) )...
            / sum(result_manu.sale_vec(result_manu.secid==j & result_manu.year==year_vec(i))); % Share of top3 firms' sale in sector j
        S_j_top3_continuing_t(i,j) = sum(result_manu.sale_vec(result_manu.top3==1 & result_manu.secid==j & result_manu.year==year_vec(i) & result_manu.top3_continuing==1 ) )...
            / sale_top3(i,j); % Sales share of top3 firms that were also top3 in t-p in sector j, time t
        S_j(i,j) = sum(result_manu.sale_vec(result_manu.secid==j & result_manu.year==year_vec(i))) ...
            / sum(result_manu.sale_vec(result_manu.year==year_vec(i)) ); % Share of sector j in total sales
        if i>p
            S_j_top3_continuing_t_minus_p(i,j) = sum(result_manu.sale_pre(result_manu.top3==1 & result_manu.secid==j & result_manu.year==year_vec(i) & result_manu.top3_continuing==1 ) )...
                / sale_top3(i-p,j); % Sales share of top3 firms that were also top3 in t-p in sector j, time t
        end
        result_manu.s_fj_top3(result_manu.top3_continuing==1 & result_manu.secid==j & result_manu.year==year_vec(i)) ...
            = result_manu.sale_vec(result_manu.top3_continuing==1 & result_manu.secid==j & result_manu.year==year_vec(i)) ...
            /sale_top3_continuing(i,j);
        result_manu.s_fj_top3_pre(result_manu.top3_continuing==1 & result_manu.secid==j & result_manu.year==year_vec(i)) ...
            = result_manu.sale_pre(result_manu.top3_continuing==1 & result_manu.secid==j & result_manu.year==year_vec(i)) ...
            /sale_pre_top3_continuing(i,j);
    end
end

% s_fj_top3_temp = result_manu.s_fj_top3;
% s_fj_top3_pre_temp = [zeros(p,1);s_fj_top3_temp(1:end-p)];

a_tilde_A_temp = result_manu.a_fj_tilde./( result_manu.A_j );
a_tilde_A_pre_temp = [zeros(p,1);a_tilde_A_temp(1:end-p)];

phi_PHI_temp = result_manu.phi_fj ./ ( result_manu.Phi_j );
phi_PHI_pre_temp = [zeros(p,1);phi_PHI_temp(1:end-p)];

% result_manu.s_fj_top3_pre_temp= NaN*ones(height(result_manu),1);
% result_manu.s_fj_top3_pre(result_manu.top3_continuing==1) ...
%     = s_fj_top3_pre_temp(result_manu.top3_continuing==1);
result_manu.a_tilde_A_pre= NaN*ones(height(result_manu),1);
result_manu.a_tilde_A_pre(result_manu.top3_continuing==1) = a_tilde_A_pre_temp(result_manu.top3_continuing==1);
result_manu.phi_Phi_pre= NaN*ones(height(result_manu),1);
result_manu.phi_Phi_pre(result_manu.top3_continuing==1) = phi_PHI_pre_temp(result_manu.top3_continuing==1);


result_manu.omega_fj(result_manu.top3_continuing==1) ...
    = (result_manu.s_fj_top3(result_manu.top3_continuing==1) - result_manu.s_fj_top3_pre(result_manu.top3_continuing==1)) ...
    ./ ( log(result_manu.s_fj_top3(result_manu.top3_continuing==1)) - log(result_manu.s_fj_top3_pre(result_manu.top3_continuing==1)) );
result_manu.omega_fj(result_manu.top3_continuing==1 & result_manu.s_fj_top3==1 & result_manu.s_fj_top3_pre==1)=1;
for i=1:length(year_vec)
    for j=1:length(secid_manu)
        result_manu.omega_fj(result_manu.year==year_vec(i) & result_manu.secid==j & result_manu.top3_continuing==1) ...
        = result_manu.omega_fj(result_manu.year==year_vec(i) & result_manu.secid==j & result_manu.top3_continuing==1) ...
            / sum(result_manu.omega_fj(result_manu.year==year_vec(i) & result_manu.secid==j & result_manu.top3_continuing==1));
    end
end

% result_manu.share_check = (result_manu.a_fj_tilde.*result_manu.phi_fj...
%     ./result_manu.A_j./result_manu.Phi_j).^(1./((result_manu.sigma./(result_manu.sigma-1))-result_manu.gamma_j));

continuing_margin = zeros(length(year_vec)-p,1);
entry_exit_margin = zeros(length(year_vec)-p,1);
sector_margin = zeros(length(year_vec)-p,1);
entire_margin = zeros(length(year_vec)-p,1);
variety_margin = zeros(length(year_vec)-p,1);
productivity_margin = zeros(length(year_vec)-p,1);
export_margin = zeros(length(year_vec)-p,1);

temp1 = zeros(length(secid_manu),1);
temp2 = zeros(length(secid_manu),1);
temp3 = zeros(length(secid_manu),1);
temp4 = zeros(length(secid_manu),1);
temp5 = zeros(length(secid_manu),1);
productivity_temp = zeros(length(secid_manu),length(year_vec));
export_temp = zeros(length(secid_manu),length(year_vec));

within_sector = zeros(length(year_vec)-p,length(secid_manu));
within_sector_continuing = zeros(length(year_vec)-p,length(secid_manu));
within_sector_entry =zeros(length(year_vec)-p,length(secid_manu));

for i=1+p:length(year_vec)
    for j=1:length(secid_manu)
        sample = (result_manu.top3_continuing==1 & result_manu.secid==j & result_manu.year==year_vec(i));
        temp1(j) = omega_top3(i-p,j)*1./( Par.sigma(j)/(Par.sigma(j)-1)-est_result.g(est_result.secid==j)) ...
            * sum( result_manu.omega_fj(sample)...
            .* (log(result_manu.a_fj_tilde(sample)./(result_manu.A_j(sample))...
            ./result_manu.a_tilde_A_pre(sample)) ...
            +log(result_manu.phi_fj(sample)./(result_manu.Phi_j(sample))...
             ./result_manu.phi_Phi_pre(sample)) ) );

        productivity_temp(j,i) = omega_top3(i-p,j)*1./( Par.sigma(j)/(Par.sigma(j)-1)-est_result.g(est_result.secid==j)) ...
            * sum( result_manu.omega_fj(sample)...
            .* (log(result_manu.a_fj_tilde(sample)./(result_manu.A_j(sample))...
            ./result_manu.a_tilde_A_pre(sample)) ) );

        export_temp(j,i) = omega_top3(i-p,j)*1./( Par.sigma(j)/(Par.sigma(j)-1)-est_result.g(est_result.secid==j)) ...
            * sum( result_manu.omega_fj(sample)...
            .* ( log(result_manu.phi_fj(sample)./(result_manu.Phi_j(sample) )...
             ./result_manu.phi_Phi_pre(sample)) ) );

        temp2(j) = omega_top3(i-p,j)*log(S_j_top3_continuing_t(i,j)./S_j_top3_continuing_t_minus_p(i,j));
        if S_j_top3_continuing_t(i,j)==0 % When there is no continuing top3 firms
            temp2(j) = -omega_top3(i-p,j)*(log(S_j_top3(i,j)/S_j_top3(i-p,j)));
        end
        temp3(j) = omega_top3(i-p,j)* log(S_j(i,j)./S_j(i-p,j));
        % check1(i,j) =  log(S_j_top3(i,j)/S_j_top3(i-p,j));
        % check2(i,j) =  log(S_j(i,j)./S_j(i-p,j));
        temp4(j) = omega_top3(i-p,j)*(log(S_j_top3(i,j)/S_j_top3(i-p,j)) + log(S_j(i,j)/S_j(i-p,j)) );
        temp5(j) = -omega_top3(i-p,j)*( (1/(Par.sigma(j)-1)) / (Par.sigma(j)/(Par.sigma(j)-1) - gamma_j_vec(j) ) ) * log( firm_num_mat(i,j) / firm_num_mat(i-p,j) );
        within_sector_continuing(i-p,j) = temp1(j)/omega_top3(i-p,j);
        within_sector_entry(i-p,j) = -temp2(j)/omega_top3(i-p,j);
        within_sector(i-p,j) = within_sector_continuing(i-p,j) + within_sector_entry(i-p,j);
    end
    temp1(isnan(temp1))=0;
    temp2(isnan(temp2))=0;
    continuing_margin(i-p) = sum(temp1);
    entry_exit_margin(i-p) = -sum(temp2);
    sector_margin(i-p) = sum(temp3);
    entire_margin(i-p) = sum(temp4);
    variety_margin(i-p) = sum(temp5);
    productivity_margin(i-p) = sum(productivity_temp(:,i));
    export_margin(i-p) = sum(export_temp(:,i));
end

CR_change_decompose = continuing_margin + entry_exit_margin + sector_margin;
CR_change_given = log(CR3(1+p:end)./CR3(1:end-p));
CR3_sector_change = log(CR3_sector(1+p:end,:)./CR3_sector(1:end-p,:));
