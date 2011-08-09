function [obj, grad] = min_conf_obj_nu(nu, theta, auxdata, obj_func, accumulate_samples)

if ~exist('accumulate_samples')
    accumulate_samples = false;
end

obj = -evaluate_obj(theta, nu, auxdata, obj_func, accumulate_samples);
grad = -evaluate_grad_nu(nu, theta, auxdata, obj_func, accumulate_samples);
