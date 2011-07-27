function [samples, num_samples] = mh_rule(samples, num_samples, proposal, target_energy, mapping, s)

last_sample = 1;
num_samples = size(samples, 2);
indices = zeros(1, num_samples-1);
num_accepted = 0;

for i = 2:num_samples
    prob = exp(proposal(samples(:, last_sample)) - target_energy(samples(mapping(s), i)) - proposal(samples(:, i)) + target_energy(samples(mapping(s), last_sample)));
    if rand < prob
	indices(i-1) = i;
	last_sample = i;
	num_accepted = num_accepted + 1;
    else
	indices(i-1) = last_sample;
    end
end

accpt_rate = num_accepted/num_samples

global LAST_SAMPLE;

LAST_SAMPLE = samples(:, size(samples, 2));


%  global EXPECT_FUNC;
%  global SUM;
%  sum = EXPECT_FUNC(samples(mapping(s), indices(1)));
%  for j = 2:size(indices, 2)
%      sum = sum + EXPECT_FUNC(samples(mapping(s), indices(j)));
%  end
%  
%  if size(SUM, 1) == 0
%      SUM = sum;
%  else
%      SUM = SUM + sum;
%  end

num_samples = size(indices, 2);
samples = samples(mapping(s), indices);

    
