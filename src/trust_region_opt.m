function [theta, nu, trust_struct] = trust_region_opt(nu, theta, auxdata, obj_func, lb, ub, num_iter, usage, trust_struct)

% Setting up the options
min_conf_options.verbose = 0;
min_conf_options.Method = 'lbfgs';
min_conf_options.numDiff = false;
min_conf_options.maxIter = 10;

minFunc_optitions.Display = 'off';
minFunc_optitions.Method = 'qnewton';
minFunc_optitions.maxIter = 500;

if nargin > 7 && strcmp('mcmc', usage)
    mcmc = true;
    num_iter = trust_struct.iter;
    accumulate_samples = true;
    anneal = true;
elseif nargin <= 7 || strcmp('opt', usage)
    mcmc = false;
    trust_struct = struct('trust_radius', 0.1, 'max_obj', 0, 'min_obj', 0, 'iter', 1);
    accumulate_samples = false;
    anneal = false;
else
    disp('Argument for method option is not valid.')
end


while trust_struct.iter <= num_iter
    nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata, obj_func, accumulate_samples), nu, minFunc_optitions);

    old_max_obj = trust_struct.max_obj;
    trust_struct.max_obj = evaluate_obj(theta, nu, auxdata, obj_func);
    
    if trust_struct.iter ~= 1
	rho = (old_max_obj - trust_struct.max_obj)/(old_max_obj - trust_struct.min_obj);
	if rho < 0.3
	    trust_struct.trust_radius = trust_struct.trust_radius/2;
	elseif rho >= 0.7
	    trust_struct.trust_radius = min(trust_struct.trust_radius*2, 1);
	end
    end

    old_theta = theta;
    if (anneal && rand > 1-1/exp((trust_struct.iter-1)/10)) || ~anneal
	[trust_lb, trust_ub] = compute_bound(theta, trust_struct.trust_radius, lb, ub);
	theta = minConf_TMP(@(theta)min_conf_obj_theta(theta, nu, auxdata, obj_func), theta, trust_lb, trust_ub, min_conf_options);
    end

    if isnan(sum(theta))
	theta = old_theta;
    end

    norm_theta = norm(theta-old_theta, 2);

    trust_struct.min_obj = evaluate_obj(theta, nu, auxdata, obj_func);
    
    fprintf('Iter: %2d  Max_obj: %3.2f  Trust Radius: %2.3f  Norm: %f\n', trust_struct.iter, trust_struct.max_obj, trust_struct.trust_radius, norm_theta);

    trust_struct.iter = trust_struct.iter + 1;
end

if ~mcmc
    nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata, obj_func), nu, minFunc_optitions);
end