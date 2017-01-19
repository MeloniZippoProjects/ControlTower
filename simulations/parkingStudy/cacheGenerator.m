rhos = ['rho0.2'; 'rho0.7'];
distributions = [string('deterministic'); string('exponential'); string('normal')];
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];
vector = 'parkingLot_parkingOccupancy';

for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);
    rho_d = str2double(rho( (length(rho) - 2) : length(rho)));
    
    for distIdx = 1 : size(distributions, 1)
        dist = distributions(distIdx).char; 
        cd(dist);
        parfor scenIdx = 1 : size(scenarios, 1)
            scenario = scenarios(scenIdx).char;
            samples = loadLengthSamples(vector, scenario);
        end
        cd ..
    end
    cd ..
end