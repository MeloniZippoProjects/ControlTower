function [] = computePDF(config, rho, pdffig)
	tot_sample = extractTotSample(config, rho);
	subsmpl = subsample(tot_sample, ceil(log2(length(tot_sample)) - ceil( 10 - str2double(rho)*5)));

	figure('Name', strcat('Autocorr for ', string(rho).char));
	autocorr(subsmpl);

	figure(pdffig);
	hold on;
	histogram(subsmpl, 'DisplayStyle', 'stairs', 'FaceAlpha', 0.7, 'Normalization','probability');
end