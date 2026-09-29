% Remove granular shock to all firms
age_max = max(result.age_bin);

% Get sector level unweighted average
result = sortrows(result,{'firmid', 'year'});
firmid_temp = result.firmid;
year_temp = result.year;
a_temp = result.A_fj;
df_temp = result.DF;
tau_l_temp = result.tau_l;
tau_k_temp = result.tau_k;

% Dummy whether it is same firm as previous, and consecutive year from previous one
result.continuing =[ 0; ( (firmid_temp(2:end) == firmid_temp(1:end-1)) & (year_temp(2:end) == year_temp(1:end-1)+1) )];
result.exporting = [0;( df_temp(2:end)>0 & df_temp(1:end-1)>0)];
% Get DHS growth rate of shocks
a_g = [NaN ;(a_temp(2:end) - a_temp(1:end-1)) ./ (0.5 * (a_temp(2:end) + a_temp(1:end-1)) )];
df_g = [NaN ;(df_temp(2:end) - df_temp(1:end-1)) ./ (0.5 * (df_temp(2:end) + df_temp(1:end-1)) )];
tau_l_g = [NaN ;(tau_l_temp(2:end) - tau_l_temp(1:end-1)) ./ (0.5 * (tau_l_temp(2:end) + tau_l_temp(1:end-1)) )];
tau_k_g = [NaN ;(tau_k_temp(2:end) - tau_k_temp(1:end-1)) ./ (0.5 * (tau_k_temp(2:end) + tau_k_temp(1:end-1)) )];

result.a_g(result.continuing==1) = a_g(result.continuing==1);
result.a_g(result.continuing==0) =NaN;
result.df_g(result.continuing==1 & result.exporting==1) = df_g(result.continuing==1 & result.exporting==1);
result.df_g(result.continuing==0 | result.exporting==0) =NaN;
result.tau_l_g(result.continuing==1) = tau_l_g(result.continuing==1);
result.tau_l_g(result.continuing==0) =NaN;
result.tau_k_g(result.continuing==1) = tau_k_g(result.continuing==1);
result.tau_k_g(result.continuing==0) =NaN;

a_g_sector = zeros(length(year_vec),length(secid_full),age_max);
df_g_sector = zeros(length(year_vec),length(secid_full),age_max);
tau_l_g_sector = zeros(length(year_vec),length(secid_full),age_max);
tau_k_g_sector = zeros(length(year_vec),length(secid_full),age_max);
a_g_agg = zeros(length(year_vec),age_max);
tau_k_g_agg = zeros(length(year_vec),age_max);
tau_l_g_agg = zeros(length(year_vec),age_max);
df_g_agg = zeros(length(year_vec),age_max);
result.a_g_trc = result.a_g;
result.df_g_trc = result.df_g;
result.tau_l_g_trc = result.tau_l_g;
result.tau_k_g_trc = result.tau_k_g;

% for i=1:length(year_vec)
    for j=1:length(secid_manu)
        for k=1:age_max
        lower_bound = prctile(result.a_g(result.secid==j & result.age_bin==k), 5);
        upper_bound = prctile(result.a_g( result.secid==j & result.age_bin==k), 95);
        result.a_g_trc(result.a_g_trc <= lower_bound & result.secid==j & result.age_bin==k) = lower_bound;
        result.a_g_trc(result.a_g_trc >= upper_bound & result.secid==j & result.age_bin==k) = upper_bound;

        lower_bound = prctile(result.df_g(result.secid==j & result.age_bin==k), 5);
        upper_bound = prctile(result.df_g( result.secid==j & result.age_bin==k), 95);
        result.df_g_trc(result.df_g_trc <= lower_bound  & result.secid==j & result.age_bin==k) = lower_bound;
        result.df_g_trc(result.df_g_trc >= upper_bound & result.secid==j & result.age_bin==k) = upper_bound;

        lower_bound = prctile(result.tau_l_g( result.secid==j & result.age_bin==k), 5);
        upper_bound = prctile(result.tau_l_g( result.secid==j & result.age_bin==k), 95);
        result.tau_l_g_trc(result.tau_l_g_trc <= lower_bound  & result.secid==j & result.age_bin==k) = lower_bound;
        result.tau_l_g_trc(result.tau_l_g_trc >= upper_bound  & result.secid==j & result.age_bin==k) = upper_bound;

        lower_bound = prctile(result.tau_k_g(result.secid==j & result.age_bin==k), 5);
        upper_bound = prctile(result.tau_k_g(result.secid==j & result.age_bin==k), 95);
        result.tau_k_g_trc(result.tau_k_g_trc <= lower_bound  & result.secid==j & result.age_bin==k) = lower_bound;
        result.tau_k_g_trc(result.tau_k_g_trc >= upper_bound  & result.secid==j & result.age_bin==k ) = upper_bound;
        end
    end


for i=1:length(year_vec)
    for j=1:length(secid_full)
        for k=1:age_max
            a_g_sector(i,j,k)=mean(result.a_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.a_g) & result.age_bin==k  ) );
            df_g_sector(i,j,k)=mean(result.df_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.df_g) & result.age_bin==k  ) );
            tau_l_g_sector(i,j,k)=mean(result.tau_l_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.tau_l_g) & result.age_bin==k) );
            tau_k_g_sector(i,j,k)=mean(result.tau_k_g_trc(result.year==year_vec(i) & result.secid==secid_full(j) & ~isnan(result.tau_k_g) & result.age_bin==k) );
        end
    end
    for k=1:age_max
        a_g_agg(i,k) = mean( result.a_g_trc(result.year==year_vec(i) & ~isnan(result.a_g) & result.age_bin==k ) );
        tau_k_g_agg(i,k) = mean( result.tau_k_g_trc(result.year==year_vec(i) & ~isnan(result.tau_k_g) & result.age_bin==k ) );
        tau_l_g_agg(i,k) = mean( result.tau_l_g_trc(result.year==year_vec(i) & ~isnan(result.tau_l_g) & result.age_bin==k ) );
        df_g_agg(i,k) = mean( result.df_g_trc(result.year==year_vec(i) & ~isnan(result.df_g) & result.age_bin==k ) );
    end
end
a_g_sector = (1+a_g_sector);
df_g_sector = (1+df_g_sector);
tau_l_g_sector = (1+tau_l_g_sector);
tau_k_g_sector = (1+tau_k_g_sector);
a_g_agg = (1+a_g_agg);
tau_k_g_agg = (1+tau_k_g_agg);
tau_l_g_agg = (1+tau_l_g_agg);
df_g_agg = (1+df_g_agg);

% Should we keep this?
result.a_g = result.a_g_trc;
result.df_g = result.df_g_trc;
result.tau_l_g = result.tau_l_g_trc;
result.tau_k_g = result.tau_k_g_trc;

DF_sector_growth = array2table([df_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'df_g_sector','year','secid','age_bin'});
tau_l_sector_growth = array2table([tau_l_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'tau_l_g_sector','year','secid','age_bin'});
tau_k_sector_growth = array2table([tau_k_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'tau_k_g_sector','year','secid','age_bin'});
A_sector_growth = array2table([a_g_sector(:) repmat(year_vec(1:end),num_sector*age_max,1) repelem(repmat(secid_full,age_max,1),length(year_vec)) repelem((1:age_max)',length(year_vec)*num_sector);0 0 0 0],'VariableNames',{'a_g_sector','year','secid','age_bin'});

DF_agg_growth = array2table([df_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length(year_vec));0 0 0],'VariableNames',{'df_g_agg','year','age_bin'});
tau_l_agg_growth = array2table([tau_l_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length(year_vec));0 0 0],'VariableNames',{'tau_l_g_agg','year','age_bin'});
tau_k_agg_growth = array2table([tau_k_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length(year_vec));0 0 0],'VariableNames',{'tau_k_g_agg','year','age_bin'});
A_agg_growth = array2table([a_g_agg(:) repmat(year_vec(1:end),age_max,1) repelem((1:age_max)',length(year_vec));0 0 0],'VariableNames',{'a_g_agg','year','age_bin'});

A_sector_level ...
    = array2table([A_avg_sector_unweighted_entrant(:) repmat(year_vec(1:end),num_sector,1) repelem(secid_full,length(year_vec));0 0 0],'VariableNames',{'a_level_sector','year','secid'});
A_agg_level ...
    = array2table([A_avg_year_entrant(:) year_vec(1:end);0 0],'VariableNames',{'a_level_agg','year'});



%% Removing granular shock for Top 3 firms

result = sortrows(result,{'year','secid','firmid'});

lmd_granular_top3=zeros(1,4);
CR3_granular_top3=zeros(length(year_vec),4);
GDP_granular_top3=zeros(length(year_vec),4);

result_top3_DF = join(result,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_tau_l = join(result,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_tau_k = join(result,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

result_top3_a_sector = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'}); % Sectoral growth rate
result_top3_a_agg = join(result,A_agg_growth,'Keys',{'year','age_bin'}); % Aggregate growth rate
result_top3_a_init_agg =  join(result,A_agg_level,'Keys',{'year'}); % Initial level as aggregate level
result_top3_a_init_sector =  join(result,A_sector_level,'Keys',{'secid','year'}); % Initial level as sectoral level
result_top3_a_init_g_agg =  join(result_top3_a_agg,A_agg_level,'Keys',{'year'}); % Initial level + growth aggregate
result_top3_a_init_g_sector =  join(result_top3_a_sector,A_sector_level,'Keys',{'secid','year'}); % Initial level + growth sectoral

result_top3_granular = join(result,A_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_granular = join(result_top3_granular,DF_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_granular = join(result_top3_granular,tau_l_sector_growth,'Keys',{'secid','year','age_bin'});
result_top3_granular = join(result_top3_granular,tau_k_sector_growth,'Keys',{'secid','year','age_bin'});

% First, make counterfactual productivity for top3 firms
% Sort data by firmid and year
result = sortrows(result,{'firmid', 'year'});
result_top3_a_sector=sortrows(result_top3_a_sector,{'firmid', 'year'});
result_top3_a_agg=sortrows(result_top3_a_agg,{'firmid', 'year'});
result_top3_a_init_agg=sortrows(result_top3_a_init_agg,{'firmid', 'year'});
result_top3_a_init_sector=sortrows(result_top3_a_init_sector,{'firmid', 'year'});
result_top3_a_init_g_agg=sortrows(result_top3_a_init_g_agg,{'firmid', 'year'});
result_top3_a_init_g_sector =sortrows(result_top3_a_init_g_sector,{'firmid', 'year'});

result_top3_DF=sortrows(result_top3_DF,{'firmid', 'year'});
result_top3_tau_k= sortrows(result_top3_tau_k,{'firmid', 'year'});
result_top3_tau_l = sortrows(result_top3_tau_l,{'firmid', 'year'});
result_top3_granular = sortrows(result_top3_granular,{'firmid', 'year'});

top3_all=unique(result.firmid(result.top3==1)); % & result.firmid~=8973
for i = 1:length(top3_all)
    firmRows = find(result.firmid==top3_all(i));
    for j=1:length(firmRows)
        if result.continuing(firmRows(j))==1 && result.top3(firmRows(j)) == 1 % When it has consecutive observations & top 3
        result_top3_tau_k.tau_k(firmRows(j)) ...
            = result_top3_tau_k.tau_k(firmRows(j-1))...
            .*result_top3_tau_k.tau_k_g_sector(firmRows(j));        
        result_top3_tau_l.tau_l(firmRows(j)) ...
            = result_top3_tau_l.tau_l(firmRows(j-1))...
            .*result_top3_tau_l.tau_l_g_sector(firmRows(j));        
        result_top3_a_sector.A_fj(firmRows(j)) ...
            = result_top3_a_sector.A_fj(firmRows(j-1))...
            .*result_top3_a_sector.a_g_sector(firmRows(j));
        result_top3_a_agg.A_fj(firmRows(j)) ...
            = result_top3_a_agg.A_fj(firmRows(j-1))...
            .*result_top3_a_agg.a_g_agg(firmRows(j));
        result_top3_a_init_agg.A_fj(firmRows(j)) ...
            = result_top3_a_init_agg.A_fj(firmRows(j-1))...
            .*(result_top3_a_init_agg.a_g(firmRows(j))+1);
        result_top3_a_init_sector.A_fj(firmRows(j)) ...
            = result_top3_a_init_sector.A_fj(firmRows(j-1))...
            .*(result_top3_a_init_sector.a_g(firmRows(j))+1);
        result_top3_a_init_g_agg.A_fj(firmRows(j)) ...
            = result_top3_a_init_g_agg.A_fj(firmRows(j-1))...
            .*result_top3_a_init_g_agg.a_g_agg(firmRows(j));
        result_top3_a_init_g_sector.A_fj(firmRows(j)) ...
            = result_top3_a_init_g_sector.A_fj(firmRows(j-1))...
            .*result_top3_a_init_g_sector.a_g_sector(firmRows(j));
        result_top3_granular.tau_k(firmRows(j)) ...
            = result_top3_granular.tau_k(firmRows(j-1))...
            .*result_top3_granular.tau_k_g_sector(firmRows(j));
        result_top3_granular.tau_l(firmRows(j)) ...
            = result_top3_granular.tau_l(firmRows(j-1))...
            .*result_top3_granular.tau_l_g_sector(firmRows(j));
        result_top3_granular.A_fj(firmRows(j)) ...
            = result_top3_granular.A_fj(firmRows(j-1))...
            .*result_top3_granular.a_g_sector(firmRows(j));
        elseif result.continuing(firmRows(j))==0  && result.year(firmRows(j))~=year_vec(1)
            result_top3_a_init_agg.A_fj(firmRows(j)) = result_top3_a_init_agg.a_level_agg(firmRows(j));
            result_top3_a_init_g_agg.A_fj(firmRows(j)) = result_top3_a_init_g_agg.a_level_agg(firmRows(j));
            result_top3_a_init_sector.A_fj(firmRows(j)) = result_top3_a_init_sector.a_level_sector(firmRows(j));
            result_top3_a_init_g_sector.A_fj(firmRows(j)) = result_top3_a_init_g_sector.a_level_sector(firmRows(j));
        elseif result.continuing(firmRows(j))==1 && result.top3(firmRows(j)) == 0
        result_top3_tau_k.tau_k(firmRows(j)) ...
            = result_top3_tau_k.tau_k(firmRows(j-1))...
            .*(result_top3_tau_k.tau_k_g(firmRows(j))+1);        
        result_top3_tau_l.tau_l(firmRows(j)) ...
            = result_top3_tau_l.tau_l(firmRows(j-1))...
            .*(result_top3_tau_l.tau_l_g(firmRows(j))+1);        
        result_top3_a_sector.A_fj(firmRows(j)) ...
            = result_top3_a_sector.A_fj(firmRows(j-1))...
            .*(result_top3_a_sector.a_g(firmRows(j))+1);
        result_top3_a_agg.A_fj(firmRows(j)) ...
            = result_top3_a_agg.A_fj(firmRows(j-1))...
            .*(result_top3_a_agg.a_g(firmRows(j))+1);
        result_top3_a_init_agg.A_fj(firmRows(j)) ...
            = result_top3_a_init_agg.A_fj(firmRows(j-1))...
            .*(result_top3_a_init_agg.a_g(firmRows(j))+1);
        result_top3_a_init_sector.A_fj(firmRows(j)) ...
            = result_top3_a_init_sector.A_fj(firmRows(j-1))...
            .*(result_top3_a_init_sector.a_g(firmRows(j))+1);
        result_top3_a_init_g_agg.A_fj(firmRows(j)) ...
            = result_top3_a_init_g_agg.A_fj(firmRows(j-1))...
            .*(result_top3_a_init_g_agg.a_g(firmRows(j))+1);
        result_top3_a_init_g_sector.A_fj(firmRows(j)) ...
            = result_top3_a_init_g_sector.A_fj(firmRows(j-1))...
            .*(result_top3_a_init_g_sector.a_g(firmRows(j))+1);
        result_top3_granular.tau_k(firmRows(j)) ...
            = result_top3_granular.tau_k(firmRows(j-1))...
            .*(result_top3_granular.tau_k_g(firmRows(j))+1);
        result_top3_granular.tau_l(firmRows(j)) ...
            = result_top3_granular.tau_l(firmRows(j-1))...
            .*(result_top3_granular.tau_l_g(firmRows(j))+1);
        result_top3_granular.A_fj(firmRows(j)) ...
            = result_top3_granular.A_fj(firmRows(j-1))...
            .*(result_top3_granular.a_g(firmRows(j))+1);
        end
        if result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1 && result.top3(firmRows(j)) == 1
            result_top3_DF.DF(firmRows(j)) ...
                = result_top3_DF.DF(firmRows(j-1))...
                .*result_top3_DF.df_g_sector(firmRows(j));
            result_top3_granular.DF(firmRows(j)) ...
                = result_top3_granular.DF(firmRows(j-1))...
                .*result_top3_granular.df_g_sector(firmRows(j));
        elseif result.continuing(firmRows(j))==1 && result.exporting(firmRows(j))==1 && result.top3(firmRows(j)) == 0
            result_top3_DF.DF(firmRows(j)) ...
                = result_top3_DF.DF(firmRows(j-1))...
                .*(result_top3_DF.df_g(firmRows(j))+1);
            result_top3_granular.DF(firmRows(j)) ...
                = result_top3_granular.DF(firmRows(j-1))...
                .*(result_top3_granular.df_g(firmRows(j))+1);
        end
    end
end

result_top3_a_sector=sortrows(result_top3_a_sector,{'year','secid','firmid'});
result_top3_a_agg=sortrows(result_top3_a_agg,{'year','secid','firmid'});
result_top3_a_init_agg=sortrows(result_top3_a_init_agg,{'year','secid','firmid'});
result_top3_a_init_sector=sortrows(result_top3_a_init_sector,{'year','secid','firmid'});
result_top3_a_init_g_agg=sortrows(result_top3_a_init_g_agg,{'year','secid','firmid'});
result_top3_a_init_g_sector=sortrows(result_top3_a_init_g_sector,{'year','secid','firmid'});
result_top3_DF=sortrows(result_top3_DF,{'year','secid','firmid'});
result_top3_tau_k= sortrows(result_top3_tau_k,{'year','secid','firmid'});
result_top3_tau_l = sortrows(result_top3_tau_l,{'year','secid','firmid'});
result_top3_granular = sortrows(result_top3_granular,{'year','secid','firmid'});
result = sortrows(result,{'year','secid','firmid'});

result_top3_DF.DF(result_top3_DF.DF<0)=0;
result_top3_granular.DF(result_top3_granular.DF<0)=0;