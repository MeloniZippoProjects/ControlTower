function [pdffig] = pdffunction(config, width)
    %rhos = ['0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'];
    rhos = ['0.1'; '0.3'; '0.5'; '0.7'; '0.9'];
    pdffig = figure('Name',strcat(config, ' pdfs'));

    rng(19, 'twister');

    for idx = 1 : length(rhos)
        computePDF(config, rhos(idx, :), width, pdffig);	
    end

    figure(pdffig);
    legend('show');
end