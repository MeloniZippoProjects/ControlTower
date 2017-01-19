function [ intertimes_samples ] = loadIntertimesSamples( vector, scenario )
%LOADTakeoffINTERTIMESSAMPLE Summary of this function goes here
%   Detailed explanation goes here

	instants_samples = loadInstantsSamples( vector, scenario);
    intertimes_samples = struct();
    
    for idx = 1 : instants_samples.size
     	intertimes_sample = convertInstantsToIntertimes( instants_samples.(['v' string(idx).char]) );
	    intertimes_samples.(['v' string(idx).char ]) = intertimes_sample;
   	end
	intertimes_samples.size = instants_samples.size;
end