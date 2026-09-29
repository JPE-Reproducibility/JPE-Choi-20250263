% Collect some results in table
result.A_rel = block_result.A / A_year_guess(1);  % Relative productivity in 1972 level
result.sale_vec = result.p_d.*result.y_d + result.p_x.*result.y_x;
result.export_vec = result.p_x.*result.y_x;
result.s_l = block_result.s_l;
result.s_k = block_result.s_k;

result = sortrows(result,{'firmid', 'year'});
% Make pctile among the entrants
diff_firmid = [1;result.firmid(2:end) - result.firmid(1:end-1)]; % Whether firmid is same as the previous one or not
diff_year = [1;result.year(2:end) - result.year(1:end-1)]; % Whether firmid is same as the previous one or not
A_avg_year = zeros(length(year_vec),1);
A_avg_year_entrant = zeros(length(year_vec),1);
result.new_firm = (diff_firmid~=0 | diff_year>1);
result = sortrows(result,{'year','secid','firmid'});

for i=1:length(year_vec)
        result.A_pctile_new(result.year==year_vec(i) & result.new_firm==1) ...
            = invprctile(result.A_fj(result.year==year_vec(i) & result.new_firm==1),...
            result.A_fj(result.year==year_vec(i) & result.new_firm==1) );
        result.A_pctile_new(result.year==year_vec(i) & result.new_firm==0) = NaN;
        result.A_pctile(result.year==year_vec(i)) ...
            = invprctile(result.A_fj(result.year==year_vec(i)),...
            result.A_fj(result.year==year_vec(i)) );
        A_avg_year(i) = mean(result.A_fj(result.year==year_vec(i) & result.secid<=max(secid_manu) ) );
        A_avg_year_entrant(i) = mean(result.A_fj(result.year==year_vec(i) & result.new_firm==1 & result.secid<=max(secid_manu) ) ); 
end

%% Aggregate and sectoral shocks
A_avg_sector = zeros(length(year_vec),num_sector);
A_avg_sector_unweighted = zeros(length(year_vec),num_sector);
A_avg_sector_unweighted_entrant = zeros(length(year_vec),num_sector);
A_avg_vec = zeros(length(year_vec),1);
A_avg_manu = zeros(length(year_vec),1);
mu_y_avg_nofringe = zeros(length(year_vec),1);
mu_l_avg_nofringe = zeros(length(year_vec),1);
mu_y_avg_with_fringe = zeros(length(year_vec),1);
mu_l_avg_with_fringe = zeros(length(year_vec),1);
mu_y_agg = zeros(length(year_vec),1);
mu_l_agg  = zeros(length(year_vec),1);

DF_avg_sector = zeros(length(year_vec),num_sector);
DF_avg_sector_unweighted = zeros(length(year_vec),num_sector);
DF_avg_vec = zeros(length(year_vec),1);
DF_avg_manu = zeros(length(year_vec),1);

tau_l_var = zeros(length(year_vec),num_sector);
tau_k_var = zeros(length(year_vec),num_sector);
tau_l_var_avg = zeros(length(year_vec),1);
tau_k_var_avg = zeros(length(year_vec),1);
tau_l_avg_sector_unweighted = zeros(length(year_vec),num_sector);
tau_k_avg_sector_unweighted = zeros(length(year_vec),num_sector);
mu_y_agg_sector = zeros(length(year_vec),num_sector);
mu_l_agg_sector = zeros(length(year_vec),num_sector);
mu_y_avg_sector = zeros(length(year_vec),num_sector);

A_tau_l_corr_sector = zeros(length(year_vec),num_sector);
A_tau_k_corr_sector = zeros(length(year_vec),num_sector);
A_tau_l_corr = zeros(length(year_vec),1);
A_tau_k_corr = zeros(length(year_vec),1);
DF_tau_l_corr = zeros(length(year_vec),1);
DF_tau_k_corr = zeros(length(year_vec),1);
tau_l_top3_vec = zeros(length(year_vec),1);
tau_k_top3_vec = zeros(length(year_vec),1);
mu_l_top3_vec = zeros(length(year_vec),1);
mu_y_top3_vec = zeros(length(year_vec),1);
tau_k_avg =  zeros(length(year_vec),1);
tau_l_avg =  zeros(length(year_vec),1);
sale_sector = zeros(length(year_vec),num_sector);
top3_list =  [];
top3_seclist = [];
top3_tau_l = [];
top3_tau_k = [];
top3_mu_l = [];
top3_mu_y = [];
top3_A = [];
top3_A_avg = zeros(length(year_vec),1);
A_avg_nofringe = zeros(length(year_vec),1);
for i=1:length(year_vec)
        for j=1:num_sector
            sale_sector(i,j) = sum(result.sale_vec(result.year==year_vec(i) & result.secid==secid_full(j)) );
            A_fj_vec = result.A_fj(result.year==year_vec(i) & result.secid==secid_full(j) );
            sale_vec = result.sale_vec(result.year==year_vec(i) & result.secid==secid_full(j) );
            export_vec = result.export_vec(result.year==year_vec(i) & result.secid==secid_full(j) );
            y_d_vec = result.y_d(result.year==year_vec(i) & result.secid==secid_full(j) );
            y_x_vec = result.y_x(result.year==year_vec(i) & result.secid==secid_full(j) );

            sigma = est_result.sigma(est_result.secid==j);
            mu_y_tilde = result.mu_y(result.year==year_vec(i) & result.secid==secid_full(j))...
                                    .* (y_d_vec./(y_d_vec+y_x_vec)) + sigma./(sigma-1)* (y_x_vec./(y_d_vec+y_x_vec));
            mu_l_vec = result.mu_l(result.year==year_vec(i) & result.secid==secid_full(j) );
            DF_vec = result.DF(result.year==year_vec(i) & result.secid==secid_full(j) );
            tau_l_vec = result.tau_l(result.year==year_vec(i) & result.secid==secid_full(j) )-1;
            tau_k_vec = result.tau_k(result.year==year_vec(i) & result.secid==secid_full(j) )-1;
            
            A_avg_sector(i,j) = wmean(A_fj_vec, sale_vec);
            A_avg_sector_unweighted(i,j) = mean(A_fj_vec);
            A_avg_sector_unweighted_entrant(i,j) = mean(result.A_fj(result.new_firm==1 & result.year==year_vec(i) & result.secid==secid_full(j) ));
            tau_l_avg_sector_unweighted(i,j) = mean(tau_l_vec+1);
            tau_k_avg_sector_unweighted(i,j) = mean(tau_k_vec+1);
            
            DF_avg_sector(i,j) = wmean(DF_vec.^(1/(sigma-1)), export_vec)^((sigma-1)/1);
            DF_avg_sector_unweighted(i,j) = mean(DF_vec);
            tau_l_var(i,j) = std(tau_l_vec);
            tau_k_var(i,j) = std(tau_k_vec);

            mu_y_agg_sector(i,j) = 1/wmean(mu_y_tilde.^(-1),sale_vec);
            mu_l_agg_sector(i,j) =  1/wmean( (mu_y_tilde.*mu_l_vec).^(-1), sale_vec)./mu_y_agg_sector(i,j);

        end
        A_fj_vec = result.A_fj(result.year==year_vec(i));
        A_fj_vec_wo_fringe = result.A_fj(result.year==year_vec(i) & result.firmid>0);
        A_fj_manu = result.A_fj(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        DF_vec = result.DF_real(result.year==year_vec(i));
        DF_manu = result.DF_real(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        sale_vec = result.sale_vec(result.year==year_vec(i));
        export_vec = result.export_vec(result.year==year_vec(i));
        tau_l_vec = result.tau_l(result.year==year_vec(i))-1;
        tau_k_vec = result.tau_k(result.year==year_vec(i))-1;
        tau_l_vec_wo_fringe = result.tau_l(result.year==year_vec(i) & result.firmid>0)-1;
        tau_k_vec_wo_fringe = result.tau_k(result.year==year_vec(i) & result.firmid>0)-1;
        
        sale_vec_manu = result.sale_vec(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        export_vec_manu = result.export_vec(result.year==year_vec(i) & ismember(result.secid,secid_manu));
        
        A_avg_vec(i) = wmean(A_fj_vec,sale_vec);
        DF_avg_vec(i) = wmean(DF_vec,export_vec);
        tau_l_var_avg(i) = wmean(tau_l_var(i,secid_manu)',sale_sector(i,secid_manu)');
        tau_k_var_avg(i) = wmean(tau_k_var(i,secid_manu)',sale_sector(i,secid_manu)');
        mu_y_agg(i) = wmean(mu_y_agg_sector(i,secid_manu)',domar_weight(i,secid_manu)');
        mu_l_agg(i) = wmean(mu_l_agg_sector(i,secid_manu)',domar_weight(i,secid_manu)');
        A_avg_manu(i) = wmean(A_fj_manu,sale_vec_manu);
        DF_avg_manu(i) = wmean(DF_manu,export_vec_manu);
   
        A_tau_l_corr(i) = corr(tau_l_vec,A_fj_vec);
        A_tau_k_corr(i) = corr(tau_k_vec,A_fj_vec);

        DF_tau_l_corr(i) = corr(tau_l_vec,DF_vec);
        DF_tau_k_corr(i) = corr(tau_k_vec,DF_vec);
        tau_k_avg(i) = mean(tau_k_vec);
        tau_l_avg(i) = mean(tau_l_vec);
        
        % Excluding fringe firms
        result_nofringe = result(result.firmid>0,:);
        result_nofringe.minus_sale = -1*result_nofringe.sale_vec;
        result_nofringe = sortrows(result_nofringe, {'year','minus_sale'});  % Sort data by year, secid, and firmid 
        tau_l_temp=result_nofringe.tau_l(result_nofringe.year==year_vec(i))-1;
        tau_k_temp=result_nofringe.tau_k(result_nofringe.year==year_vec(i))-1;
        mu_l_temp = result_nofringe.mu_l(result_nofringe.year==year_vec(i));
        mu_y_temp = result_nofringe.mu_y(result_nofringe.year==year_vec(i));
        mu_l_with_fringe = result.mu_l(result.year==year_vec(i));
        mu_y_with_fringe = result.mu_y(result.year==year_vec(i));
        
        A_temp = result_nofringe.A_fj(result_nofringe.year==year_vec(i));
        tau_l_top3_vec(i) =  mean(tau_l_temp(1:10));
        tau_k_top3_vec(i) =  mean(tau_k_temp(1:10));
        mu_l_top3_vec(i) = mean(mu_l_temp(1:10));
        mu_y_top3_vec(i) = mean(mu_y_temp(1:10));
        
        firm_list_temp = result_nofringe.firmid(result_nofringe.year==year_vec(i));
        sec_list_temp = result_nofringe.secid(result_nofringe.year==year_vec(i));

        top3_A_avg(i) = mean(A_temp(1:10));
        A_avg_nofringe(i) = mean(A_temp);
        mu_y_avg_nofringe(i) = mean(mu_y_temp);
        mu_l_avg_nofringe(i) = mean(mu_l_temp);
        mu_y_avg_with_fringe(i) = wmean(mu_y_with_fringe,sale_vec);
        mu_l_avg_with_fringe(i) = wmean(mu_l_with_fringe,sale_vec);        
end

% writetable(result,OUTPUT+'result_base.csv')

result.sale = result.p_d.*result.y_d + result.p_x.*result.y_x;
result = sortrows(result,{'firmid','year'});

num_top=3;
result.top3 = zeros(height(result),1);
top3_list = zeros(length(year_vec),num_top*length(secid_manu));
for i=1:length(year_vec)
    result.minus_sale = -result.sale;
    result.fringe = (result.firmid<0);
    result.year_check=(result.year~=year_vec(i));
    top3_list_year = [];
    for j=1:length(secid_manu)
        result.secid_check = (result.secid~=j);
        result = sortrows(result, {'year_check','secid_check','fringe','minus_sale'});  
        result.top3(1:num_top) = 1;
        top3_list_year = [top3_list_year;result.firmid(result.top3==1 & result.year==year_vec(i) & result.secid==j)];
    end
    result = sortrows(result,{'firmid'});
    top3_list(i,:) = top3_list_year;
end
result = sortrows(result,{'year','secid','firmid'});