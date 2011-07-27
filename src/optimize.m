function theta = optimize(theta, obj_func, num_iter, init_temp, final_temp, opt_struct)

temp_increment = (final_temp-init_temp)/(num_iter-1);
cur_temp = init_temp;

% Basic settings
s = opt_struct.s;
h = opt_struct.h;
edges = opt_struct.edges;
factor_edges = opt_struct.factor_edges;

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


for n = 1:num_iter

    auxdata{5} = cur_temp;
    old_theta = theta;
    method = 'trust';
    m = 4;
    if n == num_iter
	method = 'trust';
	m = 4;
    end
    
    [theta, nu] = optimize_iter(nu, theta, auxdata, obj_func, m, method);
    
    fprintf('Change in norm of theta: %f; Temperature: %f\n', norm(theta-old_theta), 1/cur_temp);
    cur_temp = cur_temp + temp_increment;
end

