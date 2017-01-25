function [ mean ] = weightedMean( matrix )
%WEIGHTEDMEAN Summary of this function goes here
%   Detailed explanation goes here

    tot_weights = sum(matrix(:,2));
    products = matrix(:,1).* matrix(:,2);
    total = sum(products);
    
    mean = total/tot_weights;
    
    
end

