rhos = ['rho0.2'; 'rho0.7'];
distributions = [string('normal'); string('lognormal')];
scenarios = [ string('l5t5p30'); string('l5t5p60'); string('l5t15p30');
        string('l5t15p60');  string('l15t5p30'); string('l15t5p60');
        string('l15t15p30'); string('l15t15p60'); ];
timeVectors = [ string('takeoffQueue_queueTime') ; string('landingQueue_queueTime'); string('wg_responseTime') ];
lengthVectors = [ string('takeoffQueue_queueLength') ; string('landingQueue_queueLength'); string('parkingLot_parkingOccupancy') ];


quantiles = struct();

for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);
    rho_d = str2double(rho( (length(rho) - 2) : length(rho)));
    
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
    cd ..
end
%{
for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);
    rho_d = str2double(rho( (length(rho) - 2) : length(rho)));
    
    for distIdx = 1 : size(distributions, 1)
        dist = distributions(distIdx).char; 
        cd(dist);
       
        parfor scenIdx = 1 : size(scenarios, 1)
            scenario = scenarios(scenIdx).char;
            samples = loadTimeSamples(vector, scenario);
        end
        cd ..
    end
    cd ..
end
%}