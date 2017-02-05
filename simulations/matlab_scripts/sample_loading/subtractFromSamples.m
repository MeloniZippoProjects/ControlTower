% Subtracts from all the data entries in the samples object the constant value passed as parameter.

function [ ret_samples ] = subtractFromSamples( samples, value )
    ret_samples = struct();
    ret_samples.size = samples.size;
    
    for idx = 1 : samples.size
        field = ['v' string(idx).char];
        sample = samples.(field) - value;
        ret_samples.(field) = sample;
    end
end

