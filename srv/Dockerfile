FROM debian:buster AS commtrust-base
MAINTAINER SURFnet <info@surfnet.nl>

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1
ENV TERM linux

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections  && \
    echo "deb http://ftp.de.debian.org/debian/ buster-backports main" >> /etc/apt/sources.list  && \
    apt update -y  && \
    apt install -y openssh-server redis python3 python sudo locales python-setuptools \
    python3-virtualenv virtualenv git vim net-tools bash-completion && \
    apt clean -y && apt-get autoremove -y && \
    update-locale  && \
    systemctl enable ssh.service  && \
    systemctl disable systemd-timesyncd.service  && \
    echo "exit 0" > /usr/sbin/policy-rc.d

RUN apt install -y apache2 libapache2-mod-php php-xml composer yarnpkg nodejs

# sshd services in all containers
EXPOSE 22
EXPOSE 80

STOPSIGNAL SIGRTMIN+3

CMD ["/lib/systemd/systemd"]
