% Makes an histogram separating the first 5 minutes and fitting them to a uniform, 
% from everything else, that is fitted to exponential

distributions = [ string('lognormal')];
timeVectors = [string('landingQueue_queueTime') 5; string('takeoffQueue_queueTime') 20; ];
%lengthVectors = [ string('landingQueue_queueLength'); string('takeoffQueue_queueLength')];
scenarios = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
fittingDivisor = 5*60;

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    
	for vectorIdx = 1 : length(timeVectors)
		vector = timeVectors(vectorIdx).char;
		width =  str2double( timeVectors(vectorIdx, 2).char );

		for scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadTimeSamples(vector, scenario);
            samples_no0 = removeZeros(samples);
            
            [uniform_samples, exp_samples] = divideSamples(samples_no0, fittingDivisor);
            
            
			
            figname = ['pdf for ' distribution ' from 0 to ' string(fittingDivisor).char ', fitting with uniform, ' vector ', ' scenario];
            fig = figure('Name', figname);

            plotTimePDFWithFitting( uniform_samples, string('uniform') );

            startcd = cd;
            foldername = fullfile('graphs', 'pdf_with_fitting', 'uniform_exp' , 'queueWaitingTimes');
            warning('off', 'all');
                mkdir(foldername);
            warning('on', 'all');
            cd(foldername)
                print(fig, [ figname '.png' ] , '-dpng');
                savefig(fig, [figname '.fig']);
            cd(startcd)
            
            figname = ['pdf for ' distribution ' from ' string(fittingDivisor).char ' to end, fitting with exp, ' vector ', ' scenario];
            fig = figure('Name', figname);

            plotTimePDFWithFitting( subtractFromSamples(exp_samples, fittingDivisor ), string('exponential') );

            startcd = cd;
            foldername = fullfile('graphs', 'pdf_with_fitting', 'uniform_exp' , 'queueWaitingTimes');
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