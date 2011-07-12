function [tables, varOrder] = exact_init(h, J, maxComplexity)
% From an ising problem to a qubo problem
% This function returns the necessary structures for orang_sample

[Q, quboOffSet] = isingToQubo(h, J)
tables = quboTables(Q)
varOrder = orang_greedyvarorder(tables, maxComplexity)
