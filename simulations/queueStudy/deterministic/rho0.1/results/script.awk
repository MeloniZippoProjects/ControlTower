BEGIN {
	SUBSEP = "_"
	i = 0
}

/vector [0-7]/ {
	vector_name = $3 "_" $4
	vectors[$2,"name"] = vector_name
}

$1 ~ /[0-7]/ {
	vectors[$1,"data",$3] = $4
	if($1 == 0)
		print $0
}

END {
	for(i in vectors)
		print i " = " vectors[i]
}