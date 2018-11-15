FROM nginx

MAINTAINER neiltpiper@gmail.com

# nginx docker is debian:stretch-slim

# Environment variables
ENV DOMAIN_ADMIN_EMAIL your@email.com
ENV DOMAIN your_domain.com
ENV AWS_ACCESS_KEY_ID your_access_key_id
ENV AWS_SECRET_ACCESS_KEY your_secret_key
ENV AWS_DEFAULT_REGION eu-west-1

# Add the Debian backports for stretch slim
RUN cat /etc/apt/sources.list
RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
RUN cat /etc/apt/sources.list

# Update
RUN apt-get -y -q update

# Certbot
RUN apt-get install -y -q python-certbot-nginx -t stretch-backports

# Python, python-pip
RUN apt-get install -y -q python python-pip

# AWS CLI
RUN pip install awscli

COPY auth-hook.sh $HOME/auth-hook.sh
COPY certbot-exec.sh $HOME/certbot-exec.sh

#RUN aws configure --region $REGION --output json
