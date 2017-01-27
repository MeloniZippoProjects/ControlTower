distributions = [ string('exponential'); string('normal'); string('lognormal')]; %string('deterministic');
responseVector = 'wg_responseTime';
scenarios = ['rho0.1'; 'rho0.2'; 'rho0.3'; 'rho0.4'; 'rho0.5'; 'rho0.6'; 'rho0.7'; 'rho0.8'; 'rho0.9'];
min = string('minutes');
s = string('seconds');
timeWidth = [3 min];

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;
    cd(distribution);
           
    %pdfs of parking interarrival and interleaving times
        
    parfor scenIdx = 1 : length(scenarios)
        scenario = scenarios(scenIdx, :);
        
        samples = loadIntertimesSamples(responseVector, scenario);
                
        figname = ['pdf of takeoff inter-leavings for ' distribution ', ' responseVector ', ' scenario];
        fig = figure('Name', figname);
        plotTimePDF( samples, timeWidth );

        startcd = cd;
        foldername = fullfile('graphs', 'pdf', 'takeoffInterleavings');
        warning('off', 'all');
            mkdir(foldername);
        warning('on', 'all');
        cd(foldername)
            print(fig, [ figname '.png' ] , '-dpng');
            savefig(fig, [figname '.fig']);
        cd(startcd)
    end
            
    cd ..
end