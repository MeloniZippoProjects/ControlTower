% Converts the data obtained via simulation to a format easier to work with, that consists in a row for each state change.
% For each row, the first column is the lenght value and the second column is the duration this status has been kept.
% Instantaneous changes, that is states that lasted 0 seconds, are filtered out.

function [converted_sample] = convertLengthSample(sample)
    first_parse = [];
    for idx = 1 : ( size(sample, 1) - 1 )
        if sample(idx, 1) == sample(idx + 1, 1)
        	continue;
    	else
    		first_parse = [first_parse; sample(idx, 2) (sample(idx + 1, 1) - sample(idx, 1)) ];
		end
    end

    converted_sample = [];
    
    current_value = first_parse(1, :);
    for idx = 2 : size(first_parse, 1)
    	if first_parse(idx, 1) == current_value(1, 1)
    		current_value(1, 2) = current_value(1, 2) + first_parse(idx, 2);
    		continue;
		else
			converted_sample = [converted_sample; current_value];
			current_value = first_parse(idx, :);
		end
	end	
	converted_sample = [converted_sample; current_value];
end