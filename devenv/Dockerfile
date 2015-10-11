# sshd
#
# VERSION               0.0.2

FROM ubuntu:14.04

# Dev tools
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get -y install gcc make binutils htop g++ nasm git subversion mercurial emacs24-nox gdb lxc apt-transport-https golang man-db python-pip pydb scala php5 php5-cli php-elisp libc-dbg ssh-client wish npm

# Sbt
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-get update
RUN apt-get -y --force-yes install sbt

# Docker
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get -y install lxc-docker

RUN mkdir -p /sources

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
#RUN echo 'root:root' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN groupadd -r admin
RUN useradd -G admin -s /bin/bash -U -m user
RUN echo user:user | chpasswd

RUN ln -s /home /Users

CMD ["/usr/sbin/sshd", "-D"]
