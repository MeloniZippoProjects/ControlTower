% Draws QQ plot of timeVectors for every distribution listed in fittings.

distributions = [ string('exponential'); string('lognormal') ];
timeVectors = [string('landingQueue_queueTime'); string('takeoffQueue_queueTime')];
scenarios = [   string('rho0.1'); string('rho0.15'); string('rho0.2'); string('rho0.25'); string('rho0.3'); string('rho0.35'); string('rho0.4'); string('rho0.45'); string('rho0.5');
                string('rho0.55'); string('rho0.6'); string('rho0.65'); string('rho0.7'); string('rho0.75'); string('rho0.8'); string('rho0.85'); string('rho0.9')];
fittings = [string('exponential'); string('normal'); string('lognormal'); string('weibull'); string('gamma');];
zeroPolicies = [ 'includeZero'; 'excludeZero' ];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);
    
    for polIdx = 1 : size(zeroPolicies, 1)
        zeroPolicy = zeroPolicies(polIdx, :);
        
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