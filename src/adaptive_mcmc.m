function [samples, num_samples] = adaptive_mcmc(obj_func, auxdata, nu, theta, num_samples, method, expectation_function)
%  Should change auxdata to structured array

global NUM_SAMPLES;
global MCMC_SAMPLES;
global LAST_SAMPLE;
global EXPECT_FUNC;
global SUM;

NUM_SAMPLES = 0;
MCMC_SAMPLES = [];
LAST_SAMPLE = [];
SUM = [];
EXPECT_FUNC = expectation_function;

lb = zeros(size(theta)) - 1;
ub = zeros(size(theta)) + 1;

trust_struct = struct('trust_radius', 0.1, 'max_obj', 0, 'min_obj', 0, 'iter', 1);
num_iter = 1;

% Optimization
if strcmp('trust', method)
    while NUM_SAMPLES < num_samples
	[theta, nu, trust_struct] = trust_region_opt(nu, theta, auxdata, obj_func, lb, ub, num_iter, 'mcmc', trust_struct);
    end
elseif strcmp('alternate', method)
    [theta, nu] = alternate_opt(nu, theta, auxdata, obj_func, lb, ub, num_iter);
else
    disp('Argument for method option is not valid.')
end

num_samples = NUM_SAMPLES;
samples = MCMC_SAMPLES;

%  expectation = SUM/NUM_SAMPLES;