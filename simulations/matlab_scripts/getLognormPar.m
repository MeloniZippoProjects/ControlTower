function [mu, sigma] = getLognormPar(mean, var)      
    mu = log( (mean^2) / sqrt(var + mean^2) );
    sigma = sqrt( log( 1 + var/mean^2 ) );
end