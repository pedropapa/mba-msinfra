#!/bin/bash

#Create workers log if doesn't exist
mkdir -p /var/www/html/app/logs/workers

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
                sed -i "s/www.example.com-acctess.log/$SERVER_NAME_LOG-access.log/g" $rnt_conf
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

cd /var/www/html
composer install


#cron
echo "Starting cron"
/usr/sbin/crond
echo

#supervisor (workers gearman)
echo "Starting supervisor"
/usr/bin/supervisord -c /etc/supervisord.conf
echo

#dynatrace
if [ -z $DYNATRACE_VERSION ]
then
	echo "DYNATRACE_VERSION variable is necessary (ex: 6.5)"
	echo

elif [ -f /etc/init.d/dynaTraceWebServerAgent ]
then
	echo "Starting Dynatrace agent"
	echo
	/etc/init.d/dynaTraceWebServerAgent start
	export LD_PRELOAD=/opt/dynatrace-$DYNATRACE_VERSION/agent/lib64/libdtagent.so
	echo "extension=/opt/dynatrace-$DYNATRACE_VERSION/agent/lib64/libdtagent.so" > /etc/php.d/dynatrace.ini
fi

#php-fpm
echo "Starting php-fpm"
/usr/sbin/php-fpm --daemonize
echo

#nginx start
echo "Stating nginx"
/usr/bin/rm -f /run/nginx.pid
/usr/sbin/nginx -g 'daemon off;'
