function vec = shuffle(max_index)

vec = zeros(max_index, 1);
temp_vec = (1:max_index)';
for i = 1:max_index
    index = randi(size(temp_vec, 1), 1);
    vec(i) = temp_vec(index);
    temp_vec(index) = [];
end

