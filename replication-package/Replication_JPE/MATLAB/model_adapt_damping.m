function [dmp,dmp_small] = model_adapt_damping(...
    dmp,dmp_small,current_residual,previous_residual)
% Increase damping after clear progress and reduce it after deterioration.

if ~isscalar(dmp) || ~isscalar(dmp_small) ...
        || ~isscalar(current_residual) || ~isscalar(previous_residual)
    error('model_adapt_damping:NonScalarInput',...
        ['Damping and residual inputs must be scalars; received sizes '...
        '%s, %s, %s, and %s.'],mat2str(size(dmp)),...
        mat2str(size(dmp_small)),mat2str(size(current_residual)),...
        mat2str(size(previous_residual)));
end
if ~isfinite(previous_residual)
    return
end

if current_residual<0.9*previous_residual
    dmp = min(1.15*dmp,0.25);
    dmp_small = min(1.15*dmp_small,0.15);
elseif current_residual>1.05*previous_residual
    dmp = max(0.5*dmp,0.005);
    dmp_small = max(0.5*dmp_small,0.0025);
end
end
