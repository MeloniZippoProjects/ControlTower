config = 'takeoffQueue_queueTime';
rhos = ['0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'];
pdffig = figure('Name',strcat(config, 'pdfs'));

rng(17, 'twister');

subsamples = struct();

for idx = 1 : length(rhos)
	subsamples.(strcat('rho',string(idx).char)) = computePDF(config, rhos(idx, :), pdffig);	
end

figure(pdffig);
legend('show');