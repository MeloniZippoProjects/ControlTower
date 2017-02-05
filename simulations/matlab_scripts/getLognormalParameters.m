% Returns scale and shape parameters of a lognormal with given mean and variance

function [mu, sigma] = getLognormalParameters(mean, var)      
    mu = log( (mean^2) / sqrt(var + mean^2) );
    sigma = sqrt( log( 1 + var/mean^2 ) );
end