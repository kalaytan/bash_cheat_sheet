#!/usr/bin/awk -f
{one=$1
two=$2
three+=$3
printf("in: %d %d %d\n", $1, $2, $3)
printf("sum %d %d %d\n", $one, $two, $three) 
printf("\n\n")
}
END{
	printf("sum %d %d %d\n", $one, $two, $three) 
}