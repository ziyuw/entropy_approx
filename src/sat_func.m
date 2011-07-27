function val = sat_func(x, abs_sat, sat_signs)

mat = x(abs_sat).*sat_signs+1;
val = size(find(sum(mat, 2)), 1);
