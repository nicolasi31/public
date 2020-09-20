**Debian Network Configuration**

[[_TOC_]]

# Loopback

## /etc/network/interfaces.d/00-lo.conf 

```shell
allow-hotplug lo
iface lo inet loopback
```

# Ethernet

## /etc/network/interfaces.d/01-eth0.conf 

```shell
allow-hotplug eth0
iface eth0 inet static
 address 192.168.0.2/24
 gateway 192.168.0.254
 dns-nameservers 192.168.0.254 8.8.8.8
 dns-domain example.com
 dns-search example.com
# post-up /etc/network/firewall.sh start $IFACE $IF_ADDRESS
# post-down /etc/network/firewall.sh stop
```

----

# Wifi

## /etc/network/interfaces.d/02-wlp2s0.conf 

```shell
# To activate : sudo ifup wlp2s0=wifiappart
allow-hotplug wifiappart
iface wifiappart inet static
 address 192.168.0.2/24
 gateway 192.168.0.254
 dns-nameservers 192.168.0.254 8.8.8.8
 dns-domain example.com
 dns-search example.com
 post-up /etc/network/firewall.sh start $IFACE $IF_ADDRESS
 post-down /etc/network/firewall.sh stop
 wpa-driver wext
 wpa-key-mgmt WPA-PSK
 wpa-group CCMP TKIP
 wpa-proto RSN WPA
 wpa-scan-ssid 1
 wpa-ssid MYSSID
 wpa-psk mypskkey

# To activate : sudo ifup wlp2s0=wifiappartdhcp
allow-hotplug wifiappartdhcp
iface wifiappartdhcp inet dhcp
 wpa-driver wext
 wpa-key-mgmt WPA-PSK
 wpa-group CCMP TKIP
 wpa-proto RSN WPA
 wpa-scan-ssid 1
 wpa-ssid MYSSID
 wpa-psk mypskkey
```

----

# Wireguard

## /etc/network/interfaces.d/10-wg.conf 

```shell
auto wg0
#allow-hotplug wg0
iface wg0 inet static
 address 10.1.1.2/24
 pre-up /bin/ip link add $IFACE type wireguard
 pre-up /usr/bin/wg setconf $IFACE /etc/wireguard/$IFACE.conf
# post-up /bin/ping -c 3 10.1.1.1
 post-down /bin/ip link del $IFACE
```

## /etc/wireguard/wg0.conf 
```shell
[Interface]
PrivateKey = myprivatekey
ListenPort = 12345

# ZOTAC
[Peer]
Endpoint = 1.1.1.1:12345
PublicKey = remotepublickey
AllowedIPs = 10.1.1.0/24
```

----

# KVM Bridge

## /etc/network/interfaces.d/10-brkvm.conf 

```shell
auto brkvm
#allow-hotplug brkvm
iface brkvm inet static
 address 10.1.2.2/24
 bridge_waitport 0
# bridge_fd 0
 bridge_ports vxkvm
 bridge_stp on
 pre-up ip link add brkvm type bridge stp_state 1 || true
 up ip link add vxkvm type vxlan id 332 dstport 12345 remote 10.1.1.1 local 10.1.1.2 || true
 up ip link set vxkvm up || true
 up ip link set brkvm up || true
 up ip link set vxkvm master brkvm || true
 post-up /sbin/ethtool -K vxkvm tx off || true
 post-up /sbin/ip route add 10.1.3.0/24 via 10.1.2.254
 down ip link set vxkvm down || true
 post-down ip link del vxkvm || true
 post-down ip link del brkvm || true
# mtu 1472
```

