function [ first_samples, last_samples ] = divideSamples( samples, divisor )
%DIVIDESAMPLES Splits the samples object. The first returned samples contain only data less than divisor.

    first_samples = struct();
    first_samples.size = samples.size;
    last_samples = struct();
    last_samples.size = samples.size;
    
    
    for idx = 1 : samples.size
        field = ['v' string(idx).char];
        sample = sort(samples.(field));
        last = find(sample < divisor,1,'last');
        first_samples.(field) = sample(1:last);
        last_samples.(field) = sample(last+1 : length(sample));
    end

end

