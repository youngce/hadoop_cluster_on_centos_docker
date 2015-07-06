#!/bin/bash
while IFS= read -r line
do 
hostname=$( echo $line|cut -d' ' -f2)
docker rm -f $hostname

done <ip_hostnames
docker rm -f client
