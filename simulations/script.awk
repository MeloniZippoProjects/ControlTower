/vector \d+/ {
	vector_name = $3 "_" $4
	vectors[$2][1] = vector_name
}

/^(\d)/
{
	print $0
}