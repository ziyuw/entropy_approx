function mapping = compute_mapping(s, h)

working_nodes = cat(1, s, h);
m = max(working_nodes);
mapping = zeros(m, 1);

for i = 1:size(working_nodes, 1)
   mapping(working_nodes(i)) = i;
end
