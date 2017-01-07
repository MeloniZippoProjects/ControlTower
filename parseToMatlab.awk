BEGIN {
	SUBSEP = "_"
	i = 0
	output_file = out
	print "vectors = struct();" > output_file
	size = 0
}

/attr runnumber/ {
	run_number = $3
	if(run_number > size)
		size = run_number
}

/vector [0-7]/ {
	fields = split($3, splitted, ".")
	#print splitted[fields]
	vector_module = splitted[fields]
	fields = split($4, subs, ":")
	vector_stat = subs[1]
	vector_name = "vectors." vector_module "_" vector_stat "_" run_number
	vectors[run_number, $2] = vector_name " = ["
}

$1 ~ /[0-7]/ {
	vectors[run_number, $1] = vectors[run_number, $1] $3 " " $4 ";"
}

END {
	for(j in vectors)
	{	
		vectors[j] = vectors[j] "]"
		print vectors[j] ";" > output_file
	}
	
	print "vectors.size = " size+1 ";" > output_file
}