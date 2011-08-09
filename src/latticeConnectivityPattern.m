function [vertices, edges] = latticeConnectivityPattern(m)

vertices = (1:m^2)';
edges = zeros((m-1)*m*2, 2);

counter = 1;
for i = 1:m^2
    if mod(i, m) ~= 0
	edges(counter, :) = [i, i+1];
	counter = counter + 1;
    end
    if i+m <= m^2
	edges(counter, :) = [i, i+m];
	counter = counter + 1;
    end
end

