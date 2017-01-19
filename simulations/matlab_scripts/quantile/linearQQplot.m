function [ ] = linearQQplot( samples, distribution, exclude_zero, weighted )
%SAMPLE_QQ_PLOT Summary of this function goes here
%   Detailed explanation goes here

    min_n = inf;
    for smplIdx = 1 : samples.size
        sample = samples.(['v' string(smplIdx).char]);
        if exclude_zero
            sample(sample == 0) = [];
        end
        sample_size = length( sample );
        min_n = min(sample_size, min_n);
    end
    
    quantiles_x = 0.5/min_n : 1/min_n : (min_n - 0.5)/min_n;
      
    %computation of sample quantiles
    samples_mat = zeros(samples.size, min_n);
    for smplIdx = 1 : samples.size
        sample = samples.(['v' string(smplIdx).char]);
        if exclude_zero
            sample(sample == 0) = [];
        end
        samples_mat(smplIdx, : ) = sample(1:min_n);
    end
    
    gpu_samples_mat = gpuArray(samples_mat);
    gpu_samples_mat = sort(gpu_samples_mat, 2);
    [ sample_quantiles, q_CIgaps ] = computeMeanWithCI(gpu_samples_mat, 0.05, 1);
    sample_quantiles = gather(sample_quantiles);
    
    %computation of theoretical quantiles
    theoretical_dist = makedist(distribution);
    theoretical_quantiles = icdf(theoretical_dist, quantiles_x);
    
    %computation of sample quantiles and theoretical quantiles
    %{
    for qIdx = 1 : length(Qs)
        q = Qs(qIdx);
        
        if(weighted)
           sample = mergeSortLengthSample(sample);
           sample_quantiles(qIdx) = computeWeightedQuantile(mean_sample, q);
        else
           sample_quantiles(qIdx) = quantile(mean_sample, q);
        end
               
       %computation of theorical quantiles
       p_dist = makedist(distribution);
       theory_Q(qIdx) = icdf(p_dist,q);

    end
    %}

    hold on;
    errorbar(theoretical_quantiles, sample_quantiles, q_CIgaps);  
    
    regress_line = fitlm(theoretical_quantiles, sample_quantiles, 'RobustOpts', 'off');
    plot(regress_line);
    title(['QQ Plot vs ' distribution]);
    grid on;
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    hold off;
end

