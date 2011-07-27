function [samples, weights, estimated_pf, importance_struct] = importance_sampler(obj_func, num_samples, s, h, edges, factor_edges, options, importance_struct)

if isfield(importance_struct, 'theta')
    theta = importance_struct.theta;
    nu = importance_struct.nu;
else
    % Initialized theta and nu to be random
    theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);
    nu = (rand(size(s, 1) + size(factor_edges,1) + 1, 1)-0.5)*2;
end

temperature = 1;
qphandle = 0;
exact = true;

if isfield(options, 'maxComplexity')
    maxComplexity = options.maxComplexity;
else
    maxComplexity = 2000;
end

if isfield(options, 'num_iter')
    num_iter = options.num_iter;
else
    num_iter = 20;
end

if isfield(options, 'num_samples_opt')
    num_samples_opt = options.num_samples_opt;
else
    num_samples_opt = 100;
end

auxdata = {s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples_opt, exact};

[theta, nu] = optimize_iter(nu, theta, auxdata, obj_func, num_iter, 'trust');

% Draw samples
samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples);

norm = 0;
stat = zeros(size(samples, 1));

proposal = @(x)exp(compute_log_prob(x, s, h, theta, edges, maxComplexity));

weights = zeros(num_samples, 1);

for i = 1:size(samples, 2)
    w = (samples(:, i)+1)/2;
    weights(i) = exp(-obj_func(samples(:, i)) - log(proposal(samples(:, i))));
end

estimated_pf = mean(weights);
weights = weights/estimated_pf;

importance_struct.theta = theta;
importance_struct.nu = nu;
