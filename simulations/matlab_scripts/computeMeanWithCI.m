% Computes mean of a sample with (1-alpha)-level confidence intervals.
% Dimension is used to compute mean of a matrix trough rows if dimension = 1, through columns if dimension = 2
% If not specified, dimension default value is the same as in MATLAB mean function

function [sample_mean, gap] = computeMeanWithCI( sample, alpha, dimension)
    if(~exist('dimension'))
        if(size(sample,1) == 1)
            dimension = 2;
        else
            dimension = 1;
        end
    end
    
    n = size(sample, dimension);
    S = std(sample,0,dimension);
    i = 1 - alpha;
    z_half_alpha = 4.91 * ( i^0.14 - (1 - i)^0.14 ); %Approximate formula
    
    sample_mean = mean(sample, dimension);
    gap = S/sqrt(n) * z_half_alpha;
end