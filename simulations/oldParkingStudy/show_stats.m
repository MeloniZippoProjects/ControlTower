function [] = show_stats(rho, config, factor)
    disp(strcat('showing case: ',config,'_',factor));
    run parkingOccupancy.m
    maxs = zeros(1,vectors.size);
    means = zeros(1,vectors.size);
    for i=1:vectors.size
       vector_name = strcat('parkingLot_parkingOccupancy_',string(i-1).char);
       x = vectors.(vector_name);
       maxs(i) = max(x(:,2));
       means(i) = mean(x(:,2));
    end

    csvwrite('maxs.csv',maxs);

    disp(strcat('0.95-quantile = ', string(quantile(maxs,0.95))));
    disp(strcat('mean = ', string(mean(maxs))));
    disp(strcat('median = ', string(median(maxs))));
    disp(strcat('mode = ', string(mode(maxs))));

    fig_means = figure('Name',strcat('Means for "',rho,'_',config,'_', factor,'"'));
    hold on;
    histogram(means, 'Normalization', 'pdf');
    try
        pd = fitdist(means.','Normal');
        x = 0:0.01:max(means)+2;
        y = pdf(pd,x);
        plot(x,y);
    catch
        disp('errore fitting means');
    end
    
    hold off;

    fig_maxs = figure('Name',strcat('Maxs for "',rho,'_',config,'_', factor,'"'));
    hold on;
    histogram(maxs, 'Normalization', 'pdf');
    try
        pd = fitdist(maxs.','Normal');
        x = 0:0.01:max(maxs)+4;
        y = pdf(pd,x);
        plot(x,y);
        
    catch
        disp('errore fitting maxs');
    end
    hold off;
end
