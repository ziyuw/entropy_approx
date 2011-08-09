function theta = optimize(theta, obj_func, num_iter, init_temp, final_temp, opt_struct)

temp_increment = (final_temp-init_temp)/(num_iter-1);
cur_temp = init_temp;

% Basic settings
s = opt_struct.s;
h = opt_struct.h;
edges = opt_struct.edges;
factor_edges = opt_struct.factor_edges;

method = opt_struct.method;
m = opt_struct.m;

nu = (rand(size(s, 1) + size(factor_edges,1) + 1, 1)-0.5)*2;
qphandle = 0;

if ~opt_struct.exact
    qphandle = opt_struct.qphandle;
end

maxComplexity = 2000;
if isfield(opt_struct, 'maxComplexity')
    maxComplexity = opt_struct.maxComplexity;
end

num_samples = 100;
if isfield(opt_struct, 'maxComplexity')
    num_samples = opt_struct.num_samples;
end

auxdata = {s, h, edges, factor_edges, cur_temp, qphandle, maxComplexity, num_samples, opt_struct.exact};

if strcmp('trust', method)
    trust_struct = struct('trust_radius', 0.1, 'max_obj', 0, 'min_obj', 0, 'iter', 1);
end
for n = 1:num_iter

    auxdata{5} = cur_temp;
    old_theta = theta;
    if n == num_iter
	%method = 'alternate';
	%m = 8;
    end
    if strcmp('trust', method)
	[theta, nu, trust_struct] = optimize_iter(nu, theta, auxdata, obj_func, m, method, trust_struct);
	trust_struct.iter = 1;
    else
	[theta, nu] = optimize_iter(nu, theta, auxdata, obj_func, m, method);
    end
    fprintf('Change in norm of theta: %f; Temperature: %f\n', norm(theta-old_theta), 1/cur_temp);
    cur_temp = cur_temp + temp_increment;
end

