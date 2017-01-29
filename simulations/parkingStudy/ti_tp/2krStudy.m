distributions = [string('exponential'); string('lognormal');] ;
scenarios = [string('i15p60'); string('i15p30'); string('i30p60'); string('i30p30');];
combination_matrix = [-1 1; -1 -1; 1 1; 1 -1];

vector = 'parkingLot_parkingOccupancy';
alfa = 0.05;

load('parking0.9Quantiles.mat');
    
    
for distIdx = 1 : length(distributions)
   dist = distributions(distIdx).char; 
   cd(dist);

   qs = struct;
   SSx = struct;
   SSE = struct;
   fx = struct;
   CI = struct;
   std_devs = struct;

   measures = [];
   parfor scenIdx = 1 : length(scenarios)
       scenario = scenarios(scenIdx).char;

       q = quantiles.( [ 'quantiles', '_', dist, '_', scenario ]);
       q = log(q);           
       measures = [measures; q];
   end

   graph_name = dist;

   f = dist;
   [ qs.(f), SSx.(f), SSE.(f), fx.(f), CI.(f), std_devs.(f) ] = analysis_2kr(combination_matrix, measures, alfa, graph_name);
   save( 'parking2kr.mat', 'qs', 'SSx', 'SSE', 'fx', 'CI', 'std_devs' );
   cd ..
end