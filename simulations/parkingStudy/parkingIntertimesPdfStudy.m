rhos = ['rho0.2'; 'rho0.7'];
distributions = [ string('exponential'); string('normal')]; %string('deterministic');
vector = 'parkingLot_parkingOccupancy';
scenarios = [string('l15p60'); string('l15p30'); string('l5p60'); string('l5p30');];
min = string('minutes');
s = string('seconds');
timeWidths = [15 min; 30 min];

for rhoIdx = 1 : size(rhos,1)
    rho = rhos(rhoIdx,:);
    cd(rho);

    for distIdx = 1 : length(distributions)
        distribution = distributions(distIdx, :).char;
        cd(distribution);

        	parfor scenIdx = 1 : length(scenarios)
    			scenario = scenarios(scenIdx).char;

                
                %Intertimes study
                samples = loadLengthSamples(vector, scenario);
                [arrivals, leavings] = loadParkingInterTimesSamples(samples);
                
                figname = ['pdf for interarrivals at park for ' rho ', ' distribution ', ' vector ', ' scenario];
                fig = figure('Name', figname);
                plotTimePDF( arrivals, timeWidths(rhoIdx, :));
                cd graphs/pdf
                    print(fig, [ figname '.png' ] , '-dpng');
                    savefig(fig, [figname '.fig']);
                cd ../..
                
                figname = ['pdf for interleavings at park for ' rho ', ' distribution ', ' vector ', ' scenario];
                fig = figure('Name', figname);
                plotTimePDF( leavings, timeWidths(rhoIdx, :));
                cd graphs/pdf
                    print(fig, [ figname '.png' ] , '-dpng');
                    savefig(fig, [figname '.fig']);
                cd ../..

    		end
        cd ..
    end
    cd ..
end