% Computes p-quantile with (1-alfa) level confidence interval
% Uses linear interpolation for points halfway in a step
% T = sum(weights);
% If partial_sum from 0 to x is A, and partial sum from 0 to x+1 is B
% then we assign A/T to x and B/T to x+1.
% If p is between A/T and B/T, its x value is obtained through linear interpolation
%
% sortedSample must be sorted and weighted

function [quantile] = computeWeightedQuantile(sortedSample, p) 
    weight_sum = 0;
    for idx = 1 : size(sortedSample, 1);
        weight_sum = weight_sum + sortedSample(idx, 2);
    end
    
    partial_sum = 0;
    for idx = 1 : size(sortedSample, 1)
        old_part_sum = partial_sum;
        partial_sum = partial_sum + sortedSample(idx,2);
        if ( partial_sum > weight_sum*p )
            x = [old_part_sum, partial_sum] / weight_sum;
            
            if(idx == 1)
                v = [0, sortedSample(idx,1)];
            else
                v = [sortedSample(idx - 1, 1), sortedSample(idx, 1)];
            end
            quantile = interp1(x,v,p);
            break;
        end
    end
end