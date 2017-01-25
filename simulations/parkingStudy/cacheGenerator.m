distributions = [ string('exponential'); string('lognormal') ];
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];
timeVectors = [ string('takeoffQueue_queueTime') ; string('landingQueue_queueTime'); string('wg_responseTime') ];
lengthVectors = [ string('takeoffQueue_queueLength') ; string('landingQueue_queueLength'); string('parkingLot_parkingOccupancy') ];

for distIdx = 1 : size(distributions, 1)
    dist = distributions(distIdx).char; 
    cd(dist);

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