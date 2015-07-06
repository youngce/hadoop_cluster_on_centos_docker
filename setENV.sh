#Proxy
#export http_proxy="http://10.57.35.31:8080"
#HADOOP
export HADOOP_PREFIX=/usr/local/hadoop
export HADOOP_COMMON_HOME=/usr/local/hadoop
export HADOOP_HDFS_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=/usr/local/hadoop
export HADOOP_YARN_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_PKG_NAME=hadoop-2.6.0
#JAVA
export JAVA_HOME="/usr/java/jdk1.8.0_40"

export PATH="$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin"