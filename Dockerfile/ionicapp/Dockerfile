#Dockerfile para criacao do servidor de aplicacao NodeJS.
#Incluido drivers php para mysql, postgresql, mssql e oracle

FROM centos:latest
MAINTAINER pedro.papadopolis@mbamobi.com.br

ARG NODE_VERSION
ARG NPM_VERSION

#Variables
ENV oracle_instantclient oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
ENV oracle_instantclient_sdk oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
ENV oci_version oci8
ENV nvm_release 0.33.1
ENV nodejs_release=$NODE_VERSION
ENV npm_release=$NPM_VERSION

#Create vim alias
RUN echo "alias vi=vim" >> /root/.bashrc \

#Basic packages
    && yum install -y git deltarpm epel-release vim-enhanced net-tools bind-utils wget curl file cronie crontabs gcc make openssh openssh-clients bzip2 \
    && yum -y update \
    && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \

#Centos
    && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \

#Pacotes de pre-requisitos para o servidor Web
    && yum -y install supervisor freetds libaio \
    && curl --silent --location https://rpm.nodesource.com/setup_7.x | bash - \
    && yum -y install --disablerepo=epel npm nodejs \
    && yum -y install gcc-c++

#Instalando o gerenciador de versão do NodeJS
RUN npm install n -g

#Instalando a versão correta do NodeJS
RUN n $nodejs_release

#Instalando a versão correta do NPM
#RUN npm install npm@$npm_release -g

#Web packages
RUN yum -y install nginx \
    && npm config set unsafe-perm=true \
    && npm install -g uglify-js \
    && npm install -g @angular/cli

#Oracle OCI 
COPY rpms/${oracle_instantclient} /tmp
COPY rpms/${oracle_instantclient_sdk} /tmp
COPY rpms/avconv_rpm.tar /tmp/avconv_rpm.tar

RUN tar xvf /tmp/avconv_rpm.tar -C /tmp \
    && yum -y localinstall /tmp/${oracle_instantclient} /tmp/${oracle_instantclient_sdk} /tmp/avconv/*.rpm \
    && rm -f /tmp/${oracle_instantclient} /tmp/${oracle_instantclient_sdk} 

#Copy nginx custom config
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/rnt.conf /etc/nginx/conf.d/rnt.conf

#Exclude unnecessary files
RUN yum -y remove libgearman-devel libevent libevent-devel gcc cpp glibc-devel glibc-headers kernel-headers libmpc mpfr \
    && yum clean all \
    && rm -rf /tmp/* 

#Copy custom cron
COPY cron/crontab /var/spool/cron/root

#Ajust timezone
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#Instalando o ionic/cordova
RUN npm install -g ionic cordova

#Container's start script
COPY scripts/start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
