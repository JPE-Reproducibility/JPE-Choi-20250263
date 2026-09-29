function residual = model_relative_residual(x_next,x_current)
% Scale-invariant fixed-point residual with finite-value validation.

if any(~isfinite(x_next(:))) || any(~isfinite(x_current(:)))
    error('model_relative_residual:NonfiniteIterate',...
        'A fixed-point iteration produced a nonfinite value.');
end
if ~isvector(x_next) || ~isvector(x_current)
    stack = dbstack(1);
    if isempty(stack)
        caller = 'unknown caller';
    else
        caller = sprintf('%s line %d',stack(1).name,stack(1).line);
    end
    error('model_relative_residual:NonvectorIterate',...
        ['Fixed-point iterates must be vectors. x_next is %s and '...
        'x_current is %s in %s.'],mat2str(size(x_next)),...
        mat2str(size(x_current)),caller);
end

x_next = x_next(:);
x_current = x_current(:);
if numel(x_next)~=numel(x_current)
    error('model_relative_residual:IterateSizeMismatch',...
        'x_next has %d elements but x_current has %d.',...
        numel(x_next),numel(x_current));
end
residual = max(abs(x_next-x_current)./max(1,abs(x_current)));
end
