function [ intertimes_sample ] = convertInstantsToIntertimes( instants_sample )
%LOADPARKINGINTERTIMESSAMPLE Summary of this function goes here
%   Detailed explanation goes here

    intertimes_sample = [];
    for idx = 2 : length(instants_sample)
        intertimes_sample = [ intertimes_sample; (instants_sample(idx) - instants_sample(idx - 1)) ];
    end
end