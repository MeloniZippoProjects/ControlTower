% Converts the data obtained via simulation to a format easier to work with.
% This format consists in a column vector with all the time duration values measured.

function [ converted_sample ] = convertTimeSample( original_sample )
	converted_sample = original_sample(:, 2);
end