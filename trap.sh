#trap "" INT
trap "echo cought here; exit" INT
trap "" QUIT
trap "echo you can not quit now" QUIT
cd /
while
true
do
	echo looping
	du -m * 2>/dev/null
	echo sleeping
	sleep 5
done