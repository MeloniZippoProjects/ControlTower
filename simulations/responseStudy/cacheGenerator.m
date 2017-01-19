rhos = ['rho0.2'; 'rho0.7'];
distributions = [string('normal')];
scenarios = [ string('l5t5p30'); string('l5t5p60'); string('l5t15p30');
        string('l5t15p60');  string('l15t5p30'); string('l15t5p60');
        string('l15t15p30'); string('l15t15p60'); ];
vector = 'wg_responseTime';

quantiles = struct();

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