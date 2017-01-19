function [ std_fig, std_devs ] = draw_residuals_plot( means, err_matrix, graph_name )
%CONST_STD_PLOT Summary of this function goes here
%   Detailed explanation goes here
    std_fig = figure('Name', graph_name);
    hold on;
    title('Residuals vs avg predicted response');
    grid on;
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    lims = [min(min(err_matrix))*1.2 max(max(err_matrix))*1.2];
    if(~(isequal(lims,[0 0])))
        ylim(lims);
    end
    
    %xlabel('Residuals');
    ylabel('Predicted Response');
    
    plot(means, err_matrix,'*');
    std_devs = std(err_matrix.').';
end

