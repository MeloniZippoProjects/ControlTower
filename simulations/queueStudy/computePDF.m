function [subsmpl] = computePDF(config, rho, width, pdffig)
	tot_sample = extractTotSample(config, rho);
	subsmpl = subsample(tot_sample, ceil(log2(length(tot_sample)) - ceil( 12 - str2double(rho)*6)));
    
    if( ~( isempty( regexp(config, 'Time', 'once')) ) )
        subsmpl = subsmpl / 60;
    end
    
	figure('Name', strcat('Autocorr for ', config, ' ', string(rho).char));
	autocorr(subsmpl);
    
    zero_count = 0;
    subsmpl_nozero = [];
    
    for idx = 1 : length(subsmpl)
       if subsmpl(idx) == 0
           zero_count = zero_count + 1;
       else
           subsmpl_nozero = [subsmpl_nozero, subsmpl(idx)];
       end
    end
    
    p_zero = zero_count / length(subsmpl);
      
    figure(pdffig);
	hold on;
    
    p = plot(0, p_zero);
    p.Marker = '*';
    
    h = histogram(subsmpl_nozero, 'DisplayName', rho, 'DisplayStyle', 'stairs');
    h.EdgeColor = p.Color;
    h.BinWidth = width;
    h.BinCounts = ( h.BinCounts / sum(h.BinCounts)) * ( 1 - p_zero);
end