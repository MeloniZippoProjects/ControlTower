function [ expanded_sample ] = expandWeightedSample( weighted_sample )
%EXPANDWEIGHTEDSAMPLE Summary of this function goes here
%   Detailed explanation goes here
    weights = round(weighted_sample(:,2));
    total_elems = sum(weights);
    
    expanded_sample = zeros(1,total_elems);
    last_idx = 1;
    for idx = 1 : length(weighted_sample)
        expanded_value = ones(1, weights(idx)) * weighted_sample(idx,1);
        new_idx = last_idx + length(expanded_value);
        expanded_sample(last_idx : new_idx - 1) = expanded_value;
        last_idx = new_idx;
    end

end

