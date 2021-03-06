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
ENV oracle_instantclient oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
ENV oracle_instantclient_sdk oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
ENV oci_version oci8

ADD rpms/ /tmp/

#Create vim alias
RUN echo "alias vi=vim" >> /root/.bashrc \

#Basic packages
    && yum install -y gcc-c++ git deltarpm epel-release vim-enhanced net-tools bind-utils wget curl file cronie crontabs gcc make openssh openssh-clients bzip2 \
    && yum -y update \
    && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \

#Centos
    && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \
#Pacotes de pre-requisitos para o servidor Web
    && yum -y install supervisor freetds libaio \
    && curl --silent --location https://rpm.nodesource.com/setup_7.x | bash - \
    && yum -y install --disablerepo=epel npm nodejs \
    && yum -y install gcc gcc-c++

RUN yum install -y libaio.x86_64 glibc.x86_64
RUN yum -y localinstall /tmp/oracle* --nogpgcheck
RUN mkdir /usr/lib/oracle/12.2/client/network/admin -p
COPY ./tnsnames.ora /usr/lib/oracle/12.2/client/network/admin/tnsnames.ora

ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV TNS_ADMIN=$ORACLE_HOME/network/admin

#Instalando o gerenciador de versão do NodeJS
RUN npm install n -g
RUN npm install loopback -g

RUN npm install -g process-nextick-args inherits delegates console-control-strings semver string-width isarray core-util-is util-deprecate

#Instalando a versão correta do NPM
RUN npm install npm@$npm_release -g

#Instalando a versão correta do NodeJS
RUN n $nodejs_release

#Web packages
RUN npm config set unsafe-perm=true 
	#&& npm install -g process-nextick-args

#Oracle OCI 
COPY rpms/${oracle_instantclient} /tmp
COPY rpms/${oracle_instantclient_sdk} /tmp
RUN yum install -y php-pear
RUN yum -y localinstall /tmp/${oracle_instantclient} /tmp/${oracle_instantclient_sdk} \
#Update pecl protocols
    && pecl channel-update pecl.php.net

#Exclude unnecessary files
RUN yum clean all \
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
