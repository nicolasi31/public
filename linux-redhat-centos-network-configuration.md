**Centos Network Configuration**

[[_TOC_]]

# Ethernet

## /etc/sysconfig/network-scripts/ifcfg-eth0 (static)

```shell
DEVICE=eth0
HWADDR=52:54:00:12:34:56
ONBOOT=yes
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
IPADDR=10.1.1.1
PREFIX=24
GATEWAY=10.1.1.254
DNS1=10.1.1.254
DNS2=8.8.8.8
DEFROUTE=yes
PEERROUTES=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME="Connexion filaire 1"
UUID=11111111-2222-3333-4444-555555555555
AUTOCONNECT_PRIORITY=-999
MTU=1400
```

----

## /etc/sysconfig/network-scripts/ifcfg-eth0 (dhcp)

```shell
BOOTPROTO=dhcp
DEVICE=eth0
HWADDR=52:54:00:12:34:56
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
```

