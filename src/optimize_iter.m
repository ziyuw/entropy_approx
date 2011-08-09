function [theta, nu, trust_struct] = optimize_iter(nu, theta, auxdata, obj_func, num_iter, method, trust_struct)

% Set the lower and the uppper bounda
lb = zeros(size(theta)) - 1;
ub = zeros(size(theta)) + 1;

% Optimize nu to approximate the objective better
% nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata), nu, minFunc_optitions);
% original_obj = evaluate_obj(theta, nu, auxdata)

% Optimization
if strcmp('trust', method)
    [theta, nu, trust_struct] = trust_region_opt(nu, theta, auxdata, obj_func, lb, ub, num_iter, 'opt', trust_struct);
elseif strcmp('alternate', method)
    [theta, nu] = alternate_opt(nu, theta, auxdata, obj_func, lb, ub, num_iter);
else
    disp('Argument for method option is not valid.')
end

% Optimize nu to approximate the objective better to check results
% nu = minFunc(@(nu)min_conf_obj_nu(nu, theta, auxdata), nu, minFunc_optitions);
% max_obj = evaluate_obj(theta, nu, auxdata)