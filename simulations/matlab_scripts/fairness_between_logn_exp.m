lognorm_pd = makedist('Weibull', 'a', 200, 'b', 10);

exp_mu = lognorm_pd.mean;

exp_pd = makedist('Exponential', 'mu', exp_mu);

figure();
hold on;
plot([0 1], [0 1]);

sample_size = 10000;
logn_sample = zeros(1, sample_size);
exp_sample = zeros(1, sample_size);

for idx = 1 : sample_size
    logn_sample(idx) = random(lognorm_pd);
    exp_sample(idx) = random(exp_pd);
end

sort_logn_sample = sort(logn_sample);
sort_exp_sample = sort(exp_sample);

T_logn = sum(logn_sample);
T_exp = sum(exp_sample);

x = 1/sample_size : 1/sample_size : 1;
y_logn = zeros(1,sample_size);
y_exp = zeros(1,sample_size);

for idx = 1 : sample_size
    y_logn(idx) = sum(sort_logn_sample(1:idx));
    y_exp(idx) = sum(sort_exp_sample(1:idx));
end

y_logn = y_logn / T_logn;
y_exp = y_exp / T_exp;

plot(x, y_logn, 'DisplayName', 'lognormal');
plot(x, y_exp, 'DisplayName', 'exp');

legend('show');