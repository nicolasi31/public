**Systemd Networkd**

[[_TOC_]]

# Loopback

## /etc/systemd/network/01-lo.network

```shell
[Match]
Name=lo

[Network]
Address=127.0.0.1/8
```

----

# Local Bridge

## /etc/systemd/network/10-brwan.link

```shell
[Match]
OriginalName=brwan
Type=bridge

[Link]
Name=brwan
RequiredForOnline=no
#MTUBytes=1426
```

## /etc/systemd/network/10-brwan.netdev

```shell
[NetDev]
Name=brwan
Kind=bridge

[Bridge]
STP=on
```

## /etc/systemd/network/10-brwan.network

```shell
[Match]
Name=brwan

[Network]
LinkLocalAddressing=no
DHCP=no
Address=192.168.0.2/24
Gateway=192.168.0.254
#DNS=192.168.0.254
#DNS=8.8.8.8
#Domains=example.com
#NTP=195.83.132.135
#Metric=10
#LLDP=yes
IPForward=yes
#ConfigureWithoutCarrier=yes

[Route]
Gateway=192.168.0.254
Destination=8.8.8.8/32
```

----

# Ethernet

## /etc/systemd/network/10-enp1s0.link

```shell
[Match]
#OriginalName=enp1s0
Type=ether

[Link]
AutoNegotiation=1
Name=enp1s0
```

## /etc/systemd/network/10-enp1s0.network

```shell
[Match]
Name=enp1s0

[Network]
LinkLocalAddressing=no
Bridge=brwan
#Address=192.168.0.2/24
#Gateway=192.168.0.254
##DNS=192.168.0.254
##DNS=8.8.8.8
##Domains=example.com
##NTP=195.83.132.135
##Metric=10
#LLDP=yes
ConfigureWithoutCarrier=yes

#[Route]
#Gateway=192.168.0.254
#Destination=8.8.8.8/32
```

----

# Wifi

## /etc/systemd/network/11-wlp2s0.link

```shell
[Match]
#OriginalName=wlp2s0
Type=wlan

[Link]
#AutoNegotiation=1
Name=wlp2s0
RequiredForOnline=no
```

## /etc/systemd/network/11-wlp2s0.network

```shell
[Match]
Name=wl*

[Network]
LinkLocalAddressing=no
DHCP=no
#DHCP=ipv4
#IPv6PrivacyExtensions=true
## to use static IP uncomment these instead of DHCP
#DNS=192.168.0.254
#Address=192.168.0.12/24
#Gateway=192.168.0.254
#
#[DHCPv4]
#RouteMetric=20
```

----

# Wireguard

## /etc/systemd/network/20-wg0.link

```shell
[Match]
OriginalName=wg0
Type=wireguard

[Link]
Name=wg0
RequiredForOnline=no
```

## /etc/systemd/network/20-wg0.netdev

```shell
[NetDev]
Name=wg0
Kind=wireguard

[WireGuard]
PrivateKey=myprivatekey
ListenPort=12345

[WireGuardPeer]
PublicKey=remotepublickey
AllowedIPs=10.1.1.0/24
Endpoint=1.1.1.2:12345
PersistentKeepalive = 25
```

## /etc/systemd/network/20-wg0.network

```shell
[Match]
Name=wg0

[Network]
LinkLocalAddressing=no
Address=10.1.1.1/24
IPForward=yes
```

# KVM Bridge

## /etc/systemd/network/30-brkvm.link

```shell
[Match]
OriginalName=brkvm
Type=bridge

[Link]
Name=brkvm
RequiredForOnline=no
#MTUBytes=1426
```

## /etc/systemd/network/30-brkvm.netdev
```shell
[NetDev]
Name=brkvm
Kind=bridge

[Bridge]
STP=on
```

## /etc/systemd/network/30-brkvm.network

```shell
[Match]
Name=brkvm

[Network]
LinkLocalAddressing=no
DHCP=no
Address=10.1.2.1/24
IPForward=yes
ConfigureWithoutCarrier=yes

[Route]
Gateway=10.1.2.2
Destination=10.1.3.0/24
```

----

# Geneve

## /etc/systemd/network/40-gvkvm.link

```shell
[Match]
OriginalName=gvkvm
Type=geneve

[Link]
Name=gvkvm
RequiredForOnline=no
```

## /etc/systemd/network/40-gvkvm.netdev

```shell
[NetDev]
Name=gvkvm
Kind=geneve

[GENEVE]
Id=112
Remote=10.1.1.2
DestinationPort=23456
UDPChecksum=true
#MacLearning=true
#ARPProxy=true
TTL=30
```

## /etc/systemd/network/40-gvkvm.network

```shell
[Match]
Name=gvkvm
 
[Network]
LinkLocalAddressing=no
Bridge=brkvm
ConfigureWithoutCarrier=yes
```

