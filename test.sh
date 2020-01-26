#!/bin/bash

OLDIFSS=$IFS
IFS=","

while read programs
 do
	 apt-get install -y $programs >/dev/null 2>&1
done < progs.csv
IFS=$OLDIFS
