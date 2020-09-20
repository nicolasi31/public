**OpenSSL Tips and Tricks**

[[_TOC_]]

----

# Regenerate hosts certificates
```shell
ssh-keygen -A
```

----

# Regenerate WEB server autosigned certificates
```shell
OSSL_COUNTRY="FR"
OSSL_STATE="Occitanie"
OSSL_LOCATION="Toulouse"
OSSL_CN="${HOSTNAME}"
OSSL_KEYSIZE=2048
WEB_SERV_DIR="/etc/certs"

mkdir ${WEB_SERV_DIR}

openssl req -x509 -nodes -days 365 \
 -newkey rsa:${OSSL_KEYSIZE} \
 -keyout ${WEB_SERV_DIR}/${OSSL_CN}.key \
 -out ${WEB_SERV_DIR}/${OSSL_CN}.crt \
 -subj "/C=${OSSL_COUNTRY}/ST=${OSSL_STATE}/L=${OSSL_LOCATION}/CN=${OSSL_CN}"
```

----

# Password modification
```shell
openssl passwd
ENCRYPTEDPASSWORD
usermod -p ENCRYPTEDPASSWORD root
```

----

# SABNZBPLUS cert :
```shell
openssl genrsa 2048 > ~/.sabnzbd/server.key
openssl req -new -x509 -nodes -sha256 -days 365 -key ~/.sabnzbd/server.key > ~/.sabnzbd/server.cert
```

----

# Docker HAproxy certs
```shell
OSSL_COUNTRY="FR"
OSSL_STATE="Occitanie"
OSSL_LOCATION="Toulouse"
OSSL_KEYSIZE=2048
WEB_SERV_DIR="/etc/certs"
CONTAINER_NAME="haproxydocker"

mkdir ${WEB_SERV_DIR}

openssl genrsa -out ${WEB_SERV_DIR}/${CONTAINER_NAME}.key ${OSSL_KEYSIZE}
openssl req -new \
 -key ${WEB_SERV_DIR}/${CONTAINER_NAME}.key \
 -out ${WEB_SERV_DIR}/${CONTAINER_NAME}.csr \
 -subj "/C=${OSSL_COUNTRY}/ST=${OSSL_STATE}/L=${OSSL_LOCATION}/CN=${CONTAINER_NAME}"
openssl x509 -req -days 365 \
 -in ${WEB_SERV_DIR}/${CONTAINER_NAME}.csr \
 -signkey ${WEB_SERV_DIR}/${CONTAINER_NAME}.key \
 -out ${WEB_SERV_DIR}/${CONTAINER_NAME}.crt
cat ${WEB_SERV_DIR}/${CONTAINER_NAME}.crt ${WEB_SERV_DIR}/${CONTAINER_NAME}.key | tee ${WEB_SERV_DIR}/${CONTAINER_NAME}.pem

docker run -p 8888:8888 -p 8889:8889 -v ${WEB_SERV_DIR}/:/usr/local/etc/haproxy/:rw -v /dev/log:/dev/log --name ${CONTAINER_NAME} haproxy:latest
```
