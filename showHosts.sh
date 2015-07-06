#!/bin/bash
IFS=''
while read name
do
echo $(docker inspect $name | grep IPAddress|awk -F':' '{print $2}' |sed 's/"//g'|sed 's/,//g') $name
done <machine_names
