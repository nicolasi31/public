**LetsEncrypt / Certbot Tips**

[[_TOC_]]

```shell
certbot certonly --manual --preferred-challenges dns -d www.example.com
```

----

- https://github.com/obynio/certbot-plugin-gandi

```shell
cat > ${HOME}/gandi.ini << _EOF_
# live dns v5 api key
#certbot_plugin_gandi:dns_api_key=APIKEY
certbot_plugin_gandi:dns_api_key=0123456789abcdefghijklmn

# optional organization id, remove it if not used
#certbot_plugin_gandi:dns_sharing_id=SHARINGID

# Command to update all domains:
# certbot renew -a certbot-plugin-gandi:dns --certbot-plugin-gandi:dns-credentials gandi.ini
_EOF_
```

```shell
certbot renew -a certbot-plugin-gandi:dns --certbot-plugin-gandi:dns-credentials gandi.ini
```
