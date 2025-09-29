```bash
docker run \
  --user 1000:1000 \
  --rm -e CF_DNS_API_TOKEN=$CF_DNS_API_TOKEN \
  -v /home/debian/services/appdata/lego:/data \
  goacme/lego:latest \
  --accept-tos \
  --email certs@rizexor.com \
  --dns cloudflare \
  --domains '*.fossindia.ovh' \
  --domains fossindia.ovh \
  --path /data \
  run
```