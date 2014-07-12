# Simple Web Server

FROM      ubuntu

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# install nginx
RUN apt-get install -y apache2

# env variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# expose port 80
EXPOSE 80

# Binary to start
ENTRYPOINT ["/usr/sbin/apache2"]

# Docker command (Binary's parameters)
CMD ["-D", "FOREGROUND"]
