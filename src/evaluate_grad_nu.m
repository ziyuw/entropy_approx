function grad = evaluate_grad_nu(nu, theta, auxdata)
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
    samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples);
else
    % Draw samples from the hardware
    % convert theta to h's and J's in the hardware format
    % and pass it to the hardware
    % Convert the samples back
end

% Calculate the two expectations
expectation_fac = zeros(size(s, 1) + size(factor_edges, 1), 1);

for i = 1:num_samples
    facs = factors(samples(:, i), s, [], factor_edges);
    expectation_fac = expectation_fac + facs;
end

expectation_fac = expectation_fac/num_samples;
grad = (expectation_fac - compute_vec_sum(s, [], nu, factor_edges, maxComplexity))/temperature;
