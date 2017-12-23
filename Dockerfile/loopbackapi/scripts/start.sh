#!/bin/bash

#Add github's token key
if [ -z $GIT_TOKEN ]
then
	echo "GIT token not defined"
else
	mkdir /root/.composer -p
	rm -f /root/.composer/auth.json
	echo "{" >> /root/.composer/auth.json
	echo "    \"github-oauth\": {"  >> /root/.composer/auth.json
	echo "        \"github.com\": \"$GIT_TOKEN\"" >> /root/.composer/auth.json
	echo "    }" >> /root/.composer/auth.json
	echo "}" >> /root/.composer/auth.json
fi


#cron
echo "Starting cron"
/usr/sbin/crond
echo

#Alterando a versão do NodeJS e NPM
if [ -z $NODE_VERSION ]
then
	cd /var/source && n $NODE_VERSION
fi

if [ -z $NPM_VERSION ]
then
	/usr/local/bin/npm install npm@$NPM_VERSION -g
fi

#Instalando o projeto.
cd /var/source
/usr/local/bin/npm install oracle/node-oracledb#v2.0.15
/usr/local/bin/npm install

#Server start
echo "Iniciando api"
/usr/local/bin/npm start
