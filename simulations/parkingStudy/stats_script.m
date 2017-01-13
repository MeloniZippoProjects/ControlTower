rhos = ['rho0.2'; 'rho0.7'];
configs = [string('poissonian');string('normal')];
factors = [string('l5p30');string('l5p60');string('l15p30');string('l15p60')];
for idx = 1:size(rhos)
    rho = rhos(idx,:);
    for jdx = 1:size(configs)
        config = configs(jdx,:).char;
        for kdx = 1:size(factors)
            factor = factors(kdx,:).char;
            cd(strcat(rho,'/',config,'/',factor,'/results'));
            
            show_stats(rho, config, factor)
            
            cd '../../../..';
        end
    end
    
end