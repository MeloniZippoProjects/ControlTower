function [ samples_no0 ] = removeZeros( samples )
%REMOVEZEROS Removes the data entries that are equal to zero

    samples_no0 = struct();

    for idx = 1 : samples.size 

        field = ['v' string(idx).char];
        sample = samples.(field);
        samples_no0.(field) = sample( ~(sample == 0) );

    end

    samples_no0.size = samples.size;

end

