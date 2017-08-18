# utility to parse all *.vec files from all repetitions of a factor set
# to a .m file for matlab scripting and a .csv file for excel
# The .m file begins with vectors = struct(). Each line of the file is a new field for vectors
# The format of a line in the .m file is moduleName_vectorName_runNumber = [ time1 val1; time2 val2; ... ];
# I.E. to access the queue waiting time of landing queue of the 5th repetition: vectors.landingQueue_queueTime_5
# vectors has a last field, vectors.size, that counts how many repetitions were found in .vec files.
#
# The format of .csv file is 2 rows for every vector, one for time and one for values.
# The first row of the file is the header: run number, vector name, begin of time->value pairs
# Each row below is aligned to the header
#
# Keep in mind that rows are not sorted by any mean
# the order depends on how gawk implementation keeps values in 
# its map arrays. Note that this does not create any problem with matlab.


#prepare files and variables initialization.
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

# starting to parse a new repetition. 
/attr runnumber/ {
	run_number = $3
	if(run_number > size)
		size = run_number

	print "Gawk:\tProcessing vec # " run_number
}

# parse vector names
/vector [0-9]+/ {
	fields = split($3, splitted, ".")
	vector_module = splitted[fields]
	fields = split($4, subs, ":")
	vector_stat = subs[1]
	
	# matlab vectors
	vector_name = "vectors." vector_module "_" vector_stat "_" run_number
	vectors[run_number, $2] = vector_name " = ["
	
	# csv vectors
	vector_name_csv = run_number ";" vector_module "_" vector_stat ";"
	vectors_time_csv[run_number, $2] = vector_name_csv "time;"
	vectors_data_csv[run_number, $2] = ";;values;"
}

# each line in .vec file is formatted like NETV, where 
# N is the vector ID
# E is event number (ignored by the script)
# T is time at which event was fired
# V is the assigned value
$1 ~ /[0-9]+/ {
	vectors[run_number, $1] = vectors[run_number, $1] $3 " " $4 ";"
	vectors_time_csv[run_number, $1] = vectors_time_csv[run_number, $1] $3 "; "
	vectors_data_csv[run_number, $1] = vectors_data_csv[run_number, $1] $4 "; " 
}

# at the end of file parsing, every vector is printed.
END {
	print "Gawk:\tProcessing ended, starting print to file"

	for(j in vectors)
	{	
		vectors[j] = vectors[j] "]"
		print vectors[j] ";" > output_matlab
	}

	# vectors.size = size+1 because matlab counts from 1 to N, .vec are from 0 to N-1 
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