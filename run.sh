#!/bin/bash

#awk '{print "--name="$2" --hostname="$2" test"}' ip_hostnames
#awk '{sudo ./pipework docker0 $2 $1}' ip_hostnames
image=$1
 while IFS= read -r name
do 
docker run -d --name="$name" --hostname="$name" $image
done <machine_names
sh showHosts.sh > hosts_cmds/hosts
docker run -it -v /Users/mark/Git/Bitbucket/hadoop_cluster_module/data:/root/data -v /Users/mark/Git/Bitbucket/hadoop_cluster_module/hosts_cmds:/root/hosts_cmds --name=client --hostname=client $image /bin/bash
