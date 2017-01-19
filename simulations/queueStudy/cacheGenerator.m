distributions = [ string('deterministic'); string('exponential'); string('normal') ];
scenarios = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
timeVectors = [ 'takeoffQueue_queueTime' ; 'landingQueue_queueTime' ];
lengthVectors = [ 'takeoffQueue_queueLength' ; 'landingQueue_queueLength' ];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);

    for vectorIdx = 1 : size(lengthVectors, 1)
		vector = lengthVectors(vectorIdx, :);

		parfor scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);
            samples = loadLengthSamples(vector, scenario);
        end
	end

	for vectorIdx = 1 : size(timeVectors, 1)
		vector = timeVectors(vectorIdx, :);

		parfor scenIdx = 1 : length(scenarios)
			scenario = scenarios(scenIdx, :);
            samples = loadTimeSamples(vector, scenario);
        end
    end

    cd ..
end