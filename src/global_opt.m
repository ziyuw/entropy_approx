function theta = global_opt(nu, theta, auxdata, total_num_iter, num_iter, method, temp_0, temp_final)

cur_temp = method;

for i = 1:total_num_iter
    % Set the temperature
    cur_temp = temp_0 + (i-1)*(temp_final-temp_0)/(total_num_iter-1);
    auxdata(5) = {cur_temp};

    [theta, nu] = optimize_iter(nu, theta, auxdata, num_iter, method);
end