function [subsmpl] = subsample(sample, k)
%SUBSAMPLE Summary of this function goes here
%   Detailed explanation goes here

    subsmpl = [];
    for idx = 1:length(sample)
        if( rand() <= 1/(2^k))
            subsmpl = [subsmpl; sample(idx, :)];
        end
    end
end

