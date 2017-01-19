distributions = [ string('deterministic'); string('exponential'); string('normal') ];
rhos = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
timeVector = [ 'takeoffQueue_queueTime' ; 'landingQueue_queueTime' ];
lengthVector = [ 'takeoffQueue_queueLength' ; 'landingQueue_queueLength' ];
p = 0.90; %percentuale dei quantili calcolati
alfa = 0.05; %(1-alfa) è il livello di confidenza della media dei quantili

for distIdx = 1:3
    cd( distributions(distIdx,:).char );

    for rhoIdx = 1:size(rhos, 1)
        rho = rhos(rhoIdx,:);

        %quantili normali per i tempi
        for vecIdx = 1:2
            %disp('Sto estraendo sample per il tempo'),
            samples = loadTimeSamples(timeVector(vecIdx,:), rho);
            %disp('Sto calcolando tutti i quantili per il tempo');
            for k = 1 : samples.size
                q(k) = quantile( samples.(['v',string(k).char]) , p );
            end
            %disp('Sto calcolando le medie dei quantili con i CI per il tempo');
            [ quantileTimeMean(rhoIdx, vecIdx), quantileTimeMean_gap(rhoIdx, vecIdx)] = computeMeanWithCI ( q, alfa );
        end

        %quantili pesati per le lunghezze
        for vecIdx = 1:2
            %disp('Sto estraendo sample per le lunghezze'),
            samples = loadLengthSamples(lengthVector(vecIdx,:), rho);
            %disp('Sto calcolando tutti i quantili per le lunghezze');
            for k = 1 : samples.size
                q(k) = computeWeightedQuantile( mergeSortLengthSample( samples.(['v',string(k).char]) ) , p );
            end
            %disp('Sto calcolando le medie dei quantili con i CI per le lunghezze');
            [ quantileLengthMean(rhoIdx, vecIdx), quantileLengthMean_gap(rhoIdx, vecIdx) ] = computeMeanWithCI( q, alfa );
        end

    end

    %stampo i grafici dei quantili
    startcd = cd;
    foldername = fullfile('graphs', 'quantileFigures');

    mkdir(foldername);
    rhoes = [0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9];
    %Time
    for vecIdx = 1:2
        figTitle = ['Quantiles of ', timeVector(vecIdx,:), ' for ', distributions(distIdx,:).char, ' case' ];
        fig = figure('Name', figTitle);
        errorbar( rhoes , quantileTimeMean(:, vecIdx) , quantileTimeMean_gap(:, vecIdx), min( quantileTimeMean(:, vecIdx), quantileTimeMean_gap(:, vecIdx)) );
        yl = ylim;
        ylim([0 yl(2)]);
        xlim([0 1]);
        cd(foldername);
            print( fig, [ figTitle, '.png' ], '-dpng' );
            savefig( fig, [ figTitle, '.fig' ] );
        cd(startcd);
    end
    %Length
    for vecIdx = 1:2
        figTitle = ['Quantiles of ', lengthVector(vecIdx,:), ' for ', distributions(distIdx,:).char, ' case' ];
        fig = figure('Name', figTitle);
        errorbar( rhoes , quantileLengthMean(:, vecIdx) , quantileLengthMean_gap(:, vecIdx), min(quantileLengthMean(:, vecIdx), quantileLengthMean_gap(:, vecIdx)) );
        yl = ylim;
        ylim([0 yl(2)]);
        xlim([0 1]);
        cd(foldername);
            print( fig, [ figTitle, '.png' ], '-dpng' );
            savefig( fig, [ figTitle, '.fig' ] );
        cd(startcd);
    end

    cd ..
end