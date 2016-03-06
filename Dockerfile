# Base Centos7 image
# Add private key and public key files for ssh root
FROM centos:7.1.1503
MAINTAINER ylin ylin30@gmail.com

#RUN yum update -y
RUN yum -y install openssh-server epel-release && \
    yum -y install openssh-clients epel-release && \
    yum -y install pwgen && \
    yum -y install tar && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config

#ADD set_root_pw.sh /set_root_pw.sh
#ADD run.sh /run.sh
#RUN chmod +x /*.sh

ADD files /root/docker_files
RUN mkdir /root/.ssh && \
	chmod go-rx /root/.ssh && \
	mkdir /var/run/sshd && \
	cp /root/docker_files/ssh/* /root/.ssh && \
	chmod go-rwx /root/.ssh/id_rsa && \
	chmod go-wx /root/.ssh/authorized_keys && \
	yum -y install vim 

ENV AUTHORIZED_KEYS /root/.ssh/authorized_keys

EXPOSE 22

# Opentsdb port
EXPOSE 4242

# ZK port
EXPOSE 2181
EXPOSE 2888
EXPOSE 3888

# HDFS port
EXPOSE 50010 50020 50070

# HBase port
EXPOSE 16000 
# hbase.master.port

EXPOSE 16010  
# hbase.master.info.port

EXPOSE 16020  
# hbase.regionsever.port

EXPOSE 16030  
# hbase.regionserver.info.port

EXPOSE 8080 8085   
# hbase.rest.port

EXPOSE 9000 9090 9095
# hbase.rest.port

# GRAFANA port
EXPOSE 3000

# Alert-daemon port
EXPOSE 5001

RUN chmod 700 /root/docker_files/default_cmd

CMD ["/root/docker_files/default_cmd"]
