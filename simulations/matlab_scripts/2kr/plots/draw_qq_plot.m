function [ qq_fig ] = draw_qq_plot( err_matrix, graph_name)
%QQ_PLOT Summary of this function goes here
%   Detailed explanation goes here

    err_vector = sort(err_matrix(:));
    N = size(err_vector,1);
    i = 1:1:N;
    
    quantiles = (i-0.5)/N;
    
    normalQ = 4.91*(quantiles.^0.14 - (1 - quantiles).^0.14);
    
    qq_fig = figure('Name', graph_name);
    hold on;
    
    plot(normalQ,err_vector, 'x'); 
    
    regress_line = fitlm(normalQ, err_vector, 'RobustOpts', 'off');
    plot(regress_line);
    title('QQ Plot: Residuals vs Normal');
    grid on;
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    hold off;
    %LinearModel.fit
end

