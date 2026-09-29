%% Removing granular shock for Samsung
lmd_samsung = zeros(1,5);
CR3_samsung = zeros(length(year_vec),5);
GDP_samsung = zeros(length(year_vec),5);


result_samsung_a = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
result_samsung_DF = join(result,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_samsung_tau_l = join(result,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_samsung_tau_k = join(result,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

result_samsung = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
result_samsung = join(result_samsung,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_samsung = join(result_samsung,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_samsung = join(result_samsung,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

result_samsung_a=sortrows(result_samsung_a,{'firmid', 'year'});
result_samsung_DF=sortrows(result_samsung_DF,{'firmid', 'year'});
result_samsung_tau_l = sortrows(result_samsung_tau_l,{'firmid', 'year'});
result_samsung_tau_k= sortrows(result_samsung_tau_k,{'firmid', 'year'});
result_samsung = sortrows(result_samsung,{'firmid','year'});
result = sortrows(result,{'firmid','year'});

firmRows = find(result_samsung_a.firmid == 7248);
for j=2:length(firmRows)   
    if result.continuing(firmRows(j))==1
        result_samsung_tau_k.tau_k(firmRows(j)) = result_samsung_tau_k.tau_k(firmRows(j-1))...
            .*result_samsung_tau_k.tau_k_g_sector(firmRows(j));        
        result_samsung_tau_l.tau_l(firmRows(j)) = result_samsung_tau_l.tau_l(firmRows(j-1))...
            .*result_samsung_tau_l.tau_l_g_sector(firmRows(j));      
        result_samsung_a.A_fj(firmRows(j)) = result_samsung_a.A_fj(firmRows(j-1))...
            .*result_samsung_a.a_g_sector(firmRows(j));      
        result_samsung.tau_k(firmRows(j)) = result_samsung.tau_k(firmRows(j-1))...
            .*result_samsung.tau_k_g_sector(firmRows(j));        
        result_samsung.tau_l(firmRows(j)) = result_samsung.tau_l(firmRows(j-1))...
            .*result_samsung.tau_l_g_sector(firmRows(j));      
        result_samsung.A_fj(firmRows(j)) = result_samsung.A_fj(firmRows(j-1))...
            .*result_samsung.a_g_sector(firmRows(j)); 
    end
    if result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1
        result_samsung_DF.DF(firmRows(j)) = result_samsung_DF.DF(firmRows(j-1))...
        .*result_samsung_DF.df_g_sector(firmRows(j));      
        result_samsung.DF(firmRows(j)) = result_samsung.DF(firmRows(j-1))...
        .*result_samsung.df_g_sector(firmRows(j));      
    end
end

result_samsung_a = sortrows(result_samsung_a, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_samsung_DF = sortrows(result_samsung_DF, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_samsung_tau_k= sortrows(result_samsung_tau_k, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_samsung_tau_l= sortrows(result_samsung_tau_l, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result_samsung= sortrows(result_samsung, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 
result = sortrows(result, {'year','secid','firmid'});  % Sort data by year, secid, and firmid 