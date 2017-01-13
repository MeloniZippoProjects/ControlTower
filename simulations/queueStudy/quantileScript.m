config = 'takeoffQueue_queueTime';
rhos = ['0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'];
p = 0.90;
alfa = 0.10; %(1-alfa) è il livello di confidenza
rng(7817, 'twister');

%calcolo autocorrelazione del subsample e il quantile per ogni rho
for i = 1:length(rhos)
    rho = rhos(i,:);
    tot_sample = extractTotSample(config, rho);
    subsmpl = subsample(tot_sample, ceil(log2(length(tot_sample)) - ceil( 12 - str2double(rho)*6 )));
    
    %subsmpl = subsmpl / 60;
    
    fig_label = ['Autocorr for ', config, ' ', string(rho).char]; 
	figure('Name', fig_label);
	autocorr(subsmpl);
    
    [q(i), q_lb(i), q_ub(i)] = computeQuantile(subsmpl,p,alfa);
end
q_neg = q - q_lb;
q_pos = q_ub - q;

rhoes = [0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9];
errorbar(rhoes,q,q_neg,q_pos);