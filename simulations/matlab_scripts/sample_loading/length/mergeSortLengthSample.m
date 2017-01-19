function [ merged_sample ] = mergeSortLengthSample ( sample )
	sample = sortrows(sample);
    merged_sample = [];
    current_value = sample(1, :);
    for idx = 2 : size(sample, 1)
    	if sample(idx, 1) == current_value(1, 1)
    		current_value(1, 2) = current_value(1, 2) + sample(idx, 2);
    		continue;
		else
			merged_sample = [merged_sample; current_value];
			current_value = sample(idx, :);
		end
	end	
	merged_sample = [merged_sample; current_value];
end