% Computes 2kr regression coefficients, SSx, SSE, fx, CI at given (1-alfa) level, std devs.
% Combs is a 2^K per K matrix, where K is the number of factors, and each row is one of possible
% combinations of factors.
% Measures is a 2^K per R matrix, where R is the number of repetitions. Each row contains all 
% measurements for the respective combination in combs.  

function [ qs, SSx, SSE, fx, CI, std_devs ] = analysis_2kr( combs, measures, alfa, graph_name )


    coeff_matrix = create_factorial_matrix(combs);
    two_k = size(combs,1);
    r = size(measures,2);
    mean_col = mean(measures.').';
    qs = (mean_col.' * coeff_matrix)/two_k;
    error_matrix = measures - mean_col;
    SSE = sum(sum(error_matrix.^2));
    SSx = (qs(2:length(qs)).^2)*two_k*r;
    SST = sum(SSx) + SSE;
    fx = [ SSx/SST, SSE/SST];
    
    %save graphs and print them
    qq_fig = draw_qq_plot(error_matrix, graph_name);
    [std_fig, std_devs] = draw_residuals_plot(mean_col, error_matrix, graph_name);
    
    startcd = cd;
    foldername = fullfile('graphs', '2kr');
    warning('off', 'all');
    mkdir(foldername);
    warning('on', 'all');
    cd(foldername);
        print( qq_fig, [ 'qq_plot.png' ], '-dpng' );
        savefig( qq_fig, [ 'qq_plot.fig' ] );
        print( std_fig, [ 'residuals_plot.png' ], '-dpng' );
        savefig( std_fig, [ 'residuals_plot.fig' ] );
    cd(startcd);
    
    % computation of CIs through T student distribution
    free_deg = two_k*(r-1);
    error_var = SSE/(free_deg);
    CI = -tinv(alfa/2,free_deg)*sqrt(error_var/(two_k*r));
end

