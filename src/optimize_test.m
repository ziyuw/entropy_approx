sat = load('/home/zwang/development/entropy_approx/extra/3sat_1000_10000_2.txt');
sat = sat(:, 1:3);
sat_sign = sign(sat);
sat = abs(sat);
obj_func = @(x)(-sat_func(x, sat, sat_sign));

%  vec = [4450879, 10107243, 13068207, 26997473, 27161720, 27901755, 37287312,...
%   39911249, 41456516, 70310972, 75261453, 86058185, 86577617, 105407785, 110707912,...
%   114022813, 115727070, 118231323, 123935255, 124208253, 129631454, 133023326,...
%   143468671, 150825764, 164177435, 164446662, 166805535, 173688478, 177179856, 177962608, 188036988, 194692979]';
%  goal = 1268877241;
%  vec = [2318, 5424, 14222, 14939, 17308, 21296, 21595, 23007, 25642, 25973, 26322, 27106,...
%   29807, 29841, 37521, 37965, 39049, 41581, 41665, 48913, 49273, 55256, 56070, 64343, 67806,...
%   72785, 72912, 73485, 74624, 75722, 76057, 79797]';
%  goal = 609183;
%  obj_func = @(x)subset_sum_func(x, vec, goal);

num_variable = 1000;

% Basic settings
s = (1:num_variable)';
h = [];

s = (1:num_variable)';
h = [];
edges = cat(2, (1:num_variable-1)', (2:num_variable)');
factor_edges = cat(2, (1:num_variable-1)', (2:num_variable)');

% Use the Chimara
%  [s, edges] = qpChimeraConnectivity(2,2,4);
%  h = [];
%  factor_edges = edges;

tic
theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);

init_temp = 0.1;
final_temp = 2;
qphandle = 0;
exact = true;

maxComplexity = 2000;
num_samples = 100;

num_iter = 10;

opt_struct.s = s;
opt_struct.h = h;
opt_struct.edges = edges;
opt_struct.factor_edges = factor_edges;
opt_struct.exact = exact;
opt_struct.maxComplexity = maxComplexity;
opt_struct.num_samples = num_samples;

theta = optimize(theta, obj_func, num_iter, init_temp, final_temp, opt_struct);

num_samples = 10000;
[samples, pf] = exact_sample(s, h, edges, theta, maxComplexity, num_samples);

best_sample = [];

vals = zeros(num_samples, 1);
for i = 1:num_samples
    vals(i) = obj_func(samples(:, i));
end

best_obj_val = -min(vals);
average = -mean(vals);

algorithm_time = toc;

fprintf('Algorithm Time: %3.2d Best Val: %5.1f  Average Val: %5.1f\n', algorithm_time, best_obj_val, average);

% Drawing complete random samples
tic
num_samples = 10000;
samples = (rand(size(s, 1), num_samples)<0.5)*2-1;

best_sample = [];
vals = zeros(num_samples, 1);
for i = 1:num_samples
    vals(i) = obj_func(samples(:, i));
end

best_obj_val = -min(vals);
average = -mean(vals);
ran_time = toc;

fprintf('Random Time:    %3.2d Best Val: %5.1f  Average Val: %5.1f\n', ran_time, best_obj_val, average);
