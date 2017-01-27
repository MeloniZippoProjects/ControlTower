rhos = ['rho0.2'; 'rho0.7'];
distributions = [string('exponential'); string('lognormal');] ; % string('deterministic'); ] ; %string('normal'); string('lognormal'); string('lognormal'); string('deterministic')];
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];
vector = 'parkingLot_parkingOccupancy';
p = 0.90; %percentuale dei quantili calcolati



for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);
    clear quantiles;
    quantiles = struct();
    
    for distIdx = 1 : size(distributions, 1)
       dist = distributions(distIdx).char; 
       cd(dist);
       
       for scenIdx = 1 : size(scenarios, 1)
           scenario = scenarios(scenIdx).char;
           samples = loadLengthSamples(vector, scenario);
           
           q = zeros(1,samples.size);
           for rep = 1 : samples.size
              sample = samples.(['v' string(rep).char]);
              mergedSample = mergeSortLengthSample(sample);
              
              q(rep) = computeWeightedQuantile(mergedSample, p);
           end
           
           %da testare
           field = [ 'quantiles', '_', strrep(rho, '.', '') , '_', dist, '_', scenario ];
           quantiles.( field ) = q;
           
       end
       cd ..
    end
    save( ['parking' string(p).char 'Quantiles.mat'], 'quantiles');
    cd ..
end
