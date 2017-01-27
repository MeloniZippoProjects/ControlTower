distributions = [ string('exponential'); string('normal'); string('lognormal'); string('lognormal')]; %string('deterministic');
timeVectors = [string('landingQueue_queueTime'); string('takeoffQueue_queueTime')];
lengthVectors = [ string('landingQueue_queueLength'); string('takeoffQueue_queueLength')];
scenarios = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
fittings = [string('exponential'); string('normal'); string('lognormal'); string('weibull'); string('gamma');];
zeroPolicies = [ 'includeZero'; 'excludeZero' ];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);
    
    for polIdx = 1 : size(zeroPolicies, 1)
        zeroPolicy = zeroPolicies(polIdx, :);
        
        %{
        Ridiscutere fitting pesato
        for vectorIdx = 1 : length(lengthVectors)
            vector = lengthVectors(vectorIdx).char;

            for scenIdx = 1 : length(scenarios)
                scenario = scenarios(scenIdx, :);

                samples = loadLengthSamples(vector, scenario);

                parfor fitIdx = 1 : length(fittings)
                    fitting = fittings(fitIdx).char;

                    figname = ['fitting to ' fitting ' for ' distribution ', ' vector ', ' scenario];
                    fig = figure('Name', figname);
                    linearQQplot(samples, fitting, 1);

                    startcd = cd;
                    foldername = fullfile('graphs', 'pdf', 'fittings', zeroPolicy, fitting);
                    warning('off', 'all');
                        mkdir(foldername);
                    warning('on', 'all');
                    cd(foldername)
                        print(fig, [ figname '.png' ] , '-dpng');
                        savefig(fig, [figname '.fig']);
                    cd(startcd)
                end
            end
        end
        %}

        for vectorIdx = 1 : length(timeVectors)
            vector = timeVectors(vectorIdx).char;

            parfor scenIdx = 1 : length(scenarios)
                scenario = scenarios(scenIdx, :);

                samples = loadTimeSamples(vector, scenario);

                for fitIdx = 1 : length(fittings)
                    fitting = fittings(fitIdx).char;

                    figname = ['fitting to ' fitting ' for ' distribution ', ' zeroPolicy ', ' vector ', ' scenario];
                    fig = figure('Name', figname);
                    if strcmp(zeroPolicy, 'includeZero')
                        linearQQplot(samples, fitting, 0, 0);
                    else
                        linearQQplot(samples, fitting, 1, 0);
                    end
                    
                    startcd = cd;
                    foldername = fullfile('graphs', 'pdf', 'fittings', zeroPolicy, fitting);
                    warning('off', 'all');
                        mkdir(foldername);
                    warning('on', 'all');
                    cd(foldername)
                        print(fig, [ figname '.png' ] , '-dpng');
                        savefig(fig, [figname '.fig']);
                    cd(startcd)
                end
            end
        end
    end
    cd ..
end