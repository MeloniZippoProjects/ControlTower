function [] = plotTimeStdDev( sample )
	y = [];
	for idx = 10 : size(sample)
		y = [y, std(sample(1 : idx))];
	end

	plot(10 : size(sample), y);
end