% Plots the epdf of the samples taken in input. This is used for the waiting times of both queues.
% Width is a vector: the first element contains the width of the buckets, the second one the unit of measure (minutes or seconds). 
% Returns the histogram that represents the epdf.

function [ h ] = plotTimePDF( samples, width )
    if width(2) == string('minutes')
        seconds_width = str2num( width(1).char ) * 60;
    else
        seconds_width = str2num( width(1).char );
    end
    
	max_value = 0;
    for idx = 1 : samples.size
        tempsample = samples.(['v', string(idx).char]);
        max_value = max( max_value, max(tempsample));
    end    

    bucketsMat = zeros(samples.size, floor( (max_value / seconds_width) + 1) );
    for sampleIdx = 1 : samples.size
        sample = samples.(['v', string(sampleIdx).char]);
                
        for timeIdx = 1 : length(sample)
            bucketsMat(sampleIdx, floor( sample(timeIdx) / seconds_width ) + 1) = bucketsMat(sampleIdx, floor( sample(timeIdx) / seconds_width ) + 1) + 1;
        end
        
        bucketsMat(sampleIdx, :) = bucketsMat(sampleIdx, :) / length(sample);
    end

    [ meanBucket, CIgaps ] = computeMeanWithCI( bucketsMat, 0.05, 1); 
    
    for gapIdx = 1 : size(CIgaps,2)
        CIgaps(gapIdx) = CIgaps(gapIdx) / meanBucket(gapIdx); 
    end
    
    bucketEdges = 0 : seconds_width : (floor(max_value) + seconds_width);

    h = histogram(bucketEdges(1:(length(bucketEdges)-1)), 'Normalization', 'probability');
    h.BinEdges = bucketEdges;
    xticks(bucketEdges);
    if width(2) == string('minutes')
        xticklabels(floor(bucketEdges/60));
    else
        xticklabels(floor(bucketEdges));
    end    
    h.BinCounts = meanBucket;          
    absoluteCIgaps = zeros(length(CIgaps), 1);
    
    for idx = 1 : length(absoluteCIgaps)
       absoluteCIgaps(idx) = CIgaps(idx)*h.Values(idx); 
    end
    hold on
    
    err_x = zeros(1,length(bucketEdges)-1);
    for idx = 1 : length(err_x)
        err_x(idx) = mean( bucketEdges( idx:(idx+1) ) );
    end
    
    errorbar(err_x, h.Values, absoluteCIgaps, 'CapSize', 30);
    
    valuesSize = size(h.Values,2);
    for idx = 0 : valuesSize - 1
        jdx = valuesSize - idx;
        if(h.Values(1,jdx) >= 10e-3)
            lim = h.BinEdges(1,jdx+1);
            break;
        end
    end
    xlim([0, lim]);
    ylim([0, 1]);
end