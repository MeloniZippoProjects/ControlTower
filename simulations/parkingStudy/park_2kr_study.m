rhos = ['rho0.2'; 'rho0.7'];
distributions = [string('exponential'); string('normal'); string('deterministic')];
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30')];
combination_matrix = [1 1; 1 -1; -1 1; -1 -1];
vector = 'parkingLot_parkingOccupancy';
alfa = 0.05;

load('parking0.9Quantiles.mat');
qs = struct;
SSx = struct;
SSE = struct;
fx = struct;
CI = struct;
std_devs = struct;

for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);
    rho_d = str2double(rho( (length(rho) - 2) : length(rho)));
    
    for distIdx = 1 : length(distributions)
       dist = distributions(distIdx).char; 
       cd(dist);
       
       measures = [];
       for scenIdx = 1 : length(scenarios)
           scenario = scenarios(scenIdx).char;
           
           q = quantiles.( [ 'quantiles', '_', strrep(rho, '.', '') , '_', dist, '_', scenario ]);
           q = log(q);           
           measures = [measures; q];
       end
       
       graph_name = [ rho ' ' dist];
       
       f = [ strrep(rho, '.', '') '_' dist ];
       [ qs.(f), SSx.(f), SSE.(f), fx.(f), CI.(f), std_devs.(f) ] = factorial2kr(combination_matrix, measures, alfa, graph_name);
       
       cd ..
    end
    cd ..
end

save( 'parking2kr.mat', 'qs', 'SSx', 'SSE', 'fx', 'CI', 'std_devs' );