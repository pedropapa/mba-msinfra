#Incluido drivers php para mysql, postgresql, mssql e oracle

FROM centos:latest
MAINTAINER pedro.papadopolis@mbamobi.com.br

#Variables
ENV php_release php71u
ENV oracle_instantclient oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
ENV oracle_instantclient_sdk oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
ENV oci_version oci8

#Create vim alias
RUN echo "alias vi=vim" >> /root/.bashrc \

#Basic packages
    && yum install -y deltarpm epel-release vim-enhanced net-tools bind-utils wget curl file cronie crontabs gcc make openssh openssh-clients bzip2 \
    && yum -y update \
    && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config \


#IUS repository - for PHP 5.6 or PHP 7.0
#RHEL
#    && yum -y install https://rhel7.iuscommunity.org/ius-release.rpm
#Centos
    && yum -y install https://centos7.iuscommunity.org/ius-release.rpm \

#Pacotes de pre-requisitos para o servidor Web e PHP
    && yum -y install supervisor freetds libaio \
    && curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - \
    && yum -y install --disablerepo=epel npm nodejs --skip-broken

#Web and PHP packages
RUN yum -y install pear1u ${php_release}-json ${php_release}-dev nginx ${php_release} ${php_release}-gd ${php_release}-ldap ${php_release}-curl ${php_release}-openssl ${php_release}-pcre ${php_release}-xml ${php_release}-cli ${php_release}-xml ${php_release}-devel ${php_release}-geoip ${php_release}-bcmath ${php_release}-pear ${php_release}-pdo ${php_release}-pdo-dblib ${php_release}-intl ${php_release}-pecl-zendopcache ${php_release}-mbstring ${php_release}-mcrypt ${php_release}-fpm ${php_release}-pgsql ${php_release}-mysqlnd ${php_release}-mssql ${php_release}-pecl-imagick ${php_release}-opcache ${php_release}-mcrypt ${php_release}-gearman ${php_release}-pecl-igbinary ${php_release}-pecl-redis ${php_release}-pecl-zip git ${php_release}-soap

#Change opcache parameters
RUN sed -i 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=60/g' /etc/php.d/*opcache.ini \
    && sed -i 's/;opcache.enable_cli=0/opcache.enable_cli=1/g' /etc/php.d/*opcache.ini

#Oracle OCI
COPY rpms/${oracle_instantclient} /tmp
COPY rpms/${oracle_instantclient_sdk} /tmp
COPY rpms/avconv_rpm.tar /tmp/avconv_rpm.tar
RUN tar xvf /tmp/avconv_rpm.tar -C /tmp \
    && yum -y localinstall /tmp/${oracle_instantclient} /tmp/${oracle_instantclient_sdk} /tmp/avconv/*.rpm \
#Update pecl protocols
    && pecl channel-update pecl.php.net \
#OCI
    && echo '' | pecl install ${oci_version} \
#
    && export ORACLE_HOME=/tmp/${oracle_instantclient} \
#Create oci8.ini in php.d
    && echo "; Enable OCI8 extension module" > /etc/php.d/oci8.ini \
    && echo "extension=oci8.so" >> /etc/php.d/oci8.ini

#Change PHP timezone, memory_limit and upload parameters

RUN sed -i 's/;date.timezone =/date.timezone = America\/Sao_Paulo/g'  /etc/php.ini \
    && sed -i 's/memory_limit = 128M/memory_limit = 2048M/g' /etc/php.ini \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 3000M/g' /etc/php.ini \
    && sed -i 's/post_max_size = 8M/post_max_size = 2000M/g' /etc/php.ini \

#Change php-fpm process manager to ondemand and user/group to apache
    && sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php-fpm.d/www.conf \
    && sed -i 's/user = php-fpm/user = apache/g' /etc/php-fpm.d/www.conf \
    && sed -i 's/group = php-fpm/group = apache/g' /etc/php-fpm.d/www.conf

#Install php-pecl-gearman for PHP 7.0
RUN cd /tmp \
    && yum -y install libgearman-devel \
    && git clone https://github.com/wcgallego/pecl-gearman.git \
    && cd pecl-gearman \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo 'extension="gearman.so"' > /etc/php.d/30-gearman.ini

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

#Copy nginx custom config
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY configs/nginx/rnt.conf /etc/nginx/conf.d/rnt.conf

#Exclude unnecessary files
RUN yum -y remove libgearman-devel libevent-devel gcc cpp glibc-devel glibc-headers kernel-headers libmpc mpfr \
    && yum clean all \
    && rm -rf /tmp/*

#Copy custom cron
COPY cron/crontab /var/spool/cron/root

#Ajust timezone
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
#Ajust php-fpm sessions permissions to apache group
    && mkdir -p /var/lib/php-fpm/session \
    && chmod 770 /var/lib/php-fpm/session \
    && chgrp apache /var/lib/php-fpm/*

#Expose http and https port
#EXPOSE 80 443

#External volume
#VOLUME /dados

#Container's start script
COPY scripts/start.sh /start.sh
RUN chmod 755 /start.sh
CMD ["/start.sh"]