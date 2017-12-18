#Dockerfile para criacao do servidor de aplicacao NodeJS.
#Incluido drivers php para mysql, postgresql, mssql e oracle

FROM centos:latest
MAINTAINER pedro.papadopolis@mbamobi.com.br

ARG NODE_VERSION
ARG NPM_VERSION

#Variables
ENV nvm_release 0.33.1
ENV nodejs_release=$NODE_VERSION
ENV npm_release=$NPM_VERSION

#Create vim alias
RUN echo "alias vi=vim" >> /root/.bashrc \

#Basic packages
    && yum install -y deltarpm epel-release vim-enhanced net-tools bind-utils wget curl file cronie crontabs gcc make openssh openssh-clients bzip2 \
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
RUN npm install loopback -g

#Instalando a versão correta do NodeJS
RUN n $nodejs_release

#Instalando a versão correta do NPM
#RUN npm install npm@$npm_release -g

#Web packages
RUN npm config set unsafe-perm=true \
    && npm install -g uglify-js phantomjs-prebuilt

#Exclude unnecessary files
RUN yum -y remove libgearman-devel libevent libevent-devel gcc cpp glibc-devel glibc-headers kernel-headers libmpc mpfr \
    && yum clean all \
    && rm -rf /tmp/* 

#Copy custom cron
COPY cron/crontab /var/spool/cron/root

#Ajust timezone
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#Container's start script
COPY scripts/start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
