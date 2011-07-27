function val = funcG(s, X, Y, lambda)
% This function computes the un-normalised posterior
% of logistic regression with binary weights

dim = size(Y, 1);

%  Changes to weights to 0 and 1 from -1 and 1
w = (s+1)/2;

prior = exp(-lambda*sum(w));

inner_prod = X*w;

likelihood = 1;

for i = 1:dim
    p = 1.0/(1+exp(-Y(i)*inner_prod(i)));
    likelihood = likelihood*p;
end

val = -log(likelihood*prior);