function [ ret_samples ] = subtractFromSamples( samples, value )
%SUBTRACTFROMSAMPLE Summary of this function goes here
%   Detailed explanation goes here

    ret_samples = struct();
    ret_samples.size = samples.size;
    
    for idx = 1 : samples.size
        field = ['v' string(idx).char];
        sample = samples.(field) - value;
        ret_samples.(field) = sample;
    end

end

