# Simple Web Server with Wordpress

FROM      ubuntu:14.04

# add Wordpress sources
ADD wp_latest.zip /tmp/wp_latest.zip

# make sure the package repository is up to date
RUN apt-get update

# install web server
RUN apt-get -y install php5-gd libssh2-php apache2 libapache2-mod-auth-mysql php5-mysql php5 libapache2-mod-php5 php5-mcrypt unzip

# bootstrap wordpress
RUN unzip /tmp/wp_latest.zip -d /var/www/
