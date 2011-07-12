% example of using qpapi
% need to provide URL, user, password as matlab strings

% make the connection:
% here should provide:
% URL: string
% user: username string
% password: user's password string
qpHandle = connect(11);


%get quantum processor infomation:
qpInfo = qpapiInfo(qpHandle);

%check if the quantum processor is currently available
a = qpapiAvailable(qpHandle);

%active qpapi server handles and URLs
handles = qpapiHandles();

%solve the problem
h = zeros(1, qpInfo.numQubits);
h(qpInfo.workingQubits) = rand(1, length(qpInfo.workingQubits));
J = sparse(qpInfo.workingCouplers(1, :), qpInfo.workingCouplers(2, :), rand(1, size(qpInfo.workingCouplers, 2))*2-1, qpInfo.numQubits, qpInfo.numQubits);
numReads = 100;
% [states energies numOccurrences timings] = qpapiSolve(qpHandle, h, J, numReads);

size(qpInfo.workingCouplers)
qpInfo.workingCouplers(2,:)

%destroys qpapi server handles
qpapiDelete(qpHandle);
