function [ subsample ] = sub_sample( sample, k )
    subsample = [];
    for idx = 1 : size( sample, 1 )
        if( rand() <= 1/(2^k))
            subsample = [	subsample;
            				sample(idx, :)];
        end
    end
end

