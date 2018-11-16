# AWS + Let's encrypt Docker SSL Certificate Generator

Goal:  Can we launch a version of a webserver of 'neilpiper.me' that uses a Let's encrypt certificate for that domain and is fully automated?

This project creates a docker container meeting the software requirements of the article [Easy, Lets Encrypt certificates on AWS](https://hackernoon.com/easy-lets-encrypt-certificates-on-aws-79387767830bs) - thanks to Lionel Martin.

Let’s Encrypt offers a free Certificate Authority service. It will sign SSL/TLS certificates for free.

You can experiment with SSL on AWS without getting those pesky 'Untrusted certificate' warnings on your browser or for your users.  

Benefits are you can take your certificate somewhere else in future if you need to rather than being restricted to AWS. You also don't need the more expensive AWS options mentioned in Lionel's article.

Its a principle of mine not to pollute my local dev environment with too many software versions and tools and where I find a need to instead script up infrastructure like Vagrant, Docker or an AMI and follow CI/CD.

## TO DO

Move the certificate somewhere useful in an automated way.

# Initial approach

 * Docker setup of environment requirements
 * Install nginx, lets encrypt, AWS cli
 * Allow use of Env variables for Domain, admin email & any AWS authentication, keys

# Pre-Requisites

 * AWS Account and authorised user at Administrator level
 * A domain name you own via AWS Route53
 * Your domain name registered as a hosted zone in Route53 in your AWS account

In my example I have an AWS account, and a domain I own `neilpiper.me` is registered in Route53 and a hosted zone. (This is the only part that I haven't found a way to make free!)

# Docker Build

Build your docker image

```
docker build -t npiper/certbot-nginx .
```

Also built at travis-ci [npiper/aws-certbot](https://travis-ci.org/npiper/aws-certbot)


# Runtime variables

These are the runtime variables of the container you should use so that you generate a certificate in the container.

```
DOMAIN // Your internet domain e.g. neilpiper.me
DOMAIN_ADMIN_EMAIL // Your admin email for that domain e.g. webmaster@neilpiper.me

// AWS Credentials
AWS_ACCESS_KEY_ID your_access_key_id
AWS_SECRET_ACCESS_KEY your_secret_key

// Optional region - default Ireland
AWS_DEFAULT_REGION eu-west-1
```

Example docker run

```
docker run npiper/certbot-nginx -e "DOMAIN=neilpiper.me" \
 -e "DOMAIN_ADMIN_EMAIL=webmaster@gmail.com" \
 -e "AWS_ACCESS_KEY_ID=myaccesskey" \
 -e "AWS_SECRET_ACCESS_KEY=mysecretkey"
```

## Once running - create a certificate

Enter your container and execute the following set of commands.

```
docker ps

// get the container id of npiper/certbot-nginx
docker exec -it {containerId} bash


# accept defaults - your env variables take overview
aws configure

# test aws connectivity
aws ec2 describe-regions

# Expectation you meet the pre-requisutes
./certbot-exec.sh
```
Wait a few minutes..

```
>./certbot-exec.sh

Saving debug log to /letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for yourdomain.com
dns-01 challenge for www.youdomain.com
Waiting for verification...
Cleaning up challenges
Non-standard path(s), might not work with crontab installed by your operating system package
manager

IMPORTANT NOTES:

 - Congratulations! Your certificate and chain have been saved at:
...
```
You should be done!

A signed SSL RSA 2048 certificate chain from a trusted CA that (unfortunately) expires in 90 days with the accompanying private key.

Certificate and Chain at
 `/letsencrypt/live/${DOMAIN}/fullchain.pem`

Keyfile at
`/letsencrypt/live/${DOMAIN}/privkey.pem`

Note - there's not much error checking in the scripts so if it doesn't work check your env variables and the pre-requisites.

# Copy your crypto assets locally

Using Docker copy ..

Get your container ID of the running instance `docker ps` and replace the domain name in command below.

`-L` used for copying the symbol link

```
docker cp -L ${containerId}:/letsencrypt/live/${DOMAIN}/fullchain.pem

docker cp -L ${containerId}:/letsencrypt/live/${DOMAIN}/privkey.pem
```

## Help.. I want to revoke!

Let's encrypt has a [guide on how to revoke](https://letsencrypt.org/docs/revoking/)

# References

Good blog suggestion on a setup close to this - just minus docker option..
https://hackernoon.com/easy-lets-encrypt-certificates-on-aws-79387767830b

Nginx Dockerhub (Debian slim Docker image)
https://hub.docker.com/_/nginx/

Certbot on Debian/Nginx & Docs
https://certbot.eff.org/lets-encrypt/debianstretch-nginx
https://certbot.eff.org/docs/

Let's encrypt
https://letsencrypt.org/getting-started/
https://letsencrypt.org/how-it-works/
https://github.com/ietf-wg-acme/acme



AWS CLI Installation
https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html

AWS CLI On Debian Slim
https://gist.github.com/anamorph/aaf8434d3bbad92059b3

How to read Cert metadata (.pem) file
https://coolaj86.com/articles/how-to-examine-an-ssl-https-tls-cert/

## Next option - put this in an AMI

Possible to copy the assets to a secure S3 bucket or vault instance?

Create an AMI with ansible
https://djaodjin.com/blog/create-ec2-ami-with-ansible.blog.html

Build an AWS Packer image AMI
https://www.packer.io/intro/getting-started/build-image.html
