#!/bin/bash

#awk '{print "--name="$2" --hostname="$2" test"}' ip_hostnames
#awk '{sudo ./pipework docker0 $2 $1}' ip_hostnames
rm -f scripts/hosts
image=$1
create_containers_from(){
 while IFS= read -r name
do
docker run -d -m 1g --name="$name" --hostname="$name" $image
done <$1
sh showHosts.sh $1 >> scripts/hosts

}
#create slave containers
create_containers_from conf/hadoop_spark_slaves
#create namenode containers
create_containers_from conf/hadoop/masters

wd=`pwd`
docker run -it -m 1g -v $wd/data:/root/data -v $wd/scripts:/root/scripts -p 8080:8080 --name=client --hostname=client $image /bin/bash
