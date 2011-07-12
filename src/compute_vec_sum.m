function vec_sum = compute_vec_sum(s, h, nu, factor_edges, maxComplexity)

a = 2*exp(1)/(exp(1)-exp(-1)) - 1;
b = 2/(exp(1)-exp(-1));
dim = size(s, 1) + size(factor_edges, 1);

normal_sum = compute_sum(s, h, nu, factor_edges, maxComplexity)*a;
vec_sum = zeros(dim, 1);
for i = 1:dim
    nu(i) = nu(i) + 1;
    vec_sum(i) = b*compute_sum(s, h, nu, factor_edges, maxComplexity) - normal_sum;
    nu(i) = nu(i) - 1;
end

