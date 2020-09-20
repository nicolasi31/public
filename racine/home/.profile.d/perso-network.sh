if [ ${PERSO_ENABLED} = 1 ] ; then

 cidr2mask () {
  # Number of args to shift, 255..255, first non-255 byte, zeroes
  set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
  [ $1 -gt 1 ] && shift $1 || shift
  echo ${1-0}.${2-0}.${3-0}.${4-0}
 }

 ipcfg () { 
  if [ $3 ]; then
   INTERFACE=$1
   IPADDR=$2
   IPADDRSANSMASK=$(echo ${IPADDR} | /usr/bin/cut -d\/ -f1)
   MASK=$(echo ${IPADDR} | /usr/bin/cut -d\/ -f2)
   GATEWAY=$3
   ip link set dev ${INTERFACE} up
   ip addr add ${IPADDRSANSMASK}/${MASK} dev ${INTERFACE}
   ip route add default via ${GATEWAY}
  else
   echo "Usage: ${FUNCNAME[0]} <interface> <ip/masq> <gateway>\n"
  fi
 }

 genwpasupplicantnetworkddhcpconfig () {
  /bin/echo "Need Sudo."
  sudo /bin/echo "Validated"
  read -e -p "WiFi device name: " -i wlp2s0 WIFIDEVICENAME
  read -e -p "SSID: " MYWIFISSID
  read -e -s -p "PSK: " MYWIFIPSK

  wpa_passphrase ${MYWIFISSID} ${MYWIFIPSK} | sudo tee -a /etc/wpa_supplicant/wpa_supplicant-${WIFIDEVICENAME}.conf > /dev/null

  read -e -p "Do you want to activate wpa_supplicant service (YES/NO)? " -i NO MYWIFISRV
  if [ ${MYWIFISRV} == "YES" ] ; then sudo systemctl enable --now wpa_suppliclant-${WIFIDEVICENAME}.conf ; fi

  read -e -p "Do you want to create systemd-networkd interface files (YES/NO)? " -i NO MYNETDFILES
  if [ ${MYNETDFILES} == "YES" ] ; then
   cat > /tmp/${WIFIDEVICENAME}.link << _EOF_
[Match]
#OriginalName=${WIFIDEVICENAME}
Type=wlan

[Link]
#AutoNegotiation=1
Name=${WIFIDEVICENAME}
RequiredForOnline=no
_EOF_

   cat > /tmp/${WIFIDEVICENAME}.network << _EOF_
[Match]
Name=${WIFIDEVICENAME}

[Network]
LinkLocalAddressing=no
DHCP=ipv4
_EOF_

   sudo mv /tmp/${WIFIDEVICENAME}.link /etc/systemd/network/
   sudo mv /tmp/${WIFIDEVICENAME}.network /etc/systemd/network/
  fi

  unset WIFIDEVICENAME MYWIFISSID MYWIFIPSK MYWIFISRV MYNETDFILES
 }

 gencentosnetworkfile () {

  CN_NETWORKD_DIR="/tmp/centosnetwork.tmp"
  SN_FILE_CREATED=0

  if [ ! -e ${CN_NETWORKD_DIR} ] ; then mkdir ${CN_NETWORKD_DIR} ; fi

  CN_CURRENTFILE="${CN_NETWORKD_DIR}/ifcfg-eth0.static"
  if [ ! -f ${CN_CURRENTFILE} ] ; then
   cat > ${CN_CURRENTFILE} << _EOF_
DEVICE=eth0
HWADDR=52:54:00:01:02:36
ONBOOT=yes
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
IPADDR=192.168.63.54
PREFIX=24
GATEWAY=192.168.63.254
DNS1=127.0.0.53
DNS2=192.168.63.254
DEFROUTE=yes
PEERROUTES=no
IPV4_FAILURE_FATAL=no
IPV6INIT=no
NAME="Connexion filaire 1"
UUID=94b13903-9fe8-3405-a133-05fd095c83a9
AUTOCONNECT_PRIORITY=-999
MTU=1400
_EOF_
  CN_FILE_CREATED=1
  else 
   /bin/echo -e "File ${CN_CURRENTFILE} already exist! Do nothing."
  fi

  CN_CURRENTFILE="${CN_NETWORKD_DIR}/ifcfg-eth0.dhcp"
  if [ ! -f ${CN_CURRENTFILE} ] ; then
   cat > ${CN_CURRENTFILE} << _EOF_
BOOTPROTO=dhcp
DEVICE=eth0
HWADDR=52:54:00:af:86:36
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
_EOF_
  CN_FILE_CREATED=1
  else 
   /bin/echo -e "File ${CN_CURRENTFILE} already exist! Do nothing."
  fi
 }

 gennetworkdfile () {

#  SN_NETWORKD_DIR="/etc/systemd/network"
  SN_NETWORKD_DIR="/tmp/networkd.tmp"
  SN_NETINTF="enp1s0"
  SN_WANSUBNET="192.168.0"
  SN_WANIP="192.168.0.2"
  SN_WANGW="192.168.0.254"
  SN_WANDNS="192.168.0.254"
  SN_WANIPLASTBYTE="$(echo ${SN_WANIP} | cut -d. -f 4)"
  SN_DOMAIN="$(hostname -d)"
  SN_NTPSRV="195.83.132.135"
  SN_DNSPERSO="192.168.63.254"
  SN_DNSGOOGLE="8.8.8.8"
  SN_SERVER2="1.2.3.4"
  SN_SERVER3="5.6.7.8"
  SN_FILE_CREATED=0

  if [ ! -e ${SN_NETWORKD_DIR} ] ; then mkdir ${SN_NETWORKD_DIR} ; fi

  ##################         loopback0          ##################

  SN_CURRENTFILE="${SN_NETWORKD_DIR}/01-lo.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=lo
 
[Network]
Address=127.0.0.1/8
_EOF_
  SN_FILE_CREATED=1
  else 
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi

  ##################           brwan            ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/10-brwan.link"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
OriginalName=brwan
Type=bridge

[Link]
Name=brwan
RequiredForOnline=no
#MTUBytes=1426
_EOF_
  else 
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/10-brwan.netdev"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[NetDev]
Name=brwan
Kind=bridge

[Bridge]
STP=on
_EOF_
  SN_FILE_CREATED=1
  else 
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/10-brwan.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=brwan

[Network]
LinkLocalAddressing=no
DHCP=no
Address=${SN_WANIP}/24
Gateway=${SN_WANGW}
#DNS=${SN_WANDNS}
#DNS=${SN_DNSPERSO}
#DNS=${SN_DNSGOOGLE}
#Domains=${SN_DOMAIN}
#NTP=${SN_NTPSRV}
#Metric=10
#LLDP=yes
IPForward=yes
#ConfigureWithoutCarrier=yes

[Route]
Gateway=${SN_WANGW}
Destination=${SN_SERVER2}/32

[Route]
Gateway=${SN_WANGW}
Destination=${SN_SERVER3}/32

[Route]
Gateway=${SN_WANGW}
Destination=${SN_DNSGOOGLE}/32
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################       ${SN_NETINTF}        ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/10-${SN_NETINTF}.link"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
#OriginalName=${SN_NETINTF}
Type=ether

[Link]
AutoNegotiation=1
Name=${SN_NETINTF}
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/10-${SN_NETINTF}.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=${SN_NETINTF}

[Network]
LinkLocalAddressing=no
Bridge=brwan
#Address=${SN_WANIP}/24
#Gateway=${SN_WANGW}
##DNS=${SN_WANDNS}
##DNS=${SN_DNSPERSO}
##DNS=${SN_DNSGOOGLE}
##Domains=${SN_DOMAIN}
##NTP=${SN_NTPSRV}
##Metric=10
#LLDP=yes
ConfigureWithoutCarrier=yes


#[Route]
#Gateway=${SN_WANGW}
#Destination=${SN_SERVER2}/32

#[Route]
#Gateway=${SN_WANGW}
#Destination=${SN_SERVER3}/32

#[Route]
#Gateway=${SN_WANGW}
#Destination=${SN_DNSGOOGLE}/32
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################          wlp2s0            ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/11-wlp2s0.link"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
#OriginalName=wlp2s0
Type=wlan

[Link]
#AutoNegotiation=1
Name=wlp2s0
RequiredForOnline=no
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/11-wlp2s0.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=wl*

[Network]
LinkLocalAddressing=no
DHCP=no
#DHCP=ipv4
#IPv6PrivacyExtensions=true
## to use static IP uncomment these instead of DHCP
#DNS=${SN_WANDNS}
#Address=${SN_WANSUBNET}.12/24
#Gateway=${SN_WANGW}
#
#[DHCPv4]
#RouteMetric=20
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################            wg0             ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/20-wg0.link"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
OriginalName=wg0
Type=wireguard

[Link]
Name=wg0
RequiredForOnline=no
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/20-wg0.netdev"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[NetDev]
Name=wg0
Kind=wireguard

[WireGuard]
PrivateKey=my_private_key
ListenPort=60001

[WireGuardPeer]
PublicKey=remote_public_key
AllowedIPs=192.168.60.0/24
Endpoint=${SN_SERVER2}:60001
PersistentKeepalive = 25
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/20-wg0.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=wg0

[Network]
LinkLocalAddressing=no
Address=192.168.60.${SN_WANIPLASTBYTE}/24
IPForward=yes
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################          brkvm86           ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/30-brkvm86.link"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
OriginalName=brkvm86
Type=bridge

[Link]
Name=brkvm86
RequiredForOnline=no
#MTUBytes=1426
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/30-brkvm86.netdev"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[NetDev]
Name=brkvm86
Kind=bridge

[Bridge]
STP=on
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################



  SN_CURRENTFILE="${SN_NETWORKD_DIR}/30-brkvm86.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=brkvm86

[Network]
LinkLocalAddressing=no
DHCP=no
Address=192.168.62.${SN_WANIPLASTBYTE}/24
IPForward=yes
ConfigureWithoutCarrier=yes

[Route]
Gateway=192.168.62.254
Destination=192.168.63.0/24
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################           gvkvm            ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/40-gvkvm.link"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
OriginalName=gvkvm
Type=geneve

[Link]
Name=gvkvm
RequiredForOnline=no
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/40-gvkvm.netdev"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[NetDev]
Name=gvkvm
Kind=geneve

[GENEVE]
Id=332
Remote=192.168.60.33
DestinationPort=60002
UDPChecksum=true
#MacLearning=true
#ARPProxy=true
TTL=30
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  SN_CURRENTFILE="${SN_NETWORKD_DIR}/40-gvkvm.network"
  if [ ! -f ${SN_CURRENTFILE} ] ; then
   cat > ${SN_CURRENTFILE} << _EOF_
[Match]
Name=gvkvm
 
[Network]
LinkLocalAddressing=no
Bridge=brkvm86
ConfigureWithoutCarrier=yes
_EOF_
  SN_FILE_CREATED=1
  else
   /bin/echo -e "File ${SN_CURRENTFILE} already exist! Do nothing."
  fi


  ##################


  if [ ${SN_FILE_CREATED} -eq 1 ] ; then 
   /bin/echo -e "File(s) created, available ${SN_NETWORKD_DIR} in directory.\nCopy them in /etc/systemd/network/ if you know what you do."
  else
   /bin/echo -e "No file created."
  fi

 }

 ##################

fi

