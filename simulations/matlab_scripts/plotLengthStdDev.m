function [] = plotLengthStdDev( sample )
	y = [];
	for idx = 10 : size(sample)
		y = [y , std(sample(1 : idx, 1), sample(1 : idx, 2))];
    end

	plot(10 : size(sample), y);
end