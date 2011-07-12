function obj = true_obj(s, h, theta, edges, maxComplexity, temperature, num_samples)

samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples, true);

expectation = 0;
expectation_entropy = 0;

mapping = compute_mapping(s, h);

for i = 1:num_samples
    func_val = funcG(samples(mapping(s), i));
    
    expectation = expectation + func_val;
    expectation_entropy = expectation_entropy + compute_log_prob(samples(:, i), s, h, theta, edges, maxComplexity);
end
expectation = expectation/num_samples;
expectation_entropy = expectation_entropy/num_samples

obj = expectation + expectation_entropy/temperature;