**Network Configuration**

[[_TOC_]]

# iproute2
## Direct connection config
```shell
MY_NEW_NETIP="192.168.0.10/24"
MY_NEW_NETIF="eth0"
MY_NEW_NETGW="192.168.0.254"
MY_NEW_DNS1="192.168.0.254"

ip addr add ${MY_NEW_NETIP} dev ${MY_NEW_NETIF}
ip link set dev ${MY_NEW_NETIF} up
ip route add default via ${MY_NEW_NETGW}
sed -i "1s/^/nameserver ${MY_NEW_DNS1}\n/" /etc/resolv.conf
```

## Bridge config
```shell
MY_NEW_NETIP="192.168.0.10/24"
MY_NEW_NETIF="eth0"
MY_NEW_NETRBIDGE="brwan"
MY_NEW_NETGW="192.168.0.254"
MY_NEW_DNS1="192.168.0.254"

ip addr del ${MY_NEW_NETIP} dev ${MY_NEW_NETIF}
ip link add name ${MY_NEW_NETRBIDGE} type bridge
ip link set dev ${MY_NEW_NETRBIDGE} up
ip link set dev ${MY_NEW_NETIF} master ${MY_NEW_NETRBIDGE}
ip link set dev ${MY_NEW_NETIF} up
ip addr add ${MY_NEW_NETIP} dev ${MY_NEW_NETRBIDGE}
ip route add default via ${MY_NEW_NETGW}
sed -i "1s/^/nameserver ${MY_NEW_DNS1}\n/" /etc/resolv.conf
```

# Network-Manager
## Show configuration
```shell
nmcli con show
nmcli device
```

## Direct configuration
```shell
MY_NEW_CONNAME="LAN"
MY_NEW_NETIF="eth0"
MY_NEW_NETIP="10.1.1.1"
MY_NEW_NETGW="10.1.1.254"
MY_NEW_DNS1="10.1.1.254"
MY_NEW_DNS2="8.8.8.8"

nmcli con add type ethernet con-name ${MY_NEW_CONNAME} ifname ${MY_NEW_NETIF} ip4 ${MY_NEW_NETIP} gw4 ${MY_NEW_NETGW}
nmcli con mod ${MY_NEW_CONNAME} ipv4.dns "${MY_NEW_DNS1} ${MY_NEW_DNS2}"
nmcli con up ${MY_NEW_CONNAME} ifname ${MY_NEW_NETIF}
```

## Bridge configuration
```shell
MY_NEW_CONNAME="LAN"
MY_NEW_NETIF="eth0"
MY_NEW_NETRBIDGE="brkvm"
MY_NEW_NETIP="10.1.1.1"
MY_NEW_NETGW="10.1.1.254"
MY_NEW_DNS1="10.1.1.254"
MY_NEW_DNS2="8.8.8.8"

nmcli con add type bridge ifname ${MY_NEW_NETRBIDGE} ip4 ${MY_NEW_NETIP} gw4 ${MY_NEW_NETGW}
nmcli con add type bridge-slave ifname ${MY_NEW_NETIF} master ${MY_NEW_NETRBIDGE}
nmcli con mod ${MY_NEW_CONNAME} ipv4.dns "${MY_NEW_DNS1} ${MY_NEW_DNS2}"
nmcli con up bridge-${MY_NEW_NETRBIDGE}
```

## WiFi configuration
```shell
MY_NEW_CONNAME="MYWIFINET"
MY_NEW_NETIF="wlan0"
MY_NEW_SSID="MYSSID"
MY_NEW_PSK="MYPSKKEY"

rfkill unblock wlan

nmcli radio wifi on

nmcli device wifi list

nmcli device wifi connect ${MY_NEW_SSID} password ${MY_NEW_PSK}

nmcli connection add type wifi con-name ${MY_NEW_CONNAME} ifname ${MY_NEW_NETIF} ssid ${MY_NEW_SSID}
nmcli connection modify ${MY_NEW_CONNAME} wifi-sec.key-mgmt wpa-psk wifi-sec.psk ${MY_NEW_PSK}

nmcli connection up ${MY_NEW_CONNAME}
```

## Connection delete
```shell
MY_NEW_CONNAME="LAN"
nmcli connection delete ${MY_NEW_CONNAME}
```

----

# Systemd Networkd
- [Example configurations](/linux-systemd-networkd.md)

----

# Centos/Redhat native configuration
- [Example configurations](/linux-redhat-centos-network-configuration.md)

----

# Debian native configuration
- [Example configurations](/linux-debian-network-configuration.md)

