%% Removing granular shock for hyundai
lmd_hyundai=zeros(1,5);
CR3_hyundai = zeros(length(year_vec),5);
GDP_hyundai = zeros(length(year_vec),5);


result_hyundai_a = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
result_hyundai_DF = join(result,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_hyundai_tau_l = join(result,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_hyundai_tau_k = join(result,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

result_hyundai = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
result_hyundai = join(result_hyundai,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_hyundai = join(result_hyundai,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_hyundai = join(result_hyundai,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

result_hyundai_a=sortrows(result_hyundai_a,{'firmid', 'year'});
result_hyundai_DF=sortrows(result_hyundai_DF,{'firmid', 'year'});
result_hyundai_tau_l = sortrows(result_hyundai_tau_l,{'firmid', 'year'});
result_hyundai_tau_k= sortrows(result_hyundai_tau_k,{'firmid', 'year'});
result_hyundai = sortrows(result_hyundai,{'firmid','year'});
result = sortrows(result,{'firmid','year'});

firmRows = find(result_hyundai_a.firmid == 7266);
for j=2:length(firmRows)   
    if result.continuing(firmRows(j))==1
        result_hyundai_tau_k.tau_k(firmRows(j)) = result_hyundai_tau_k.tau_k(firmRows(j-1))...
            .*result_hyundai_tau_k.tau_k_g_sector(firmRows(j));        
        result_hyundai_tau_l.tau_l(firmRows(j)) = result_hyundai_tau_l.tau_l(firmRows(j-1))...
            .*result_hyundai_tau_l.tau_l_g_sector(firmRows(j));      
        result_hyundai_a.A_fj(firmRows(j)) = result_hyundai_a.A_fj(firmRows(j-1))...
            .*result_hyundai_a.a_g_sector(firmRows(j));      
        result_hyundai.tau_k(firmRows(j)) = result_hyundai.tau_k(firmRows(j-1))...
            .*result_hyundai.tau_k_g_sector(firmRows(j));        
        result_hyundai.tau_l(firmRows(j)) = result_hyundai.tau_l(firmRows(j-1))...
            .*result_hyundai.tau_l_g_sector(firmRows(j));      
        result_hyundai.A_fj(firmRows(j)) = result_hyundai.A_fj(firmRows(j-1))...
            .*result_hyundai.a_g_sector(firmRows(j)); 
    end
    if result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1
        result_hyundai_DF.DF(firmRows(j)) = result_hyundai_DF.DF(firmRows(j-1))...
        .*result_hyundai_DF.df_g_sector(firmRows(j));      
        result_hyundai.DF(firmRows(j)) = result_hyundai.DF(firmRows(j-1))...
        .*result_hyundai.df_g_sector(firmRows(j));      
    end
end


result_hyundai_a = sortrows(result_hyundai_a, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_hyundai_DF = sortrows(result_hyundai_DF, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_hyundai_tau_k= sortrows(result_hyundai_tau_k, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_hyundai_tau_l= sortrows(result_hyundai_tau_l, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_hyundai= sortrows(result_hyundai, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result = sortrows(result, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 