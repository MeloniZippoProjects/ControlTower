# Script used to split the matlab files obtained by parseVector.awk into smaller files, one for each vector present in the initial file.
# These new files contain a single vector and have a smaller size than the initial one.
# This is done because loading all the vectors (even useless ones) in matlab is a waste of time and resources.

BEGIN {
	SUBSEP = "_"
	output_matlab = pattern ".m"
	print "vectors = struct();" > output_matlab
	size = 0
}

$0 ~ pattern {
	print $0 > output_matlab
	size++
}

END {
	print "vectors.size = " size ";" > output_matlab
}
