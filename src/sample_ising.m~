ising_dim = 4;

[vertices, full_edges] = latticeConnectivityPattern(ising_dim);
true_theta = rand(size(vertices, 1) + size(full_edges, 1), 1);
dim = size(true_theta, 1);
num_variable = size(vertices, 1);
obj_func = @(x)(true_theta'*factors(x, vertices, [], full_edges));


% Basic settings
s = (1:num_variable)';
h = [];

init_temp = 0.02;
final_temp = 0.2;
qphandle = 0;
exact = true;

maxComplexity = 2000;
num_samples = 100;
num_iter = 5;
m = 10;

num_instance = 2;

opt_structs = cell(num_instance, 1);

for i = 1:num_instance
    % Randomly generate linear tree edges
    perm = randperm(num_variable);
    edges = cat(2, perm(1, 1:size(perm, 2)-1)', perm(1, 2:size(perm, 2))');
    factor_edges = edges;
    theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);

    opt_struct.s = s;
    opt_struct.h = h;
    opt_struct.edges = edges;
    opt_struct.factor_edges = factor_edges;
    opt_struct.exact = exact;
    opt_struct.maxComplexity = maxComplexity;
    opt_struct.num_samples = num_samples;
    opt_struct.method = 'trust';
    opt_struct.m = m;
    opt_struct.theta = theta;
    opt_struct.init_temp = init_temp;
    opt_struct.final_temp = final_temp;
    opt_struct.num_iter = num_iter;

    opt_structs(i, 1) = {opt_struct};
end

thetas = cell(num_instance, 1);

parfor i = 1:num_instance
    % Randomly generate linear tree edges
    perm = randperm(num_variable);
    edges = cat(2, perm(1, 1:size(perm, 2)-1)', perm(1, 2:size(perm, 2))');
    factor_edges = edges;
    theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);

    % Do Optimization
    [theta, theta_array] = optimize(obj_func, opt_structs{i});
    thetas(i) = {theta};
end

thetas{1}


%  % Draw samples
%  num_samples = 1000;
%  raw_samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples, true);
%  
%  % ========================================================
%  % Compute statistics through MCMC
%  % ========================================================
%  samples = raw_samples;
%  
%  mapping = compute_mapping(s, h);
%  proposal = @(x)compute_log_prob(x, s, h, theta, edges, maxComplexity);
%  [samples, num_samples] = mh_rule(samples, num_samples, proposal, obj_func, mapping, s);
%  
%  stat = zeros(size(samples, 1));
%  for i = 1:num_samples
%      w = (samples(:, i)+1)/2;
%      stat = stat + w*w';
%  end
%  
%  expected_stat_MCMC = stat/num_samples
%  
%  
%  % ========================================================
%  % Compute Moments by Exact Sampling
%  % ========================================================
%  
%  
%  num_samples = 1000;
%  [samples, pf] = exact_sample(vertices, [], full_edges, true_theta, maxComplexity, num_samples);
%  stat = zeros(size(samples, 1));
%  for i = 1:num_samples
%      w = (samples(:, i)+1)/2;
%      stat = stat + w*w';
%  end
%  
%  expected_stat_exact = stat/num_samples
%  
%  
%  norm_difference = norm(expected_stat_exact-expected_stat_MCMC)