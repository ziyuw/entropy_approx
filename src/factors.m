function f = factors(sample, s, h, edges, mapping, working_nodes)
% s is a one-dim vec 
% factor_edges is a size(s, 1) by 2 vec specifies the edges
% NOTE: maximum spanning tree is an option

if nargin < 5
    mapping = compute_mapping(s, h);
end
if nargin < 6
    working_nodes = cat(1, s, h);
end

numQubits = size(working_nodes, 1);

f = zeros(numQubits + size(edges, 1), 1);

f(1:numQubits, 1) = sample(mapping(working_nodes));

m = max(s);
J = zeros(numQubits, numQubits);

f(numQubits+1:size(f, 1), 1) = sample(mapping(edges(:, 1))).*sample(mapping(edges(:, 2)));
