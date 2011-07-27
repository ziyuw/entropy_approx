function [trust_lb, trust_ub] = compute_bound(centre, trust_radius, lb, ub)

trust_lb = zeros(size(lb));
trust_ub = zeros(size(ub));

for i = 1:size(lb, 1)
    trust_lb(i) = max(centre(i) - trust_radius, lb(i));
    trust_ub(i) = min(centre(i) + trust_radius, ub(i));
end

