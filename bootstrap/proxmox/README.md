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

```bash
export OMNI_VERSION=1.2.1
OMNI_ACCOUNT_UUID=$(uuidgen)
OMNI_DOMAIN_NAME=omni.fossindia.ovh
OMNI_WG_IP=192.168.3.69
OMNI_ADMIN_EMAIL=me@rizexor.com
AUTH0_CLIENT_ID=EXGbxvfNmk1s0Kw27K2pX0FEOkvGBy85
AUTH0_DOMAIN=dev-pdtgsnqj.eu.auth0.com
```

```bash
# Omni
OMNI_IMG_TAG=latest
OMNI_ACCOUNT_UUID=36267e53-f04c-431a-acc8-05e0362a10ae
NAME=omni
EVENT_SINK_PORT=8091

## Keys and Certs
TLS_CERT=/docker/appdata/lego/certificates/_.fossindia.ovh.crt
TLS_KEY=/docker/appdata/lego/certificates/_.fossindia.ovh.key
ETCD_VOLUME_PATH=/docker/appdata/omni/etcd
ETCD_ENCRYPTION_KEY=/docker/appdata/omni/omni.asc

## Binding
BIND_ADDR=0.0.0.0:443
MACHINE_API_BIND_ADDR=0.0.0.0:8090
K8S_PROXY_BIND_ADDR=0.0.0.0:8100

## Domains and Advertisements
OMNI_DOMAIN_NAME="${OMNI_DOMAIN_NAME}"
ADVERTISED_API_URL="https://${OMNI_DOMAIN_NAME}"
SIDEROLINK_ADVERTISED_API_URL="https://${OMNI_DOMAIN_NAME}:8090/"
ADVERTISED_K8S_PROXY_URL="https://${OMNI_DOMAIN_NAME}:8100/"
SIDEROLINK_WIREGUARD_ADVERTISED_ADDR="${OMNI_WG_IP}:50180"

## Users
INITIAL_USER_EMAILS="${OMNI_ADMIN_EMAIL}"

## Authentication
#Auth0
AUTH='--auth-auth0-enabled=true \
      --auth-auth0-domain=${AUTH0_DOMAIN} \
      --auth-auth0-client-id=${AUTH0_CLIENT_ID}
# Or, when using SAML:
# AUTH='--auth-saml-enabled=true \
#       --auth-saml-url=<saml-url>'
#Only one AUTH version can be used at a time, so ensure to remove the one you don't use.```
```