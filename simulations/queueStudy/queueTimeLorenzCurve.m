distributions = [string('lognormal');string('exponential')]; 


scenarios = [string('rho0.1'); string('rho0.2'); string('rho0.3');
    string('rho0.4'); string('rho0.5'); string('rho0.6'); string('rho0.7');
    string('rho0.8'); string('rho0.9')];

timeVectors = [string('takeoffQueue_queueTime'); string('landingQueue_queueTime')];

alfa = 0.05;


for distIdx = 1 : size(distributions,1)
	dist = distributions(distIdx).char;
	cd(dist);
	
    warning('off','all');
        mkdir lorenz_curves;
    warning('on','all');
    
    
	for scenIdx = 1 : length(scenarios)
		scenario = scenarios(scenIdx,:).char;
        parfor vecIdx = 1 : length(timeVectors)
            vector = timeVectors(vecIdx).char;
            figname = [ 'Lorenz Curve for ' dist '_' vector '_' scenario ];

            fig = figure('Name', figname); 
            plotLorenzCurve(scenario, vector, alfa);
            ylim([0 1]);

            startcd = cd;
            foldername = fullfile('graphs', 'lorenz_curves');
            warning('off', 'all');
                mkdir(foldername);
            warning('on', 'all');
            cd(foldername)
                print(fig, [ figname '.png' ] , '-dpng');
                savefig(fig, [figname '.fig']);
            cd(startcd)
        end
    end
    
	cd ..
end
