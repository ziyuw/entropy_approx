sat = load('/home/zwang/development/entropy_approx/extra/3sat_32_1500.txt');
sat_sign = sign(sat);
sat = abs(sat);
obj_func = @(x)(-sat_func(x, sat, sat_sign));


% Basic settings
%  s = [1;2;3;4;5];
%  h = [6;7];
%  edges = [1,3;1,4;2,4;2,5;3,5;1,6;2,6;3,6;4,6;5,6;1,7;2,7;3,7;4,7;5,7];
%  factor_edges = [1,3;1,4;2,4;2,5;3,5];

%  s = [1;2;3;4;5;6;7;8;9;10];
s = (1:32)';
h = [];

%  ;1,5;1,6;1,9;2,5;3,5;6,9;7,9
%  ;1,5;1,6;1,9;2,5;3,5;6,9;7,9

%  ;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10
%  ;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10
%  edges = [1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10];
%  factor_edges = [1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10];

%  ;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30

s = (1:32)';
h = [];
edges = cat(2, (1:31)', (2:32)');
factor_edges = cat(2, (1:31)', (2:32)');

% Use the Chimara
%  [s, edges] = qpChimeraConnectivity(2,2,4);
%  h = [];
%  factor_edges = cat(2, (1:31)', (2:32)');

tic
theta = (rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1);

init_temp = 0.1;
final_temp = 2;
qphandle = 0;
exact = true;

maxComplexity = 2000;
num_samples = 100;

num_iter = 6;

opt_struct.s = s;
opt_struct.h = h;
opt_struct.edges = edges;
opt_struct.factor_edges = factor_edges;
opt_struct.exact = exact;
opt_struct.maxComplexity = maxComplexity;
opt_struct.num_samples = num_samples;

theta = optimize(theta, obj_func, num_iter, init_temp, final_temp, opt_struct);

num_samples = 1000;
[samples, pf] = exact_sample(s, h, edges, theta, maxComplexity, num_samples);

best_obj_val = 2000;
best_sample = [];

vals = zeros(num_samples, 1);
for i = 1:num_samples
    vals(i) = obj_func(samples(:, i));
end

best_obj_val = -min(vals);
average = -mean(vals);

algorithm_time = toc;

fprintf('Algorithm Time: %2.2d Best Val: %5.1f  Average Val: %5.1f\n', algorithm_time, best_obj_val, average);

% Drawing complete random samples
tic
num_samples = 1000;
samples = (rand(size(s, 1), num_samples)<0.5)*2-1;

best_obj_val = 2000;
best_sample = [];
vals = zeros(num_samples, 1);
for i = 1:num_samples
    vals(i) = obj_func(samples(:, i));
end

best_obj_val = -min(vals);
average = -mean(vals);
ran_time = toc;

fprintf('Random Time:    %2.2d Best Val: %5.1f  Average Val: %5.1f\n', ran_time, best_obj_val, average);
