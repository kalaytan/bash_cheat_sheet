#!/bin/bash
declare -i i=0
exec >logfile.log 2>error.log
while [[ true ]]; do
	echo "`date`: printing $((i++))"
	sleep 1
done