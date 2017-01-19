rhos = ['rho0.2'; 'rho0.7'];
distributions = [ string('exponential'); string('normal')]; %string('deterministic');
vector = 'parkingLot_parkingOccupancy';
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];

for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);

    for distIdx = 1 : length(distributions)
        distribution = distributions(distIdx, :).char;
        cd(distribution);

        	parfor scenIdx = 1 : length(scenarios)
    			scenario = scenarios(scenIdx).char;

                %Parking occupation study
    			samples = loadLengthSamples(vector, scenario);
                figname = ['pdf for parking occupancy ' rho ', ' distribution ', ' vector ', ' scenario];
                fig = figure('Name', figname);
    			plotLengthPDF( samples );
                
                startcd = cd;
                foldername = fullfile('graphs', 'pdf');

                warning('off', 'all');
                    mkdir(foldername);
                warning('on', 'all');
                cd(foldername);
                    print(fig, [ figname '.png' ] , '-dpng');
                    savefig(fig, [figname '.fig']);
                cd(startcd);
                

    		end
        cd ..
    end
    cd ..
end