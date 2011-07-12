function grad = evaluate_grad_theta(theta, nu, auxdata)
% Hidden qbits (h): a list of indices
% Visible qbits (s): a list of indices
% theta: a vector that represents thetas (h's first J's after)
% temp is the temperature
% exact indicates orang is used otherwise the hardware is used.

% NOTE: samples are only needed to be drawn once for computing
%       both the gradient and the objective. This can possible
%       be done given the current framework

%  disp('Start of grad_theta!');

[s, h, edges, factor_edges, temperature, qphandle, maxComplexity, num_samples, exact] = deal(auxdata{:});


%  Draw samples
if exact
    samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples, true);
else
    % Draw samples from the hardware
    % convert theta to h's and J's in the hardware format
    % and pass it to the hardware
    % Convert the samples back
end

% Calculate the two expectations
expectation = 0;
expectation_fac = zeros(size(s, 1) + size(h, 1) + size(edges, 1), 1);
expectation_vec = zeros(size(s, 1) + size(h, 1) + size(edges, 1), 1);

mapping = compute_mapping(s, h);

for i = 1:num_samples
    func_val = funcG(samples(mapping(s), i));
    facs = factors(samples(mapping(s), i), s, [], factor_edges);

    big_facs = factors(samples(:, i), s, h, edges);
    product = (facs'*nu)/temperature;
    expectation = expectation + func_val + product;
    expectation_fac = expectation_fac + big_facs;
    expectation_vec = expectation_vec + (func_val+product)*big_facs;
end
expectation = expectation/num_samples;
expectation_fac = expectation_fac/num_samples;
expectation_vec = expectation_vec/num_samples;

grad = expectation*expectation_fac - expectation_vec;

grad = grad;
%  disp('End of grad_theta!');
