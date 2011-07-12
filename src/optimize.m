rng(112)

s = [1;2;3];
h = [4];
edges = [1,2;1,3;2,3];
factor_edges = [1, 2; 1, 3; 2, 3];

theta = rand(size(s,1) + size(h,1) + size(edges,1), 1)*2-1;
nu = rand(size(s, 1) + size(factor_edges,1), 1)*100-1;

temperature = 1;
qphandle = 0;
exact = true;

maxComplexity = 20;
num_samples = 1000;
auxdata = {s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples, exact};

lb = zeros(size(theta)) - 1;
ub = zeros(size(theta)) + 1;

approx_true_obj = true_obj(s, h, theta, edges, maxComplexity, temperature, num_samples)

min_conf_options.verbose = 0;
min_conf_options.Method = 'lbfgs';
min_conf_options.numDiff = false;

minFunc_optitions.Display = 'off';
minFunc_optitions.Method = 'qnewton';

nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata), nu, minFunc_optitions);
original_obj = evaluate_obj(theta, nu, auxdata)

%  
%  nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata), nu, options);
%  
%  for k = 1:10
%      nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata), nu, minFunc_optitions);
%      max_obj = evaluate_obj(theta, nu, auxdata)
%      theta = minConf_TMP(@(theta)min_conf_obj_theta(theta, nu, auxdata), theta, lb, ub, min_conf_options)
%      min_obj = evaluate_obj(theta, nu, auxdata)
%  end
%  nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata), nu, minFunc_optitions);
%  max_obj = evaluate_obj(theta, nu, auxdata)
%  
%  g = evaluate_grad_theta(theta, nu, auxdata)
%  final_obj = evaluate_obj(theta, nu, auxdata)
%  
%  %  x = lbfgsb(theta, lb, ub, 'evaluate_obj', 'evaluate_grad_theta', auxdata, 'empty_func', 'm', 1000);
