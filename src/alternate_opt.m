function [theta, nu] = alternate_opt(nu, theta, auxdata, obj_func, lb, ub, num_iter)

min_conf_options.verbose = 0;
min_conf_options.Method = 'lbfgs';
min_conf_options.numDiff = false;

minFunc_optitions.Display = 'off';
minFunc_optitions.Method = 'qnewton';

for iter = 1:num_iter + 1
    nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata, obj_func), nu, minFunc_optitions);
    max_obj = evaluate_obj(theta, nu, auxdata, obj_func);
    fprintf('Iteration: %2d  Max Func Value: %3.2f\n', iter, max_obj);

    if iter == num_iter+1, break, end

    % max_obj = evaluate_obj(theta, nu, auxdata, obj_func);
    theta = minConf_TMP(@(theta)min_conf_obj_theta(theta, nu, auxdata, obj_func), theta, lb, ub, min_conf_options);
    % min_obj = evaluate_obj(theta, nu, auxdata, obj_func);
end
