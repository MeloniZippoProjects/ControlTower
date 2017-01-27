distributions = [string('exponential'); string('lognormal');] ;
scenarios = [string('i15p60'); string('i15p30'); string('i30p60'); string('i30p30');];
vector = 'parkingLot_parkingOccupancy';
p = 0.90; %percentuale dei quantili calcolati

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
       field = [ 'quantiles','_', dist, '_', scenario ];
       quantiles.( field ) = q;

   end
   cd ..
end
save( ['parking' string(p).char 'Quantiles.mat'], 'quantiles');