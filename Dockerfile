FROM nginx

MAINTAINER neiltpiper@gmail.com

# nginx docker is debian:stretch-slim

# Environment variables
ENV DOMAIN_ADMIN_EMAIL your@email.com
ENV DOMAIN your_domain.com

# Add the Debian backports for stretch slim
RUN uname -a
RUN cat /etc/*-release

RUN cat /etc/apt/sources.list
RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
RUN cat /etc/apt/sources.list

RUN apt-get -y -q update

RUN apt-get install -y -q python-certbot-nginx -t stretch-backports
RUN apt-get install -y -q python-pip

# AWS CLI
RUN pip install awscli --upgrade --user
RUN ls -al $(which python)

RUN aws --version

COPY auth-hook.sh $HOME/auth-hook.sh
COPY certbot-exec.sh $HOME/certbot-exec.sh
