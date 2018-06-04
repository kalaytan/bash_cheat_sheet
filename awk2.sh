{for (i=1;i<NF;i++)
	one+=$1
	two+=$2
	three+=$3}
END{
	echo sum $one $two $three
}