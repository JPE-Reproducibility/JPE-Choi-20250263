function period_cache = build_counterfactual_period_cache(...
    year_vec,balance,result,intsh,pop_data,secid_full,secid_service,...
    secid_manu,result_agg,hour_data,alpha_j_mat,Par)
% Cache yearly inputs that are unchanged across counterfactual iterations.

num_year = length(year_vec);
num_sector = length(secid_full);
period_cache = cell(num_year,1);

for year_index=1:num_year
    year_value = year_vec(year_index);
    balance_index = balance.year==year_value;
    [is_present,loc] = ismember(balance.secid(balance_index),secid_full);
    if any(~is_present)
        error('build_counterfactual_period_cache:UnknownSector',...
            'The balance data contain an unknown sector in year %d.',year_value);
    end
    if any(loc>length(secid_manu))
        error('build_counterfactual_period_cache:UnexpectedServiceFirm',...
            'The balance data contain a service-sector firm in year %d.',year_value);
    end

    firm_counts = accumarray(loc,1,[length(secid_manu),1]);
    firm_num = [firm_counts+1;ones(length(secid_service),1)];
    total_firm = sum(firm_num);

    gamma_j_i_mat = zeros(num_sector,num_sector);
    for j=1:num_sector
        for k=1:num_sector
            value_index = intsh.dsecid==secid_full(j)...
                & intsh.osecid==secid_full(k)...
                & intsh.year==year_value;
            values = intsh.intsh(value_index);
            if numel(values)~=1
                error('build_counterfactual_period_cache:InputOutputMatch',...
                    ['Expected one input-output observation for sectors '...
                    '%d/%d in year %d.'],...
                    secid_full(j),secid_full(k),year_value);
            end
            gamma_j_i_mat(k,j) = values;
        end
        column_sum = sum(gamma_j_i_mat(:,j));
        if column_sum<=0
            error('build_counterfactual_period_cache:InputOutputSum',...
                ['Input-output shares have a nonpositive sum in sector '...
                '%d, year %d.'],secid_full(j),year_value);
        end
        gamma_j_i_mat(:,j) = gamma_j_i_mat(:,j)/column_sum;
    end

    result_index = result.year==year_value;
    if sum(result_index)~=total_firm
        error('build_counterfactual_period_cache:FirmCountMismatch',...
            'Cached firm count does not match result rows in year %d.',...
            year_value);
    end

    period.mom.pop = pop_data.Lhat(pop_data.year==year_value);
    period.mom.secid_full = secid_full;
    period.mom.secid_manu = secid_manu;
    period.mom.gamma_j_i_vec = gamma_j_i_mat(:);
    period.mom.firm_num = firm_num;
    period.mom.model_cache = build_model_static_cache(...
        firm_num,secid_full,gamma_j_i_mat,Par);

    period.shock_firm.tau_l_vec = result.tau_l(result_index);
    period.shock_firm.tau_k_vec = result.tau_k(result_index);
    period.shock_firm.A_fj_vec = result.A_fj(result_index);
    period.shock_firm.DF_vec = result.DF(result_index);
    period.shock_firm.DF_real = result.DF_real(result_index);
    period.shock_firm.firmid = result.firmid(result_index);
    period.shock_firm.top3_vec = result.top3(result_index);
    period.shock_firm.fringe_vec = result.firmid(result_index)<0 ...
        & result.secid(result_index)<=max(secid_manu);

    period.shock_agg.P_j_F = result_agg.P_j_F_vec(year_index,:)';
    period.shock_agg.def_vec = result_agg.def_vec(year_index,:)';
    period.shock_agg.phi_bar = result_agg.phi_bar_vec(year_index);
    period.shock_agg.hour_data = hour_data(year_index);
    period.alpha_j = alpha_j_mat(year_index,:)';
    period.total_firm = total_firm;
    period_cache{year_index} = period;
end
end
