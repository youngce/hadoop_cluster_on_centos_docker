#Proxy
export http_proxy="http://10.57.35.31:8080"
#HADOOP
export HADOOP_VERSION=2.6.0
export HADOOP_HOME=/usr/local/hadoop$HADOOP_VERSION 
#JAVA
export JAVA_VERSION=1.8.0_40
export JAVA_HOME="/usr/java/jdk$JAVA_VERSION"
#SPARK
export SPARK_VERSION=1.4.0
export SPARK_HOME=/usr/local/spark$SPARK_VERSION

export PATH="$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$SPARK_HOME/bin"
