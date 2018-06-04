#!/bin/bash
if [[ ! $1 ]]; then
	echo please provide filename; exit 1
fi

if [[ ! $1 = $@ ]]; then
	echo please do not use spaces; exit 2
fi
if [[ -e "$1" ]]; then
 	echo File already exists
else
	touch "$1"
	chmod u+x "$1"
	if [[ $? ]]; then
		echo "$1 successfully created"
		ls -latr "$1"
		rm "$1"
	else
		echo failed to create file
	fi
fi
exit 0