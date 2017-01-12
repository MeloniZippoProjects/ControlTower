function [subsmpl] = computeLengthPDF(config, rho, pdffig)
	tot_sample = extractTotalLengthSample(config, rho);
    subsmpl = subsample(tot_sample, ceil(log2(length(tot_sample)) - ceil( 12 - str2double(rho)*6)));
    
	figure('Name', strcat('Autocorr for ', config, ' ', string(rho).char));
	autocorr(subsmpl(:, 1));
      
    figure(pdffig);
	hold on;
    
    subsmpl = sortrows(subsmpl);
    hist_data = [];
    current_value = subsmpl(1, :);
    for idx = 2 : size(subsmpl, 1)
    	if subsmpl(idx, 1) == current_value(1, 1)
    		current_value(1, 2) = current_value(1, 2) + subsmpl(idx, 2);
    		continue;
		else
			hist_data = [hist_data; current_value];
			current_value = subsmpl(idx, :);
		end
	end	
	hist_data = [hist_data; current_value];
    
    hist_label = strcat(string('pdf of '), rho);
    h = histogram(hist_data(:, 1), 'DisplayName', hist_label.char , 'DisplayStyle', 'stairs', 'Normalization', 'probability');
    for idx = 1 : size(hist_data, 1)
        h.BinCounts(round( hist_data(idx, 1) ) + 1) = hist_data(idx, 2);
    end
end