% Calls plotLengthStdDev on every factor set, to check for variance finiteness

distributions = [ string('exponential'); string('lognormal') ];
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];

vector = 'parkingLot_parkingOccupancy';
numPlots = 30;

for distIdx = 1 : length(distributions)
    distribution = distributions(distIdx, :).char;

    cd(distribution);

    for scenIdx = 1 : length(scenarios)
        scenario = scenarios(scenIdx, :);

        samples = loadLengthSamples(vector, scenario);
        figname = ['std for ' rho ', ' distribution ', ' vector ', ' scenario.char];
        fig = figure('Name', figname);

        for repetition = 1 : min(numPlots, samples.size)
           hold on
           plotLengthStdDev(samples.(['v' string(repetition).char ]));
        end
        hold off
    
        startcd = cd;
        foldername = fullfile('graphs', 'std');
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