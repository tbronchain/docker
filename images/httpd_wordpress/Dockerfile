# Simple Web Server with Wordpress

FROM      ubuntu

# add Wordpress sources
ADD wp_latest.zip /tmp/wp_latest.zip
ADD wp-config.php /tmp/wp-config.php

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# install web server
RUN apt-get -y install php5-gd libssh2-php apache2 libapache2-mod-auth-mysql php5-mysql php5 libapache2-mod-php5 php5-mcrypt unzip

# bootstrap wordpress
RUN unzip /tmp/wp_latest.zip -d /var/www/
RUN cp -f /tmp/wp-config.php /var/www/wordpress/wp-config.php

# env variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Binary to start
ENTRYPOINT ["/usr/sbin/apache2"]

# Docker command (Binary's parameters)
CMD ["-D", "FOREGROUND"]
