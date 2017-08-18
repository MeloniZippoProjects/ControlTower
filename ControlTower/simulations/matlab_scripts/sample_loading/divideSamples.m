% Splits the samples object according to the divisor.
% The first returned samples contain only values lower than the divisor.

function [ first_samples, last_samples ] = divideSamples( samples, divisor )
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

