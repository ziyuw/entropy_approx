function [obj, grad] = min_conf_obj_theta(theta, nu, auxdata)

obj = evaluate_obj(theta, nu, auxdata);
grad = evaluate_grad_theta(theta, nu, auxdata);