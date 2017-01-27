distributions = [ string('exponential'); string('lognormal')];
timeVectors = [string('landingQueue_queueTime'); string('takeoffQueue_queueTime'); ];
lengthVectors = [ string('landingQueue_queueLength'); string('takeoffQueue_queueLength')];
scenarios = [   string('rho0.1'); string('rho0.15'); string('rho0.2'); string('rho0.25'); string('rho0.3'); string('rho0.35'); string('rho0.4'); string('rho0.45'); string('rho0.5');
                string('rho0.55'); string('rho0.6'); string('rho0.65'); string('rho0.7'); string('rho0.75'); string('rho0.8'); string('rho0.85'); string('rho0.9')];
numPlots = 30;

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
	
    cd(distribution);

	for vectorIdx = 1 : length(lengthVectors)
		vector = lengthVectors(vectorIdx).char;

		for scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadLengthSamples(vector, scenario);
			figname = ['std for ' distribution ', ' vector ', ' scenario];
            fig = figure('Name', figname);
            
            for repetition = 1 : min(numPlots, samples.size)
               hold on
               plotLengthStdDev(samples.(['v' string(repetition).char ]));
            end
            hold off
        
            warning('off', 'all');
                mkdir std;
            warning('on', 'all');
            cd std
                print(fig, [ figname '.png' ] , '-dpng');
                savefig(fig, [figname '.fig']);
            cd ..
        end        
	end
    
	for vectorIdx = 1 : length(timeVectors)
		vector = timeVectors(vectorIdx).char;

		for scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadTimeSamples(vector, scenario);
			figname = ['std for ' distribution ', ' vector ', ' scenario];
            fig = figure('Name', figname);
            
            for repetition = 1 : min(numPlots, samples.size)
               hold on
               plotTimeStdDev(samples.(['v' string(repetition).char ]));
            end
            hold off
            
            startcd = cd;
            foldername = fullfile('graphs', 'std');

            warning('off', 'all');
            mkdir(foldername);
            warning('on', 'all');
            cd(foldername)
                print(fig, [ figname '.png' ] , '-dpng');
                savefig(fig, [figname '.fig']);
            cd(startcd)
		end
    end

    cd ..
end
