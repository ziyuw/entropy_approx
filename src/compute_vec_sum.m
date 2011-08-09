function vec_sum = compute_vec_sum(s, h, nu, factor_edges, maxComplexity, num_samples)

nu_last = nu(size(nu, 1));
nu = nu(1:size(nu, 1)-1, 1);

a = 2*exp(1)/(exp(1)-exp(-1)) - 1;
b = 2/(exp(1)-exp(-1));
dim = size(s, 1) + size(factor_edges, 1);


%  normal_sum = compute_sum(s, h, nu, factor_edges, maxComplexity)*a;
%  vec_sum = zeros(dim, 1);
%  for i = 1:dim
%      nu(i) = nu(i) + 1;
%      vec_sum(i) = b*compute_sum(s, h, nu, factor_edges, maxComplexity) - normal_sum;
%      nu(i) = nu(i) - 1;
%  end
%  vec_sum(dim + 1) = -normal_sum/a;
%  
%  vec_sum_2 = vec_sum;

if ~exist('num_samples')
    normal_sum = compute_sum(s, h, nu, factor_edges, maxComplexity)*a;
    vec_sum = zeros(dim, 1);
    for i = 1:dim
	nu(i) = nu(i) + 1;
	vec_sum(i) = b*compute_sum(s, h, nu, factor_edges, maxComplexity) - normal_sum;
	nu(i) = nu(i) - 1;
    end
    vec_sum(dim + 1) = -normal_sum/a;
else
    empty_mapping = compute_mapping(s, []);
    empty_working_nodes = cat(1, s, []);
    
    [normal_sum, samples] = compute_sum(s, h, nu, factor_edges, maxComplexity, num_samples);

    vec_sum = zeros(dim, 1);

    for i = 1:num_samples
	vec_sum = vec_sum + exp(factors(samples(:, i), s, [], factor_edges, empty_mapping, empty_working_nodes));
    end

    vec_sum = (vec_sum*b/num_samples - a)*normal_sum;
    vec_sum(dim+1) = -normal_sum;
end

%  norm(vec_sum-vec_sum_2)/norm(vec_sum)
vec_sum = vec_sum/exp(nu_last);




