% Plots the weighted epdf of the samples taken in input. This is used for the lenght of both queues and for the parking size.
% Returns the histogram that represents the epdf.

function [ h ] = plotLengthPDF( samples )
    max_value = 0;
    for idx = 1 : samples.size
        tempsample = samples.(['v', string(idx).char])(:, 1);
        max_value = max( max_value, max(tempsample));
    end
    
    bucketsMat = zeros(samples.size, max_value + 1);
    for sampleIdx = 1 : samples.size
        sample = samples.(['v', string(sampleIdx).char]);
        sample = mergeSortLengthSample(sample);
                
        for lengthIdx = 1 : size(sample, 1) 
            bucketsMat(sampleIdx, sample(lengthIdx, 1) + 1) = bucketsMat(sampleIdx, sample(lengthIdx, 1) + 1) + sample(lengthIdx, 2);
        end
        
        bucketsMat(sampleIdx, :) = bucketsMat(sampleIdx, :) / sum(sample(:, 2));
    end
       
    [ meanBucket, CIgaps ] = computeMeanWithCI( bucketsMat, 0.05 , 1); 
    
    for gapIdx = 1 : size(CIgaps,2)
        CIgaps(gapIdx) = CIgaps(gapIdx) / meanBucket(gapIdx); 
    end
    
    bucketEdges = 0 : 1 : max_value + 1;
    
    h = histogram(bucketEdges( 1:( length( bucketEdges )-1 ) ) , 'Normalization', 'probability'); 
    xticks(bucketEdges);
    h.BinEdges = bucketEdges;
    h.BinCounts = meanBucket;
   
    err_x = zeros(1,length(bucketEdges)-1);
    for idx = 1 : length(err_x)
        err_x(idx) = mean( bucketEdges( idx:(idx+1) ) );
    end
    
    absoluteCIgaps = zeros(length(CIgaps), 1);
    for idx = 1 : length(absoluteCIgaps)
       absoluteCIgaps(idx) = CIgaps(idx)*h.Values(idx); 
    end
    hold on
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