function [ ret_samples ] = subtractFromSamples( samples, value )
%SUBTRACTFROMSAMPLE Reduces all data in the samples object by a constant value

    ret_samples = struct();
    ret_samples.size = samples.size;
    
    for idx = 1 : samples.size
        field = ['v' string(idx).char];
        sample = samples.(field) - value;
        ret_samples.(field) = sample;
    end

end

