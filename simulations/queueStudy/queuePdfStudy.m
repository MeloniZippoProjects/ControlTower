distributions = [ string('deterministic') ]; % [ string('exponential'); string('normal'); string('lognormal')];
timeVectors = [string('landingQueue_queueTime') 5; string('takeoffQueue_queueTime') 20; ];
lengthVectors = [ string('landingQueue_queueLength'); string('takeoffQueue_queueLength')];
scenarios = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
min = string('minutes');
s = string('seconds');
timeWidths = [ 4 min; 4 min; 4 min; 4 min; 4 min; 4 min; 4 min; 4 min; 4 min ];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);
    
    for vectorIdx = 1 : length(lengthVectors)
		vector = lengthVectors(vectorIdx).char;
        
		parfor scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadLengthSamples(vector, scenario);
            figname = ['pdf for ' distribution ', ' vector ', ' scenario];
            fig = figure('Name', figname);
			plotLengthPDF( samples );
            
            startcd = cd;
            foldername = fullfile('graphs', 'pdf', 'queueLengths');
            warning('off', 'all');
                mkdir(foldername);
            warning('on', 'all');
            cd(foldername)
                print(fig, [ figname '.png' ] , '-dpng');
                savefig(fig, [figname '.fig']);
            cd(startcd)
		end

		% print(pdffig, vector, '-dpng');
	end

	for vectorIdx = 1 : length(timeVectors)
		vector = timeVectors(vectorIdx).char;
		width =  str2double( timeVectors(vectorIdx, 2).char );

		parfor scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadTimeSamples(vector, scenario);
            figname = ['pdf for ' distribution ', ' vector ', ' scenario];
            fig = figure('Name', figname);
			plotTimePDF( samples, timeWidths(scenIdx, :) );
            
            startcd = cd;
            foldername = fullfile('graphs', 'pdf', 'queueWaitingTimes');
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