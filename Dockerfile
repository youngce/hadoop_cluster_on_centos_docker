FROM centos:centos6.6

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
# hadoop
ENV HADOOP_PKG_NAME hadoop-2.6.0
ENV HADOOP_HOME /usr/local/hadoop

RUN wget http://www.eu.apache.org/dist/hadoop/common/$HADOOP_PKG_NAME/$HADOOP_PKG_NAME.tar.gz

RUN tar xvzf $HADOOP_PKG_NAME.tar.gz && rm -f $HADOOP_PKG_NAME.tar.gz && mv $HADOOP_PKG_NAME $HADOOP_HOME

#RUN echo "export VISIBLE=now" >> /etc/profile && echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile && echo "export HADOOP_HOME=$HADOOP_HOME" >> /etc/profile && echo "export PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH" >> /etc/profile

RUN mkdir /name 
ADD HadoopConf/core-site.xml       /usr/local/hadoop/etc/hadoop/core-site.xml
ADD HadoopConf/hadoop-env.sh       /usr/local/hadoop/etc/hadoop/hadoop-env.sh
ADD HadoopConf/hdfs-site.xml       /usr/local/hadoop/etc/hadoop/hdfs-site.xml
ADD HadoopConf/mapred-env.sh       /usr/local/hadoop/etc/hadoop/mapred-env.sh
ADD HadoopConf/mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
ADD HadoopConf/yarn-site.xml       /usr/local/hadoop/etc/hadoop/yarn-site.xml
ADD HadoopConf/slaves      /usr/local/hadoop/etc/hadoop/slaves
ADD HadoopConf/masters     /usr/local/hadoop/etc/hadoop/masters
ADD ip_hostnames       /root/ip_hostnames
#ADD setHosts.sh     /etc/profile.d/setHosts.sh
ADD setENV.sh      /etc/profile.d/setENV.sh
CMD ["/usr/sbin/sshd", "-D"]
