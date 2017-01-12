function [ tot_sample ] = extractTotalLengthSample( config, rho )
%EXTRACTTOTALLENGTHSAMPLE Summary of this function goes here
%   Detailed explanation goes here
    samples = extractLengthSamples(config, rho);
    tot_sample = [];
    for idx = 1 : samples.size
        tot_sample = [tot_sample; samples.(strcat('v', string(idx).char))];
    end
end

