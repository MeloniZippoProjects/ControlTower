function [ lrz_fig ] = plotCurve( config )
%PLOTCURVE Summary of this function goes here
%   Detailed explanation goes here
   
    tot_sample = extractTotSample(config);
    subsmpl = subsample(tot_sample, ceil(log2(length(tot_sample)) - ceil( 8 )));
    
    
    %rescale to minutes
    subsmpl = subsmpl / 60;
    tot_sample = tot_sample / 60;
    
    
    sort_subsmpl = sort(subsmpl);
    sort_totsmpl = sort(tot_sample);
    T1 = sum(sort_subsmpl);
    N1 = size(sort_subsmpl,1);
    
    T2 = sum(sort_totsmpl);
    N2 = size(sort_totsmpl,1);
    
    x1 = 1/N1 : 1/N1 : 1;
    x2 = 1/N2 : 1/N2 : 1;
    y1 = zeros(N1,1);
    y2 = zeros(N2,1);
    y1(1,1) = sort_subsmpl(1,1);
    y2(1,1) = sort_totsmpl(1,1);
    for i = 2:N1
        y1(i,1) = y1(i-1,1) + sort_subsmpl(i,1);
    end
    
    for i = 2:N2
        y2(i,1) = y2(i-1,1) + sort_totsmpl(i,1);
    end
    
    y1 = y1 / T1;
    y2 = y2 / T2;
    
    fig_name = ['Lorenz Curve for ', string(config).char];
    lrz_curve = figure('Name',fig_name);
    hold on;
    
    %plot max fairness
    plot([0 1],[0 1]);
    
    plot(x1,y1, 'DisplayName', 'subsample');
    plot(x2,y2, 'DisplayName', 'totsample');
    
    hold off;
    
    legend('show');
    
    %{
    fig_name = ['Autocorr for ', string(config).char];
    autocorr_fig = figure('Name', fig_name);
    
    autocorr(subsmpl);
    %}    

end

