BEGIN {
	SUBSEP = "_"
	i = 0
	output_matlab = out ".m"
	output_csv = out ".csv"
	print "vectors = struct();" > output_matlab
	size = 0
	vector_name_count = 0
	
	print "run number; stat name; time->values" > output_csv

	print "Gawk:\tInitialization complete"
}

/attr runnumber/ {
	run_number = $3
	if(run_number > size)
		size = run_number

	print "Gawk:\tProcessing vec # " run_number
}

/vector [0-7]/ {
	fields = split($3, splitted, ".")
	vector_module = splitted[fields]
	fields = split($4, subs, ":")
	vector_stat = subs[1]
	
	#matlab vectors
	vector_name = "vectors." vector_module "_" vector_stat "_" run_number
	vectors[run_number, $2] = vector_name " = ["
	
	#csv vectors
	vector_name_csv = run_number ";" vector_module "_" vector_stat ";"
	vectors_time_csv[run_number, $2] = vector_name_csv "time;"
	vectors_data_csv[run_number, $2] = ";;values;"
}

$1 ~ /[0-7]/ {
	vectors[run_number, $1] = vectors[run_number, $1] $3 " " $4 ";"
	vectors_time_csv[run_number, $1] = vectors_time_csv[run_number, $1] $3 "; "
	vectors_data_csv[run_number, $1] = vectors_data_csv[run_number, $1] $4 "; " 
}

END {
	print "Gawk:\tProcessing ended, starting print to file"

	for(j in vectors)
	{	
		vectors[j] = vectors[j] "]"
		print vectors[j] ";" > output_matlab
	}

	print "vectors.size = " size+1 ";" > output_matlab

	print "Gawk:\tMatlab file completed"
	
	for(j in vectors_time_csv)
	{
		vectors_time_csv[j] = vectors_time_csv[j] ";"
		vectors_data_csv[j] = vectors_data_csv[j] ";"
		print vectors_time_csv[j] > output_csv
		print vectors_data_csv[j] > output_csv
		print "\n" > output_csv
	}

	print "Gawk:\tcsv file completed"
}