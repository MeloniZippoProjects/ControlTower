function [ concatenated_sample ] = samplecat( samples )
	concatenated_sample = [];
    for idx = 1 : samples.size
        concatenated_sample = [	concatenated_sample; 
        						samples.(strcat('v', string(idx).char))];
    end
end