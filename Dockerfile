FROM centos:centos6.6
ENV http_proxy http://10.57.35.31:8080
RUN yum -y update
RUN yum -y install wget vim openssh-server openssh-clients tar
##Oracle JAVA 8
# download jdk
RUN wget -O "/var/tmp/jdk-8u40-linux-x64.rpm" --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" --no-verbose http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.rpm
# install jdk
RUN rpm -ivh /var/tmp/jdk-8u40-linux-x64.rpm

#SSH
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa1 -P '' -f /etc/ssh/ssh_host_rsa_key

RUN ssh-keygen -t dsa -P '' -f /etc/ssh/ssh_host_dsa_key 
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# HADOOP
ENV HADOOP_VERSION 2.6.0
ENV HADOOP_PKG_NAME hadoop-$HADOOP_VERSION
ENV HADOOP_HOME /usr/local/hadoop$HADOOP_VERSION
RUN wget http://www.eu.apache.org/dist/hadoop/common/$HADOOP_PKG_NAME/$HADOOP_PKG_NAME.tar.gz && tar xvzf $HADOOP_PKG_NAME.tar.gz && rm -f $HADOOP_PKG_NAME.tar.gz && mv $HADOOP_PKG_NAME $HADOOP_HOME

ADD HadoopConf/core-site.xml       $HADOOP_HOME/etc/hadoop/core-site.xml
ADD HadoopConf/hadoop-env.sh       $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD HadoopConf/hdfs-site.xml       $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD HadoopConf/mapred-env.sh       $HADOOP_HOME/etc/hadoop/mapred-env.sh
ADD HadoopConf/mapred-site.xml 	   $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD HadoopConf/yarn-site.xml       $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD HadoopConf/slaves		   $HADOOP_HOME/etc/hadoop/slaves
ADD HadoopConf/masters     	   $HADOOP_HOME/etc/hadoop/masters
#ADD ip_hostnames       /root/ip_hostnames
#ADD setHosts.sh     /etc/profile.d/setHosts.sh
ADD setENV.sh      /etc/profile.d/setENV.sh

#SPARK
ENV SPARK_VERSION 1.4.0
ENV SPARK_PKG_NAME spark-$SPARK_VERSION-bin-hadoop2.6
ENV SPARK_HOME /usr/local/spark$SPARK_VERSION 
RUN wget http://d3kbcqa49mib13.cloudfront.net/$SPARK_PKG_NAME.tgz && tar zxvf $SPARK_PKG_NAME.tgz && rm -rf $SPARK_PKG_NAME.tgz && mv $SPARK_PKG_NAME $SPARK_HOME
ADD spark_conf/slaves		$SPARK_HOME/conf/slaves
ADD spark_conf/spark-env.sh	$SPARK_HOME/conf/spark-env.sh


CMD ["/usr/sbin/sshd", "-D"]
