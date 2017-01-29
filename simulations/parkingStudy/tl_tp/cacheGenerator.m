distributions = [ string('exponential'); string('lognormal') ];
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];

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