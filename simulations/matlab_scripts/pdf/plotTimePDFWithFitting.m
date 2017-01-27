function [ h ] = plotTimePDFWithFitting( samples, fitting )
    % Generate theoretical distribution

    if(fitting == 'exponential') 
        lambda_mles = zeros(1,samples.size);
        for smplIdx = 1 : samples.size 
            sample = samples.(['v' string(smplIdx).char]);
            if(length(sample) < 1)
                continue;
            end
            lambda_mles(smplIdx) = mean( sample );   
        end
        exp_mle = mean(lambda_mles);
        pd = makedist('Exponential', 'mu', exp_mle);
    elseif(fitting == 'lognormal')
        mu_mles = zeros(1, samples.size);
        sigma_mles = zeros(1, samples.size);
        for smplIdx = 1 : samples.size 
            sample = samples.(['v' string(smplIdx).char]);
            mu_mles(smplIdx) = mean( log( sample ) );
            sigma_mles(smplIdx) = sqrt( mean( ( log(sample) - mu_mles(smplIdx) ).^2 ) );
        end
        pd = makedist('Lognormal','mu',mean(mu_mles), 'sigma', mean(sigma_mles) );
    elseif(fitting == 'normal')
        mu_mles = zeros(1,samples.size);
        sigma_mles = zeros(1, samples.size);
        for smplIdx = 1 : samples.size 
            sample = samples.(['v' string(smplIdx).char]);
            mu_mles(smplIdx) = mean( sample );
            sigma_mles(smplIdx) = sqrt( mean( (sample - mu_mles(smplIdx) ).^2 ) );
        end
        pd = makedist('Normal','mu',mean(mu_mles), 'sigma', mean(sigma_mles) );
    elseif(fitting == 'weibull')
        scale_mles = zeros(1,samples.size);
        shape_mles = zeros(1, samples.size);
        for smplIdx = 1 : samples.size 
            sample = samples.(['v' string(smplIdx).char]);
            a = mle(sample, 'distribution', fitting.char);
            scale_mles(smplIdx) = a(1);
            shape_mles(smplIdx) = a(2);
        end
        pd = makedist('Weibull','a',mean(scale_mles), 'b', mean(shape_mles) );
    elseif(fitting == 'gamma')
        scale_mles = zeros(1,samples.size);
        shape_mles = zeros(1, samples.size);
        for smplIdx = 1 : samples.size 
            sample = samples.(['v' string(smplIdx).char]);
            a = mle(sample, 'distribution', fitting.char);
            scale_mles(smplIdx) = a(1);
            shape_mles(smplIdx) = a(2);
        end
        pd = makedist('Gamma','a',mean(scale_mles), 'b', mean(shape_mles) );
    elseif(fitting == 'uniform')
        min_mles = zeros(1, samples.size);
        max_mles = zeros(1, samples.size);
        for smplIdx = 1 : samples.size
            sample = samples.(['v' string(smplIdx).char]);
            a = mle(sample, 'distribution', fitting.char);
            min_mles(smplIdx) = a(1);
            max_mles(smplIdx) = a(2);
        end
        pd = makedist('Uniform','lower',mean(min_mles), 'upper', mean(max_mles) );
    end

    % Plot EPDF of the theoretical distribution

    pd_sample_size = 10000;
    pd_sample = zeros(1, pd_sample_size);
    for idx = 1:pd_sample_size
        pd_sample(idx) = random(pd);
    end

    h_pd = histogram(pd_sample, 'DisplayName', string(['Fitting reference: PDF of ' fitting]).char , 'Normalization', 'probability', 'FaceColor', 'black', 'FaceAlpha', 0.2);%, 'Visible', 'off'  );
    bucketEdges = h_pd.BinEdges;
    
    % Plot EPDF of the samples, using the same bucket width of the theoretical's one 

    bucketsMat = zeros(samples.size, length(bucketEdges) - 1 );
    for sampleIdx = 1 : samples.size
        sample = samples.(['v', string(sampleIdx).char]);
        if(length(sample) < 1)
            continue;
        end
        h_temp = histcounts(sample, bucketEdges);
        h_temp = h_temp / length(sample);        
        bucketsMat(sampleIdx, :) = h_temp;
    end

    [ meanBucket, CIgaps ] = computeMeanWithCI( bucketsMat, 0.05, 1); 
    hold on
    
    err_x = zeros(1,length(bucketEdges)-1);
    
    for idx = 1 : length(err_x)
        err_x(idx) = mean( bucketEdges( idx:(idx+1) ) );
    end
    
    
    h = histogram(err_x, bucketEdges, 'DisplayStyle', 'stairs', 'LineWidth', 3, 'EdgeColor', 'red', 'Visible', 'off'  );
    h.BinCounts = meanBucket;
    uistack(h, 'bottom');
    
    bar_plot = bar(err_x, meanBucket, 0.5, 'DisplayName', 'EPDF of the samples', 'FaceAlpha', 1);
    errorbar(err_x, meanBucket, CIgaps);
    
    % Visual adjustments

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
    
    legend([ h_pd, bar_plot ]);

    ax = gca;
    xticks(ax, bucketEdges);

    xSecondsTicks = get(ax, 'XTick'); % get the current tick points of the y axis
    xMinutesTicks = cellstr(num2str(xSecondsTicks'/60, 3)); %create a cell array of strings
    set( ax, 'XTickLabel', xMinutesTicks);

    xlabel('Waiting time in minutes');
    ylabel('Probability');
  
    hold off;
end
