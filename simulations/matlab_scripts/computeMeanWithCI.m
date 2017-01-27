function [sample_mean, gap] = computeMeanWithCI( sample, alfa, dimension)
    if(~exist('dimension'))
        if(size(sample,1) == 1)
            dimension = 2;
        else
            dimension = 1;
        end
    end
    
    n = size(sample, dimension);
    S = std(sample,0,dimension);
    i = 1 - alfa;
    z_alfamezzi = 4.91 * ( i^0.14 - (1 - i)^0.14 ); %usato la formula approssimata sulle note
    
    sample_mean = mean(sample, dimension);
    gap = S/sqrt(n) * z_alfamezzi;
end