% Preparses every vector and creates a .mat file.
% Subsequent calls to loadLengthSamples and loadTimeSamples are much faster
% since they don't have to parse the .m text file.

distributions = [ string('exponential'); string('lognormal') ];
scenarios = [   string('rho0.1'); string('rho0.15'); string('rho0.2'); string('rho0.25'); string('rho0.3'); string('rho0.35'); string('rho0.4'); string('rho0.45'); string('rho0.5');
                string('rho0.55'); string('rho0.6'); string('rho0.65'); string('rho0.7'); string('rho0.75'); string('rho0.8'); string('rho0.85'); string('rho0.9')];

timeVectors = [ string('takeoffQueue_queueTime') ; string('landingQueue_queueTime') ];
lengthVectors = [ string('takeoffQueue_queueLength') ; string('landingQueue_queueLength') ];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);

    for vectorIdx = 1 : size(lengthVectors, 1)
		vector = lengthVectors(vectorIdx).char;

		parfor scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);
            samples = loadLengthSamples(vector, scenario);
        end
	end

	for vectorIdx = 1 : size(timeVectors, 1)
		vector = timeVectors(vectorIdx).char;

		parfor scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);
            samples = loadTimeSamples(vector, scenario);
        end
    end

    cd ..
end