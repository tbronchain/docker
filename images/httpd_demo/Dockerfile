# Simple Web Server with Wordpress

FROM      ubuntu:14.04

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

# expose port 80
EXPOSE 80

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

CMD ["/usr/sbin/sshd", "-D"]
