rhos = ['rho0.2'; 'rho0.7'];
distributions = [string('normal'); string('lognormal')];
scenarios = [ string('l5t5p30'); string('l5t5p60'); string('l5t15p30');
        string('l5t15p60');  string('l15t5p30'); string('l15t5p60');
        string('l15t15p30'); string('l15t15p60'); ];
vector = 'wg_responseTime';
numPlots = 30;

for rhoIdx = 1 : size(rhos, 1)
    rho = rhos(rhoIdx, :);
    cd(rho);
    
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
            
            warning('off', 'all');
            mkdir std;
            warning('on', 'all');
            cd std
                print(fig, [ figname '.png' ] , '-dpng');
                savefig(fig, [figname '.fig']);
            cd ..
        end
      
        cd ..
    end
    
    cd ..
end
