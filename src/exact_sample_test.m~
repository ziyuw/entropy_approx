s = [1;2];
h = [];
edges = [1,2];
factor_edges = [1, 2];

theta = rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1;
nu = rand(size(s, 1) + size(factor_edges,1), 1)*2-1;

maxComplexity = 100;
num_samples = 5;

samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples)