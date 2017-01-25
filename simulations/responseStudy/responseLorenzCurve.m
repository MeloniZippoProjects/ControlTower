rhos = [string('rho0.2'); string('rho0.7')];
distributions = [string('normal'); string('lognormal')];
scenarios = [ string('l5t5p30'); string('l5t5p60'); string('l5t15p30');
	string('l5t15p60');  string('l15t5p30'); string('l15t5p60');
	string('l15t15p30'); string('l15t15p60'); ];

vector = 'wg_responseTime';

alfa = 0.05;


for rhoIdx = 1 : size(rhos,1)
	rho = rhos(rhoIdx).char;
	cd(rho);
    
    for distIdx = 1 : length(distributions)
        distribution = distributions(distIdx, :).char;
        cd(distribution);

        warning('off','all');
            mkdir lorenz_curves;
        warning('on','all');


        for idx = 1 : length(scenarios)

            scenario = scenarios(idx,:).char;
            figname = [ 'Lorenz Curve for ' rho ', normal, ' scenario ];

            fig = figure('Name', figname);

            plotLorenzCurve(scenario, vector, alfa);


            cd lorenz_curves
                print(fig, [figname '.png'], '-dpng');
                savefig(fig, [figname '.fig']);
            cd ..
        end

        cd ..
    end
        
    cd ..
end
