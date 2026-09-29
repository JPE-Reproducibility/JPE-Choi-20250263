function cache = build_model_static_cache(...
    firm_num,secid_full,gamma_j_i_mat,Par)
% Build objects that are constant across fixed-point evaluations.

firm_num = firm_num(:);
secid_full = secid_full(:);
num_sector = length(firm_num);
total_firm = sum(firm_num);
if length(secid_full)~=num_sector
    error('build_model_static_cache:SectorCountMismatch',...
        'firm_num has %d sectors but secid_full has %d.',...
        num_sector,length(secid_full));
end

sigma = sector_column(Par.sigma,num_sector,'Par.sigma');
rho = sector_column(Par.rho,num_sector,'Par.rho');
gamma_L = sector_column(Par.gamma_L,num_sector,'Par.gamma_L');
gamma_K = sector_column(Par.gamma_K,num_sector,'Par.gamma_K');
gamma_M = sector_column(Par.gamma_M,num_sector,'Par.gamma_M');
gamma_j = gamma_L+gamma_K+gamma_M;

cache.total_firm = total_firm;
cache.num_sector = num_sector;
cache.firm_num = firm_num;
cache.sigma = sigma;
cache.rho = rho;
cache.gamma_L = gamma_L;
cache.gamma_K = gamma_K;
cache.gamma_M = gamma_M;
cache.gamma_j = gamma_j;
cache.sector_agg = sparse(...
    repelem(1:num_sector,firm_num),1:total_firm,1,num_sector,total_firm);
if isfield(Par,'with_variety') && Par.with_variety
    cache.firm_num_vec = ones(total_firm,1);
else
    cache.firm_num_vec = repelem(firm_num,firm_num);
end
cache.sigma_vec = repelem(sigma,firm_num);
cache.rho_vec = repelem(rho,firm_num);
cache.gamma_L_vec = repelem(gamma_L,firm_num);
cache.gamma_K_vec = repelem(gamma_K,firm_num);
cache.gamma_M_vec = repelem(gamma_M,firm_num);
cache.gamma_j_vec = repelem(gamma_j,firm_num);
cache.mu_x_vec = repelem(sigma./(sigma-1),firm_num);
cache.fringe_idx = [1;cumsum(firm_num(1:end-1))+1];
cache.gamma_j_i_mat = gamma_j_i_mat;
cache.sector_vec = repelem(secid_full,firm_num);

log_gamma = zeros(size(gamma_j_i_mat));
positive = gamma_j_i_mat>0;
log_gamma(positive) = log(gamma_j_i_mat(positive));
cache.gamma_entropy = -sum(gamma_j_i_mat.*log_gamma,1)';
end

function values = sector_column(values,num_sector,name)
if isscalar(values)
    values = repmat(values,num_sector,1);
elseif numel(values)==num_sector
    values = values(:);
else
    error('build_model_static_cache:ParameterSizeMismatch',...
        '%s must be scalar or contain %d sector values; it contains %d.',...
        name,num_sector,numel(values));
end
end
