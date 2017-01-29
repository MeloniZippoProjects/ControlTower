distributions = [ string('exponential'); string('lognormal') ];
scenarios = [string('i15p60'); string('i15p30'); string('i30p60'); string('i30p30');];

vector = 'parkingLot_parkingOccupancy';

for distIdx = 1 : size(distributions, 1)
    dist = distributions(distIdx).char; 
    cd(dist);

    parfor scenIdx = 1 : length(scenarios)
        scenario = scenarios(scenIdx, :);
        samples = loadLengthSamples(vector, scenario);
    end

    cd ..
end