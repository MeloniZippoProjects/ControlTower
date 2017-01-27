function [ samples_no0 ] = removeZeros( samples )
%REMOVEZEROS Summary of this function goes here
%   Detailed explanation goes here

    samples_no0 = struct();

    for idx = 1 : samples.size 

        field = ['v' string(idx).char];
        sample = samples.(field);
        samples_no0.(field) = sample( ~(sample == 0) );

    end

    samples_no0.size = samples.size;

end

