#!/bin/bash
rm_containers_from(){
while IFS= read -r name
do
docker rm -f $name

done <$1
}

rm_containers_from conf/hadoop_spark_slaves
rm_containers_from conf/hadoop/masters
docker rm -f client
