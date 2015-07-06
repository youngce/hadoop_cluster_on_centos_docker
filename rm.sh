#!/bin/bash
while IFS= read -r name
do 
docker rm -f $name

done <machine_names
docker rm -f client
