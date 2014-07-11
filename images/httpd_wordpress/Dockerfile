# Simple Web Server with Wordpress

FROM      ubuntu

# add Wordpress sources
ADD mysql_bootstrap.sh /tmp/mysql_bootstrap.sh
ADD wp_latest.zip /tmp/wp_latest.zip
ADD wp-config.php /tmp/wp-config.php

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# install nginx
RUN apt-get install -y php5-gd libssh2-php apache2 mysql-server libapache2-mod-auth-mysql php5-mysql php5 libapache2-mod-php5 php5-mcrypt

# bootstrap mysql
RUN mysql -uroot < /tmp/mysql_bootstrap.sh

# bootstrap wordpress
RUN unzip /tmp/wp_latest.zip -d /var/www/html/
RUN cp /tmp/wp-config.php /var/www/html/wp-config.php

# env variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
