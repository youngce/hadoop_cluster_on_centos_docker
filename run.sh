#!/bin/bash

#awk '{print "--name="$2" --hostname="$2" test"}' ip_hostnames
#awk '{sudo ./pipework docker0 $2 $1}' ip_hostnames
rm -f scripts/hosts
image=$1
create_containers_from(){
 while IFS= read -r name
do
docker run -d -m 1g --name="$name" --hostname="$name" $image  
cp_hosts $name
done <$1
}
cp_hosts(){
	
	container_name=$1
	echo $(docker inspect $container_name | grep '"IPAddress"'|awk -F':' '{print $2}' |sed 's/"//g'|sed 's/,//g') $container_name >> scripts/hosts
}

#create slave containers
create_containers_from conf/hadoop_spark_slaves
#create namenode containers
create_containers_from conf/hadoop/masters
docker run -d -m 1g --name=master --hostname=master -p 8080:8080 -p 7077:7077 $image 
cp_hosts master
docker run -d -m 1g --name=zk1 --hostname=zk1 jplock/zookeeper 
cp_hosts zk1

wd=`pwd`
docker run -it -v $wd/data:/root/data -v $wd/scripts:/root/scripts --name=client --hostname=client $image /bin/bash
