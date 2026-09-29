function value = counterfactual_warm_value_or_default(...
    warm_start,field,index,expected_size,default_value)
% Return a finite warm-cache value only when its shape matches exactly.

value = default_value;
if ~isstruct(warm_start) || ~isfield(warm_start,field)
    return
end

candidate = warm_start.(field);
if ~isempty(index)
    if ~iscell(candidate) || numel(candidate)<index
        return
    end
    candidate = candidate{index};
end

if isnumeric(candidate) && isequal(size(candidate),expected_size) && ...
        all(isfinite(candidate(:)))
    value = candidate;
end

end
