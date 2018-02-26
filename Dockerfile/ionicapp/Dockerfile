#Dockerfile para criacao do servidor de aplicacao NodeJS.
#Incluido drivers php para mysql, postgresql, mssql e oracle

FROM node:8
MAINTAINER pedro.papadopolis@mbamobi.com.br

ARG NODE_VERSION
ARG NPM_VERSION

#Variables
ENV nodejs_release=$NODE_VERSION
ENV npm_release=$NPM_VERSION

#Create vim alias
RUN echo "alias vi=vim" >> /root/.bashrc

RUN apt-get update

#Instalando o gerenciador de versão do NodeJS
RUN npm install n -g

RUN adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx

#Web packages
RUN apt-get -y install nginx \
    && npm config set unsafe-perm=true \
    && npm install -g @angular/cli

#Copy nginx custom config
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/rnt.conf /etc/nginx/conf.d/rnt.conf

#Copy custom cron
COPY cron/crontab /var/spool/cron/root

#Ajust timezone
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#Instalando o ionic/cordova
RUN npm install -g ionic cordova@8.0.0

#Container's start script
COPY scripts/start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]
