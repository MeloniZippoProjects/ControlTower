function [q, lb, ub] = computeQuantile(sample, p, alfa)
    n = length(sample);
    i = 1 - alfa;
    z_alfamezzi = 4.91 * ( i^0.14 - (1 - i)^0.14 ); %usato la formula approssimata sulle note
    sortedSample = sort(sample); 
    q = quantile(sample,p); 
    %q = sortedSample( fix( n * p) );
    lb = sortedSample( floor( n*p - z_alfamezzi*sqrt(n*p*(1-p)) ) );
    ub = sortedSample( ceil( n*p + z_alfamezzi*sqrt(n*p*(1-p)) ) + 1 );
end