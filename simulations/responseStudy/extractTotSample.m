function [ tot_sample ] = extractTotSample(config)
%EXTRACTTOTSAMPLE Summary of this function goes here
%   Detailed explanation goes here

    cd(config);
    cd results;
        run responseTime.m
        tot_sample = [];
        for idx = 1 : vectors.size
            vector_name = strcat('wg_responseTime', '_', string(idx-1).char);
            x = vectors.(vector_name);
            x = x(:, 2);
            tot_sample = [tot_sample; x];
            
            if length(tot_sample) > 5e4 && idx > 10
                break;
            end
        end
    cd ../..
end
