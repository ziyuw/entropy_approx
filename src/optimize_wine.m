% Setting random seed
%  rng(112)

% Preparing Data
%  dim = 5;
%  load('/home/zwang/development/data/UCI_BC.mat');
%  X = X(:, 1:dim);
%  lambda = 1;
% obj_func = @(s)funcG(s, X, Y, lambda);

s = [1;2;3;4;5];
full_edges = [1,2;1,3;2,3;1,4;2,4;3,4;1,5;2,5;3,5;4,5];
true_theta = (rand(size(s,1) + size(full_edges,1), 1)*2-1);
obj_func = @(x)(true_theta'*factors(x, s, [], full_edges));

minFunc_optitions.Display = 'off';
minFunc_optitions.Method = 'qnewton';

  
% Basic settings
s = [1;2;3;4;5];
h = [6;7];
%  ;1,6;2,6;3,6;4,6;5,6;1,7;2,7;3,7;4,7;5,7
edges = [1,3;1,4;2,4;2,5;3,5;1,6;2,6;3,6;4,6;5,6;1,7;2,7;3,7;4,7;5,7];
factor_edges = [1,3;1,4;2,4;2,5;3,5];

theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);
nu = (rand(size(s, 1) + size(factor_edges,1) + 1, 1)-0.5)*2;

temperature = 0.8;
qphandle = 0;
exact = true;

maxComplexity = 2000;
num_samples = 100;
auxdata = {s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples, exact};


%  Compute the approximate true objective given theta
approx_true_obj = true_obj(s, h, theta, edges, obj_func, maxComplexity, temperature, num_samples)
nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata, obj_func), nu, minFunc_optitions);
original_obj = evaluate_obj(theta, nu, auxdata, obj_func)

% Optimization
tic
num_iter = 10;
[theta, nu] = optimize_iter(nu, theta, auxdata, obj_func, num_iter, 'trust');
optimization_time = toc

% Compute the approximate true objective given theta
approx_true_obj = true_obj(s, h, theta, edges, obj_func, maxComplexity, temperature, num_samples)
final_obj = evaluate_obj(theta, nu, auxdata, obj_func)

% Draw samples
num_samples = 1000;
raw_samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples, true);


% ========================================================
% Plain variational statistics
% ========================================================
mapping = compute_mapping(s, h);
samples = raw_samples(mapping(s), :);

stat = zeros(size(samples, 1));
for i = 1:size(samples, 2)
    w = (samples(:, i)+1)/2;
    stat = stat + (w*w');
end

expected_stat = stat/num_samples

% ========================================================
% Compute statistics through MCMC
% ========================================================

samples = raw_samples;

mapping = compute_mapping(s, h);
%  proposal = @(x)(-theta'*factors(x, s, h, edges));
proposal = @(x)compute_log_prob(x, s, h, theta, edges, maxComplexity);
[samples, num_samples] = mh_rule(samples, num_samples, proposal, obj_func, mapping, s);

stat = zeros(size(samples, 1));
for i = 1:num_samples
    w = (samples(:, i)+1)/2;
    stat = stat + w*w';
end

expected_stat_MCMC = stat/num_samples

% ========================================================
% Importance Sampling
% ========================================================
mapping = compute_mapping(s, h);
samples = raw_samples(mapping(s), :);

norm = 0;
stat = zeros(size(samples, 1));

proposal = @(x)exp(compute_log_prob(x, s, h, theta, edges, maxComplexity));

for i = 1:size(samples, 2)
    w = (samples(:, i)+1)/2;
    weight = (exp(-obj_func(samples(:, i)))/proposal(samples(:, i)));
    stat = stat + weight*(w*w');
    norm = norm + weight;
end

expected_stat_importance = stat/norm


%  ========================================================
%  Adaptive MCMC
%  ========================================================
%  expectation_function = @(w)((w+1)/2)*((w+1)/2)';
%  
%  tic
%  num_samples = 5000;
%  [samples, num_samples] = adaptive_mcmc(obj_func, auxdata, nu, theta, num_samples, 'trust', expectation_function);
%  num_active_samples = 2000;
%  time_elapsed = toc
%  
%  stat = zeros(size(samples, 1));
%  num_samples
%  
%  for i = num_samples - num_active_samples + 1:num_samples
%      w = (samples(:, i)+1)/2;
%      stat = stat + w*w';
%  end
%  
%  expected_stat = stat/(num_active_samples)
%  
num_samples = 1000;
[samples, pf] = exact_sample(s, [], full_edges, true_theta, maxComplexity, num_samples);
stat = zeros(size(samples, 1));
for i = 1:num_samples
    w = (samples(:, i)+1)/2;
    stat = stat + w*w';
end

expected_stat_exact = stat/num_samples

%  % Statistics by Gibbs
%  w = zeros(dim, 1);
%  adjMat = ones(dim, dim);
%  n_sweeps = 200;
%  beta = 1;
%  tic
%  gibbs_stat = lapLogistGibbs(w, X, Y, adjMat, lambda, beta, n_sweeps)
%  toc