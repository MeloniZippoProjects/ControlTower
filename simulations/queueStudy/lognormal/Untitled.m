min_n = inf;
for i = 1 : samples.size
   tmp_sample = samples.(['v' string(i).char]);
   tmp_sample_no0 = tmp_sample( ~ (sample == 0) );
   min_n = min( min_n, length(tmp_sample_no0) );
end

sample_mat = zeros(samples.size, min_n);

for i = 1 : samples.size
    tmp_smpl = samples.(['v' string(i).char]);
    tmp_smpl = tmp_smpl( ~(sample == 0) );
    sample_mat(1, :) = tmp_smpl(1 : min_n);
end

sample = mean(sample_mat);

histfit(sample, [], 'Exponential');