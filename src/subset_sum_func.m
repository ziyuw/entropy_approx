function val = subset_sum_func(x, literals, val)

x = (x+1)/2;
val = abs(sum(literals.*x)-val);
