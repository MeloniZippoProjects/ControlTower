BEGIN {
	SUBSEP = "_"
	output_matlab = pattern ".m"
	#output_csv = out ".csv"
	print "vectors = struct();" > output_matlab
	size = 0
	#print "run number; stat name; time->values" >output_csv
}

$0 ~ pattern {
	print $0 > output_matlab
	size++
}

END {
	print "vectors.size = " size ";" > output_matlab
}
