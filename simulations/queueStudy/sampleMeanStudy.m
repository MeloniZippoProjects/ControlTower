distributions = [ string('exponential'); ]; 
scenarios = [   string('rho0.1'); string('rho0.15'); string('rho0.2'); string('rho0.25'); string('rho0.3'); string('rho0.35'); string('rho0.4'); string('rho0.45'); string('rho0.5');
                string('rho0.55'); string('rho0.6'); string('rho0.65'); string('rho0.7'); string('rho0.75'); string('rho0.8'); string('rho0.85'); string('rho0.9')];
timeVector = [ 'landingQueue_queueTime'; 'takeoffQueue_queueTime' ];
alfa = 0.05; %(1-alfa) è il livello di confidenza della media dei quantili

for distIdx = 1 : size(distributions, 1)
    cd( distributions(distIdx,:).char );

    disp 'Computing sample means'

    sampleMean = zeros(size(scenarios, 1), 2);
    sampleMean_gap = zeros(size(scenarios, 1), 2);
    
    for scenarioIdx = 1:size(scenarios, 1)
        rho = scenarios(scenarioIdx,:).char;
        for vectorIdx = 1:2
            samples = loadTimeSamples(timeVector(vectorIdx,:), rho);
            m = zeros(samples.size, 1);
            for k = 1 : samples.size
                m(k) = mean( samples.(['v',string(k).char]) );
            end
            [ sampleMean(scenarioIdx, vectorIdx), sampleMean_gap(scenarioIdx, vectorIdx)] = computeMeanWithCI ( m, alfa );
        end
    end
    
    disp 'Processing sample means plots'

    startcd = cd;
    foldername = fullfile('graphs', 'meanFigures');

    warning('off', 'all');
    mkdir(foldername);
    warning('on', 'all');
    rhoes = [0.1; 0.15; 0.2; 0.25; 0.3; 0.35; 0.4; 0.45; 0.5; 0.55; 0.6; 0.65; 0.7; 0.75; 0.8; 0.85; 0.9];
    %Time
    parfor vectorIdx = 1:2
        figTitle = ['Means of ', timeVector(vectorIdx,:), ' for ', distributions(distIdx,:).char, ' case' ];
        fig = figure('Name', figTitle);
        errorbar( rhoes , sampleMean(:, vectorIdx) , sampleMean_gap(:, vectorIdx), min( sampleMean(:, vectorIdx), sampleMean_gap(:, vectorIdx)) );
        yl = ylim;
        ylim([0 yl(2)]);
        xlim([0 1]);
        
        cd(foldername);
            print( fig, [ figTitle, '.png' ], '-dpng' );
            savefig( fig, [ figTitle, '.fig' ] );
        cd(startcd);
        
    end
    
    disp 'Processing regression studies'
    disp 'Regression for landingQueue_queueTime'
        cutIdx = 1;
        linearRegressionStudy(rhoes(cutIdx:size(rhoes, 1)), sampleMean(cutIdx:size(rhoes, 1), 1), 'landingQueue_queueTime', foldername);
    disp 'Regression for takeoffQueue_queueTime'
        cutIdx = 1;
        exponentialRegressionStudy(rhoes(cutIdx:size(rhoes, 1)), sampleMean(cutIdx:size(rhoes, 1), 2), 'takeoffQueue_queueTime', foldername);
    cd ..
end