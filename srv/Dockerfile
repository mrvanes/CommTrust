FROM debian:buster AS commtrust-srv
MAINTAINER SURFnet <info@surfnet.nl>

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1
ENV TERM linux

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections  && \
    echo "deb http://ftp.de.debian.org/debian/ buster-backports main" >> /etc/apt/sources.list  && \
    apt update -y  && \
    apt install -y openssh-server sudo locales git vim net-tools bash-completion && \
    apt clean -y && apt-get autoremove -y && \
    update-locale  && \
    systemctl enable ssh.service  && \
    systemctl disable systemd-timesyncd.service  && \
    echo "exit 0" > /usr/sbin/policy-rc.d

RUN apt install -y apache2 libapache2-mod-php \
    php-xml php-curl php-mysql php-dom \
    mariadb-server mariadb-client


# sshd services in all containers
EXPOSE 22
EXPOSE 80
EXPOSE 443
EXPOSE 3306

STOPSIGNAL SIGRTMIN+3

CMD ["/lib/systemd/systemd"]
