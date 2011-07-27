function [obj] = evaluate_obj(theta, nu, auxdata, obj_func, accumulate_samples)
% Hidden qbits (h): a list of indices
% Visible qbits (s): a list of indices
% theta: a vector that represents thetas (h's first J's after)
% temp is the temperature
% exact indicates orang is used otherwise the hardware is used.

% NOTE: samples are only needed to be drawn once for computing
%       both the gradient and the objective. This can possible
%       be done given the current framework

%  disp('Start of obj');

[s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples, exact] = deal(auxdata{:});

nu_last = nu(size(nu, 1));
nu = nu(1:size(nu, 1)-1, 1);

mapping = compute_mapping(s, h);

%  Draw samples
if exact
    [samples, pf] = exact_sample(s, h, edges, theta, maxComplexity, num_samples, true);
    if exist('accumulate_samples') && accumulate_samples
	global NUM_SAMPLES;
	global MCMC_SAMPLES;
	global LAST_SAMPLE;

	if NUM_SAMPLES > 0
	    samples = cat(2, LAST_SAMPLE, samples);
	end

%  theta'*factors(samples(:, 2), s, h, edges)
%  theta

%  exp(-theta'*factors(samples(:, 2), s, h, edges))/exp(pf)

	proposal = @(x)(-theta'*factors(x, s, h, edges));
	[mh_samples, mh_num_samples] = mh_rule(samples, num_samples, proposal, obj_func, mapping, s);
	NUM_SAMPLES = NUM_SAMPLES + mh_num_samples;
	MCMC_SAMPLES = cat(2, MCMC_SAMPLES, mh_samples);
    end
    samples = samples(mapping(s), :);
else
    % Draw samples from the hardware
    % convert theta to h's and J's in the hardware format
    % and pass it to the hardware
    % Convert the samples back
end

% Calculate the two expectations
expectation_G = 0;
expectation_phi = zeros(size(s, 1) + size(factor_edges, 1), 1);

empty_mapping = compute_mapping(s, []);
empty_working_nodes = cat(1, s, []);

for i = 1:num_samples
    expectation_G = expectation_G + obj_func(samples(:, i));
    expectation_phi = expectation_phi + factors(samples(:, i), s, [], factor_edges, empty_mapping, empty_working_nodes);
end
expectation_G = expectation_G/num_samples;
expectation_phi = expectation_phi/num_samples;

% Calculate the sum
% Note: the sum does not have to be computed when optimising theta!!!
sum = compute_sum(s, h, nu, factor_edges, maxComplexity)/exp(nu_last);

%  sss = sum/temperature
%  eeee = expectation_phi'*nu - nu_last
%  expectation_phi

obj = expectation_G + (expectation_phi'*nu - sum - nu_last)/temperature;
%  disp('End of obj!')
