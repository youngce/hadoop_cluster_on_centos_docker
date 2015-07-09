FROM centos:centos6.6
ENV http_proxy http://10.57.35.31:8080
RUN yum -y update
RUN yum -y install wget vim openssh-server openssh-clients tar telnet
###Download&Install JAVA, HADOOP,and SPARK
##Oracle JAVA 8
# download jdk

RUN wget -O "/var/tmp/java.rpm" --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" --no-verbose http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm

#ADD javaXXX.rpm  /var/tmp/java.rpm
# install jdk
RUN rpm -ivh /var/tmp/java.rpm
# HADOOP
ENV HADOOP_VERSION 2.6.0
ENV HADOOP_PKG_NAME hadoop-$HADOOP_VERSION
ENV HADOOP_HOME /usr/local/hadoop
RUN wget http://www.eu.apache.org/dist/hadoop/common/$HADOOP_PKG_NAME/$HADOOP_PKG_NAME.tar.gz && tar xvzf $HADOOP_PKG_NAME.tar.gz && rm -f $HADOOP_PKG_NAME.tar.gz && mv $HADOOP_PKG_NAME $HADOOP_HOME
#SPARK
ENV SPARK_VERSION 1.4.0
ENV SPARK_PKG_NAME spark-$SPARK_VERSION-bin-hadoop2.6
ENV SPARK_HOME /usr/local/spark
RUN wget http://d3kbcqa49mib13.cloudfront.net/$SPARK_PKG_NAME.tgz && tar zxvf $SPARK_PKG_NAME.tgz && rm -rf $SPARK_PKG_NAME.tgz && mv $SPARK_PKG_NAME $SPARK_HOME

######
#SSH
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa1 -P '' -f /etc/ssh/ssh_host_rsa_key

RUN ssh-keygen -t dsa -P '' -f /etc/ssh/ssh_host_dsa_key 
RUN ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && sed -i "s/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/" /etc/ssh/ssh_config 

# HADOOP CONFIG

ADD conf/hadoop/core-site.xml       $HADOOP_HOME/etc/hadoop/core-site.xml
ADD conf/hadoop/hadoop-env.sh       $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD conf/hadoop/hdfs-site.xml       $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD conf/hadoop/mapred-env.sh       $HADOOP_HOME/etc/hadoop/mapred-env.sh
ADD conf/hadoop/mapred-site.xml	    $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD conf/hadoop/yarn-site.xml       $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD conf/hadoop_spark_slaves	    $HADOOP_HOME/etc/hadoop/slaves
ADD conf/hadoop/masters     	    $HADOOP_HOME/etc/hadoop/masters


#SPARK CONFIG
ADD conf/hadoop_spark_slaves	$SPARK_HOME/conf/slaves
ADD conf/spark/spark-env.sh	$SPARK_HOME/conf/spark-env.sh
ADD conf/spark/log4j.properties $SPARK_HOME/conf/log4j.properties
ADD conf/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
#GLOBLE ENV
ADD setENV.sh      /etc/profile.d/setENV.sh
CMD ["/usr/sbin/sshd", "-D"]
