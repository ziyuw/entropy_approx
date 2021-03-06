function ln_sum = compute_log_prob(sample, s, h, theta, edges, maxComplexity)

working_nodes = cat(1, s, h);
mapping = compute_mapping(s, h);
boundry = max(mapping(s));

numQubits = size(h, 1) + size(s, 1);
H = theta(mapping(h), 1);
J = zeros(size(h, 1), size(h, 1));
s_sum = theta(mapping(s), 1)'*sample(mapping(s), 1);

H_total = theta(mapping(working_nodes), 1);
J_total = zeros(numQubits, numQubits);

for i = 1:size(edges)
    if mapping(edges(i, 1)) > boundry
	if mapping(edges(i, 2)) > boundry
	    J(mapping(edges(i, 1) - boundry), mapping(edges(i, 1)) - boundry) = theta(i+numQubits);
	else
	    H(mapping(edges(i, 1)) - boundry) = H(mapping(edges(i, 1)) - boundry) + theta(i+numQubits)*sample(mapping(edges(i, 2)));
	end
    elseif mapping(edges(i, 2)) > boundry
	H(mapping(edges(i, 2)) - boundry) = H(mapping(edges(i, 2)) - boundry) + theta(i+numQubits)*sample(mapping(edges(i, 1)));
    else
	s_sum = s_sum + theta(i+numQubits)*sample(mapping(edges(i, 1)))*sample(mapping(edges(i, 2)));
    end
    J_total(mapping(edges(i, 1)), mapping(edges(i, 2))) = theta(i+numQubits);
end

if size(h, 1) ~= 0
    tables = isingTables(-H, -J);
    varOrder = orang_greedyvarorder(tables, maxComplexity, [], 'mindeg');
    [pf t] = orang_sample(tables, varOrder, maxComplexity, 0);
else
    pf = 0;
end

tables = isingTables(-H_total, -J_total);
varOrder = orang_greedyvarorder(tables, maxComplexity, [], 'mindeg');
[pf_total t] = orang_sample(tables, varOrder, maxComplexity, 0);

ln_sum = pf - pf_total - s_sum;