#!/bin/bash

#Change example.com for custom url
rnt_conf="/etc/nginx/conf.d/rnt.conf"
if grep example.com $rnt_conf  > /dev/null 2>&1
then
	#If SERVER_NAME defined, change nginx server_name parameter
	if [ -z "$SERVER_NAME" ]
	then
		echo "URL Default: www.example.com"
	else
		SERVER_NAME_LOG=`echo $SERVER_NAME | cut -d " " -f1`
                sed -i "s/www.example.com-error.log/$SERVER_NAME_LOG-error.log/g" $rnt_conf
                sed -i "s/www.example.com-access.log/$SERVER_NAME_LOG-access.log/g" $rnt_conf
		sed -i "s/www.example.com/$SERVER_NAME/g" $rnt_conf
	fi	

	#If NODEJS_SERVER_NAME defined, change nginx server_name parameter
	if [ -z $NODEJS_SERVER_NAME ]
	then
		echo "URL Default: nodejs.example.com"
	else	
		sed -i 's/#    location \/socket.io {/    location \/socket.io {/g' $rnt_conf

		sed -i 's/#        proxy_pass http:\/\/nodejs.example.com\/socket.io;/        proxy_pass http:\/\/nodejs.example.com\/socket.io;/g' $rnt_conf

		sed -i 's/#        proxy_http_version 1.1;/        proxy_http_version 1.1;/g' $rnt_conf
		sed -i 's/#        proxy_set_header Upgrade $http_upgrade;/        proxy_set_header Upgrade $http_upgrade;/g' $rnt_conf
		sed -i 's/#        proxy_set_header Connection "upgrade";/        proxy_set_header Connection "upgrade";/g' $rnt_conf
		sed -i 's/#    }/    }/g' $rnt_conf

		sed -i "s/nodejs.example.com/$NODEJS_SERVER_NAME/g" $rnt_conf
	fi	
fi

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

if [ -z $NPM_VERSION ]
then
	/usr/local/bin/npm install npm@$NPM_VERSION -g
fi

#Alterando a versão do NodeJS e NPM
if [ -z $NODE_VERSION ]
then
	cd /var/source n $NODE_VERSION
fi

#Instalando o projeto.
cd /var/source
/bin/rm -rf node_modules
/usr/local/bin/npm install
/usr/local/bin/ionic build --dev

#nginx start
echo "Stating nginx"
/bin/rm -f /run/nginx.pid
/usr/sbin/nginx -g 'daemon off;'
