% Draws an histogram for each vector and each factor set. The bucket width is estimated making an hypothesis 
% on the distribution of the sample. It's not a blind hypothesis, as qqFittingStudy can be used 
% to have an idea on the distribution. 
% An histogram is made using a sample from a theoretical distribution with parameters
% equal to MLEs computed from the sample.
% Its bucket size is then used for the histogram of the sample. The histogram from the
% theoretical distribution is drawn as a reference. If the sample can be
% fitted to the theoretical distribution, the histogram bars will be almost equal to the
% reference bars.

distributions = [ string('exponential'); string('lognormal')];
timeVectors = [string('landingQueue_queueTime') 5; string('takeoffQueue_queueTime') 20; ];
lengthVectors = [ string('landingQueue_queueLength'); string('takeoffQueue_queueLength')];
scenarios = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
%fittings = [string('exponential'); string('normal'); string('lognormal'); string('uniform') ];
fittings = [string('exponential'); string('uniform') ];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);
    
    for vectorIdx = 1 : length(lengthVectors)
		vector = lengthVectors(vectorIdx).char;

		for scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadTimeSamples(vector, scenario);
			
            for fittingIdx = 1 : length(fittings)
                fitting = fittings(fittingIdx);
                figname = ['pdf for ' distribution ' fitting with ' fitting.char ', ' vector ', ' scenario];
                fig = figure('Name', figname);

                plotLengthPDFWithFitting( samples, fitting );

                startcd = cd;
                foldername = fullfile('graphs', 'pdf_with_fitting', fitting.char , 'queueLength');
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
    %{
	for vectorIdx = 1 : length(timeVectors)
		vector = timeVectors(vectorIdx).char;

		for scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);

			samples = loadTimeSamples(vector, scenario);
            samples_no0 = removeZeros(samples);
			
            parfor fittingIdx = 1 : length(fittings)
                fitting = fittings(fittingIdx);
                disp(strcat(string('Processing: '),fitting,string(' fitting for '), distribution, string(', '), scenario));

                figname = ['pdf for ' distribution ' fitting with ' fitting.char ', ' vector ', ' scenario];
                fig = figure('Name', figname);

                plotTimePDFWithFitting( samples_no0, fitting );

                startcd = cd;
                foldername = fullfile('graphs', 'pdf_with_fitting', fitting.char , 'queueWaitingTimes');
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
    cd ..
end