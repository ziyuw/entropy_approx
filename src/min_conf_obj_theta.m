function [obj, grad] = min_conf_obj_theta(theta, nu, auxdata, obj_func)

obj = evaluate_obj(theta, nu, auxdata, obj_func);
grad = evaluate_grad_theta(theta, nu, auxdata, obj_func);