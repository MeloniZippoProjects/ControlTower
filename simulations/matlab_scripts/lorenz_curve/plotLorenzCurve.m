function [ lrz_fig ] = plotLorenzCurve( scenario, vector, alfa )
%PLOTCURVE Summary of this function goes here
%   Detailed explanation goes here
   
    tot_sample = loadTimeSamples(vector, scenario);   
    
	%plot max fairness
	plot([0 1],[0 1],'DisplayName', 'Max Fairness');
	
	%Query Points
	xq = 0.01 : 0.01 : 1;
    
    curves_matrix = zeros(tot_sample.size, length(xq), 'gpuArray');
	
	for sampleIdx = 1 : tot_sample.size
	
		sample = gpuArray(tot_sample.(['v' string(sampleIdx).char]));
		sorted_sample = sort(sample);
		
		T = sum(sorted_sample);
		N = size(sorted_sample,1);
	
		x = 1/N : 1/N : 1;

		y = zeros(N,1, 'gpuArray');
		for yIdx = 1:N
			y(yIdx,1) = sum(sorted_sample(1:yIdx));
		end
		y = y / T;

		yq = interp1(x, gather(y), xq);
        
        curves_matrix(sampleIdx, :) = yq;
    end
	
    %approximate sample variance for large number of repeats
    stdevs = std(curves_matrix);  
    n = tot_sample.size;
    
    main_curve = mean(curves_matrix);
    
    CI_gap = (stdevs/sqrt(n))*norminv(1 - alfa/2);
    
    upper_curve = min(1, main_curve + CI_gap);
    lower_curve = max(0, main_curve - CI_gap);
    
    hold on;
    
	plot(xq,main_curve, 'DisplayName', 'Main Curve');
    plot(xq,upper_curve, 'DisplayName', 'Upper Confidence Bound');
    plot(xq,lower_curve, 'DisplayName', 'Lower Confidence Bound');
		
	hold off;
	
	legend('show');
end

