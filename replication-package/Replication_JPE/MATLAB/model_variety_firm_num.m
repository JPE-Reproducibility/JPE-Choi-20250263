function firm_num_equation = model_variety_firm_num(firm_num,Par)
% Firm-count term used by the active model equations.
% The love-of-variety robustness specification suppresses this term while
% retaining the actual firm counts for indexing and aggregation.

firm_num_equation = firm_num(:);
if isfield(Par,'with_variety') && Par.with_variety
    firm_num_equation = ones(size(firm_num_equation));
end
end
