function [ index ] = bucketIndex( bucketEdges, value )
%BUCKETINDEX Summary of this function goes here
%   Detailed explanation goes here
disp(value);
    for idx = 1 : (length(bucketEdges) - 1)
        if( bucketEdges(idx) <= value && value < bucketEdges(idx+1) )
           index = idx;
           return;
        end
    end

end

