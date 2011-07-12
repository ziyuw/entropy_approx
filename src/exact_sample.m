function samples = exact_sample(s, h, edges, theta, maxComplexity, num_samples, full_sample)
% Draws samples by using orang_solve to get samples of s
% h's are the hidden units and theta's are the parameters
% edges should be calculated in accordance to workingQubits
% theta is a column vector

if nargin < 7 
    full_sample = false;
end 

working_nodes = cat(1, s, h);
mapping = compute_mapping(s, h);
numQubits = size(working_nodes, 1);

H = theta(mapping(working_nodes), 1);

m = max(working_nodes);
J = zeros(numQubits, numQubits);

for i = 1:size(edges, 1)
    J(mapping(edges(i, 1)), mapping(edges(i, 2))) = theta(i+numQubits);
end 

% Using orang_sample to draw samples
tables = isingTables(-H, -J);
varOrder = orang_greedyvarorder(tables, maxComplexity, [], 'mindeg');

[pf samples t] = orang_sample(tables, varOrder, maxComplexity, num_samples);

if full_sample
    samples = (samples(mapping(working_nodes), :)-1)*2-1;
else
    samples = (samples(mapping(s), :)-1)*2-1;
end