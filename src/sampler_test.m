% Setting random seed
rng(112)

%  % Preparing Data
dim = 5;
load('/home/zwang/development/data/UCI_BC.mat');

X = X(:, 1:dim);

lambda = 1;
%  obj_func = @(s)funcG(s, X, Y, lambda);

s = [1;2;3;4;5];
full_edges = [1,2;1,3;2,3;1,4;2,4;3,4;1,5;2,5;3,5;4,5];
true_theta = (rand(size(s,1) + size(full_edges,1), 1)*2-1);
obj_func = @(x)(true_theta'*factors(x, s, [], full_edges));

  
% Basic settings
s = [1;2;3;4;5];
h = [];
%  ;1,6;2,6;3,6;4,6;5,6;1,7;2,7;3,7;4,7;5,7
edges = [1,3;1,4;2,4;2,5;3,5];
factor_edges = [1,3;1,4;2,4;2,5;3,5];

theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);
nu = (rand(size(s, 1) + size(factor_edges,1) + 1, 1)-0.5)*2;

temperature = 1;
qphandle = 0;
exact = true;

maxComplexity = 2000;
num_samples = 100;
auxdata = {s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples, exact};

options.maxComplexity = 2000;
options.num_iter = 100;
importance_struct.empty = 0;
[samples, weights, estimated_pf, importance_struct] = importance_sampler(obj_func, num_samples, s, h, edges, factor_edges, options, importance_struct);
[samples, weights, estimated_pf, importance_struct] = importance_sampler(obj_func, num_samples, s, h, edges, factor_edges, options, importance_struct);

stat = zeros(size(samples, 1));
norm = 0;

for i = 1:size(samples, 2)
    w = (samples(:, i)+1)/2;
    weight = weights(i);
    stat = stat + weight*(w*w');
    norm = norm + weight;
end

expected_stat_importance = stat/norm

% ========================================================
% Exact Samples
% ========================================================

num_samples = 100;
[samples, pf] = exact_sample(s, [], full_edges, true_theta, maxComplexity, num_samples);
stat = zeros(size(samples, 1));
for i = 1:num_samples
    w = (samples(:, i)+1)/2;
    stat = stat + w*w';
end

expected_stat_exact = stat/num_samples