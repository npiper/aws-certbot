# Use Let's Encrypt certbot to order a free certificate
certbot certonly --non-interactive --manual \
  --manual-auth-hook "./auth-hook.sh UPSERT $DOMAIN" \
  --manual-cleanup-hook "./auth-hook.sh DELETE $DOMAIN" \
  --preferred-challenge dns \
  --config-dir "./letsencrypt" \
  --work-dir "./letsencrypt" \
  --logs-dir "./letsencrypt" \
  --agree-tos \
  --manual-public-ip-logging-ok \
  --domains $DOMAIN,www.$DOMAIN \
  --email $DOMAIN_ADMIN_EMAIL 
