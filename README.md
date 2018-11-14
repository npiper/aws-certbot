# Test of using Let's encrypt

Goal:  Can we launch a version of a webserver of 'neilpiper.me' that uses a Let's encrypt certificate for that domain and is fully automated?

# Initial approach

 * Docker setup of environment
 * Install nginx, lets encrypt, AWS cli
 * Env variables for Domain, admin email & any AWS authentication, keys


# Runtime variables

```
DOMAIN
DOMAIN_ADMIN_EMAIL
```

Example docker run
```
docker run my-awesome-image -e "DOMAIN=mydomain.com" -e "DOMAIN_ADMIN_EMAIL=webmaster@mydomain.com"
```

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

Create an AMI with ansible
https://djaodjin.com/blog/create-ec2-ami-with-ansible.blog.html


Build an AWS Packer image AMI
https://www.packer.io/intro/getting-started/build-image.html

AWS CLI Installation
https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html
