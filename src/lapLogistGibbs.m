function [SS] = lapLogistGibbs( w_0, X, Y, adjMat, lambda, beta, n_sweeps )
    
% Sample run a Gibbs sampler on the Laplace/Logistic posterior of
% the discrete parameters w.
    
% w_0 is the initial state {0,1} Must be n_features x 1
    
% beta is a tempering parameter for fun.
    
% adjMat is an upper-triangular matrix specifying which sufficient
% statistics need to be measured.

[n_data, n_features] = size( X );   

Is = cell( n_features, 1 );
for i=1:n_features
    Is{i} = [i find(adjMat(i,:) )];
end

w = w_0;
w_sum = sum( w );

dot_prods = X*w;

P_ones = setPones( w, X, Y, lambda, beta, w_sum, dot_prods );

SS = zeros( n_features );

for sweep=1:n_sweeps
    
    for i=1:n_features

        if rand<P_ones(i)
            % switch from 0 to 1?
            if w(i)==0
                w_sum = w_sum + 1;
                dot_prods = dot_prods + X(:,i);               
                w(i) = 1;
                P_ones = setPones( w, X, Y, lambda, beta, w_sum, dot_prods );
            end
        else
            % switch from 1 to 0?
            if w(i)==1
                w_sum = w_sum - 1;
                dot_prods = dot_prods - X(:,i);
                w(i) = 0;
                P_ones = setPones( w, X, Y, lambda, beta, w_sum, dot_prods );
            end
        end
        
    end % for single sweep  
    
    % Update sufficient stats (NOT the correlations till you make them so!)
    for i=1:n_features
        I = Is{i};
        SS(i,I) = SS(i,I) + w(i)*w(I)';
    end
    
end % for all sweeps

SS = SS/n_sweeps;


function [P_ones] = setPones( w, X, Y, lambda, beta, w_sum, dot_prods )
    
    [n_data, n_features] = size( X );   
    P_ones = zeros( n_features, 1 );
    
    for i = 1:n_features
        
        % All in log space
        
        A_0 = -lambda*( w_sum - w(i) + 0 );
        A_1 = -lambda*( w_sum - w(i) + 1 );

        B_0 = 0.0;
        B_1 = 0.0;
        
        for j = 1:n_data
            
            B_0 = B_0 + log( 1+exp(-Y(j)*( dot_prods(j)-w(i)*X(j,i) + 0)) );
            B_1 = B_1 + log( 1+exp(-Y(j)*( dot_prods(j)-w(i)*X(j,i) + X(j,i)) ));
            
        end
        
        P_ones(i) = 1.0/( 1 + exp( beta*( A_0-B_0-A_1+B_1 ) ) );
        
    end
    