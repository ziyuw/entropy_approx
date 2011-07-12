function [obj] = evaluate_obj(theta, nu, auxdata)
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
expectation_G = 0;
expectation_phi = zeros(size(s, 1) + size(factor_edges, 1), 1);

for i = 1:num_samples
    expectation_G = expectation_G + funcG(samples(:, i));
    expectation_phi = expectation_phi + factors(samples(:, i), s, [], factor_edges);
end
expectation_G = expectation_G/num_samples;
expectation_phi = expectation_phi/num_samples;

% Calculate the sum
% Note: the sum does not have to be computed when optimising theta!!!
sum = compute_sum(s, h, nu, factor_edges, maxComplexity);

%  sss = sum/temperature
%  eeee = expectation_phi'*nu
%  expectation_phi

obj = expectation_G + (expectation_phi'*nu - sum)/temperature;

obj = obj;
%  disp('End of obj!')
