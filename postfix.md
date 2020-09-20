**VirtualBox**

[[_TOC_]]

# Display/Show Configuration
```shell
# list all configuration
postconf
# Display only parameters different from default
postconf -n
# list default configuration
postconf -d
```

# Configuration
```shell
MY_HOSTNAME="server02"
MY_DOMAINNAME="example.com"
MY_RELAYHOST="192.168.0.100"

sysctl -w kernel.hostname=${MY_HOSTNAME}
sysctl -w kernel.domainname=${MY_DOMAINNAME}

/bin/echo -e "kernel.hostname=${MY_HOSTNAME}\nkernel.domainname=${MY_DOMAINNAME}" >> /etc/sysctl.d/01-perso.conf

postconf inet_protocols=ipv4
postconf myhostname=$(sysctl -n kernel.hostname)
postconf mydomain=$(sysctl -n kernel.domainname)
postconf myorigin=\$myhostname.\$mydomain
postconf mydestination=localhost.\$mydomain,localhost,\$myhostname,\$myorigin
postconf mynetworks=127.0.0.0/8
if [ ${#MY_RELAYHOST} -gt 0 ] ; then postconf relayhost=${MY_RELAYHOST} ; fi
```

# Check Configuration
```shell
postfix check
```

# test message
```shell
TSTMSG="test01" ; echo ${TSTMSG} | mail -s ${TSTMSG} user02@example.com
```
