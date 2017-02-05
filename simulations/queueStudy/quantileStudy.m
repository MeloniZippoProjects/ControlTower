% Computes p-quantile of each vector for every factor set and stores it in a .mat file for future uses

distributions = [ string('exponential'); string('lognormal') ]; 
scenarios = [   string('rho0.1'); string('rho0.15'); string('rho0.2'); string('rho0.25'); string('rho0.3'); string('rho0.35'); string('rho0.4'); string('rho0.45'); string('rho0.5');
                string('rho0.55'); string('rho0.6'); string('rho0.65'); string('rho0.7'); string('rho0.75'); string('rho0.8'); string('rho0.85'); string('rho0.9')];
timeVector = [ 'landingQueue_queueTime'; 'takeoffQueue_queueTime' ];
lengthVector = [ 'landingQueue_queueLength'; 'takeoffQueue_queueLength' ];
p = 0.90;       % valore dei quantili calcolati
alfa = 0.05;    % (1-alfa) è il livello di confidenza della media dei quantili

for distIdx = 1 : size(distributions, 1)
    cd( distributions(distIdx,:).char );

    disp 'Computing quantiles'

    quantileTimeMean = zeros(size(scenarios, 1), 2);
    quantileTimeMean_gap = zeros(size(scenarios, 1), 2);

    quantileLengthMean = zeros(size(scenarios, 1), 2);
    quantileLengthMean_gap = zeros(size(scenarios, 1), 2);
    
    for scenarioIdx = 1:size(scenarios, 1)
        rho = scenarios(scenarioIdx,:).char;

        % quantili per i tempi
        for vectorIdx = 1:2
            samples = loadTimeSamples(timeVector(vectorIdx,:), rho);
            q = zeros(samples.size, 1);
            for k = 1 : samples.size
                q(k) = quantile( samples.(['v',string(k).char]) , p );
            end
             [ quantileTimeMean(scenarioIdx, vectorIdx), quantileTimeMean_gap(scenarioIdx, vectorIdx)] = computeMeanWithCI ( q, alfa );
        end

        %quantili pesati per le lunghezze
        for vectorIdx = 1:2
            samples = loadLengthSamples(lengthVector(vectorIdx,:), rho);
            q = zeros(samples.size, 1);
            for k = 1 : samples.size
                q(k) = computeWeightedQuantile( mergeSortLengthSample( samples.(['v',string(k).char]) ) , p );
            end
             [ quantileLengthMean(scenarioIdx, vectorIdx), quantileLengthMean_gap(scenarioIdx, vectorIdx)] = computeMeanWithCI ( q, alfa );
        end
    end
    
    save('quantileTimeMean.mat', quantileTimeMean);
    save('quantileLengthMean.mat', quantileLengthMean);

    disp 'Processing quantiles plots'

    startcd = cd;
    foldername = fullfile('graphs', 'quantileFigures');

    warning('off', 'all');
    mkdir(foldername);
    warning('on', 'all');
    rhoes = [0.1; 0.15; 0.2; 0.25; 0.3; 0.35; 0.4; 0.45; 0.5; 0.55; 0.6; 0.65; 0.7; 0.75; 0.8; 0.85; 0.9];
    %Time
    parfor vectorIdx = 1:2
        figTitle = ['Quantiles of ', timeVector(vectorIdx,:), ' for ', distributions(distIdx,:).char, ' case' ];
        fig = figure('Name', figTitle);
        errorbar( rhoes , quantileTimeMean(:, vectorIdx) , quantileTimeMean_gap(:, vectorIdx), min( quantileTimeMean(:, vectorIdx), quantileTimeMean_gap(:, vectorIdx)) );
        yl = ylim;
        ylim([0 yl(2)]);
        xlim([0 1]);
        
        cd(foldername);
            print( fig, [ figTitle, '.png' ], '-dpng' );
            savefig( fig, [ figTitle, '.fig' ] );
        cd(startcd);
        
    end

    %Length
    parfor vectorIdx = 1:2
        figTitle = ['Quantiles of ', lengthVector(vectorIdx,:), ' for ', distributions(distIdx,:).char, ' case' ];
        fig = figure('Name', figTitle);
        errorbar( rhoes , quantileLengthMean(:, vectorIdx) , quantileLengthMean_gap(:, vectorIdx), min(quantileLengthMean(:, vectorIdx), quantileLengthMean_gap(:, vectorIdx)) );
        yl = ylim;
        ylim([0 yl(2)]);
        xlim([0 1]);
        
        cd(foldername);
            print( fig, [ figTitle, '.png' ], '-dpng' );
            savefig( fig, [ figTitle, '.fig' ] );
        cd(startcd);
    end
end