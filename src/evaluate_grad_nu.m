function grad = evaluate_grad_nu(nu, theta, auxdata, obj_func, accumulate_samples)
% Hidden qbits (h): a list of indices
% Visible qbits (s): a list of indices
% theta: a vector that represents thetas (h's first J's after)
% temp is the temperature
% exact indicates orang is used otherwise the hardware is used.

% NOTE: samples are only needed to be drawn once for computing
%       both the gradient and the objective. This can possible
%       be done given the current framework

[s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples, exact] = deal(auxdata{:});


%  Draw samples
if exact
    if exist('accumulate_samples') && accumulate_samples
	mapping = compute_mapping(s, h);
	samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples, true);
	global NUM_SAMPLES;
	global MCMC_SAMPLES;
	global LAST_SAMPLE;

	if NUM_SAMPLES > 0
	    samples = cat(2, LAST_SAMPLE, samples);
	end

	proposal = @(x)(-theta'*factors(x, s, h, edges));
	[mh_samples, mh_num_samples] = mh_rule(samples, num_samples, proposal, obj_func, mapping, s);
	NUM_SAMPLES = NUM_SAMPLES + mh_num_samples;
	MCMC_SAMPLES = cat(2, MCMC_SAMPLES, mh_samples);
	samples = samples(mapping(s), :);
    else
	samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples);
    end

else
    % Draw samples from the hardware
    % convert theta to h's and J's in the hardware format
    % and pass it to the hardware
    % Convert the samples back
end

% Calculate the two expectations
expectation_fac = zeros(size(s, 1) + size(factor_edges, 1), 1);

empty_mapping = compute_mapping(s, []);
empty_working_nodes = cat(1, s, []);

for i = 1:num_samples
    facs = factors(samples(:, i), s, [], factor_edges, empty_mapping, empty_working_nodes);
    expectation_fac = expectation_fac + facs;
end

expectation_fac = expectation_fac/num_samples;
vec_sum = compute_vec_sum(s, [], nu, factor_edges, maxComplexity, 1000);

grad = (cat(1, expectation_fac, [-1]) - vec_sum)/temperature;
