#!/bin/bash

#awk '{print "--name="$2" --hostname="$2" test"}' ip_hostnames
#awk '{sudo ./pipework docker0 $2 $1}' ip_hostnames
image=$1
 while IFS= read -r line
do 
ip=$( echo $line|cut -d' ' -f1)
hostname=$( echo $line|cut -d' ' -f2)
docker run -d --name="$hostname" --hostname="$hostname" $image
#sudo ./pipework docker0 $hostname $ip/24


done <ip_hostnames

docker run -it --name=client --hostname=client $image /bin/bash
