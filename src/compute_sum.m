function sum = compute_sum(s, h, nu, factor_edges, maxComplexity)
% Computes the sum by using orang_sample

working_nodes = s;
mapping = compute_mapping(s, h);
numQubits = size(working_nodes, 1);

H = nu(mapping(working_nodes), 1);
J = zeros(numQubits, numQubits);

for i =1:size(factor_edges, 1)
    J(mapping(factor_edges(i, 1)), mapping(factor_edges(i, 2))) = nu(i+numQubits);
end 

tables = isingTables(H, J);
varOrder = orang_greedyvarorder(tables, maxComplexity, [], 'mindeg');

[pf t] = orang_sample(tables, varOrder, maxComplexity, 0);

sum = exp(pf)/exp(1);
