function [quantile] = computeWeightedQuantile(sortedSample, p) %sortedSample deve essere ordinato e pesato
    weight_sum = 0; %somma dei pesi
    for idx = 1 : size(sortedSample, 1);
        weight_sum = weight_sum + sortedSample(idx, 2);
    end
    
    %calcolo del quantile
    partial_sum = 0; %somma parziale dei pesi
    for idx = 1 : size(sortedSample, 1)
        old_part_sum = partial_sum;
        partial_sum = partial_sum + sortedSample(idx,2);
        if ( partial_sum > weight_sum*p )
            %q = sortedSample(idx, 1);
            x = [old_part_sum, partial_sum] / weight_sum;
            
            if(idx == 1)
                v = [0, sortedSample(idx,1)];
            else
                v = [sortedSample(idx - 1, 1), sortedSample(idx, 1)];
            end
            quantile = interp1(x,v,p);
            break;
        end
    end

end