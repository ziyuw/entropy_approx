function f = factors(sample, s, h, edges)
% s is a one-dim vec 
% factor_edges is a size(s, 1) by 2 vec specifies the edges
% NOTE: maximum spanning tree is an option

working_nodes = cat(1, s, h);
mapping = compute_mapping(s, h);
numQubits = size(working_nodes, 1);

f = zeros(numQubits + size(edges, 1), 1);

f(1:numQubits, 1) = sample(mapping(working_nodes));

m = max(s);
J = zeros(numQubits, numQubits);


for i =1:size(edges, 1)
    f(i + numQubits, 1) = sample(mapping(edges(i, 1)))*sample(mapping(edges(i, 2)));
end
