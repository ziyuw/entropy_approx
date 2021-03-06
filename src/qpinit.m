function [h, J] = qpinit(machine, qbits)
% Usage:
% 	[h, J] = qpinit(machine, qbits)
% setting up the problem in the hardware format
% with the weights initialized to be random
% machine specifies the machine to be used
% qbits specifies a list of qbits to be used

qpHandle = connect(machine);

% get quantum processor infomation:
qpInfo = qpapiInfo(qpHandle);

% check if the quantum processor is currently available
a = qpapiAvailable(qpHandle);

% active qpapi server handles and URLs
handles = qpapiHandles();

% solve the problem
h = zeros(1, qpInfo.numQubits);
h(qpInfo.workingQubits) = rand(1, length(qpInfo.workingQubits));
J = sparse(qpInfo.workingCouplers(1, :), qpInfo.workingCouplers(2, :), rand(1, size(qpInfo.workingCouplers, 2))*2-1, qpInfo.numQubits, qpInfo.numQubits);


% Ising to QUBO
% [Q, quboOffSet] = isingToQubo(h, J)
% tables = quboTables(Q)
% varOrder = orang_greedyvarorder(tables, maxComplexity, clampRanks, heuristic, selectionScale)