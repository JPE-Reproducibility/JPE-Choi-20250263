function x = normalize_model_warm_start(x,expected_length,context)
% Convert a stored model guess to one deterministic state-vector column.

if isvector(x)
    x = x(:);
elseif size(x,1)==expected_length
    warning('normalize_model_warm_start:MultipleColumns',...
        ['%s supplied %d warm-start columns. Using the first column; '...
        'all subsequent iterates will be vectors.'],context,size(x,2));
    x = x(:,1);
else
    error('normalize_model_warm_start:InvalidShape',...
        '%s has size %s; expected a vector with %d elements.',...
        context,mat2str(size(x)),expected_length);
end

if numel(x)~=expected_length
    error('normalize_model_warm_start:InvalidLength',...
        '%s has %d elements; expected %d.',...
        context,numel(x),expected_length);
end
end
