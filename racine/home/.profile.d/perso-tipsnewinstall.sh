if [ ${PERSO_ENABLED} = 1 ] ; then
 tipsnewinstall () {
 echo '
MY_NEW_HOSTNAME="newserver"
MY_NEW_DOMAIN="mydomain.net"
MY_NEW_NETIF="eth0"
MY_NEW_CONNAME="LAN"
MY_NEW_NETIP="10.71.88.100/24"
MY_NEW_NETRBIDGE="brwan"
MY_NEW_NETGW="10.71.88.254"
MY_NEW_DNS1="10.71.88.254"
MY_NEW_DNS2="10.71.86.252"
MY_FILE_SYSCTL="/etc/sysctl.conf"
MY_FILE_TSYNCD="/etc/systemd/timesyncd.conf"
MY_FILE_RESOLVD="/etc/systemd/resolved.conf"
MY_FILE_SSHD="/etc/ssh/sshd_config"
MY_FILE_HOSTS="/etc/hosts"

###      Hosts file update      ###
sed -i "s/\(127.0.0.1 localhost \).*/\1${MY_NEW_HOSTNAME} ${MY_NEW_HOSTNAME}.${MY_NEW_DOMAIN}/g" ${MY_FILE_HOSTS}

###    Sysctl configuration     ###
sed -i "s/\(kernel.hostname *= *\).*/\1${MY_NEW_HOSTNAME}/" ${MY_FILE_SYSCTL}
sed -i "s/\(kernel.domainname *= *\).*/\1${MY_NEW_DOMAIN}/" ${MY_FILE_SYSCTL}
sed -i "s/\(.*\)eth0\(.*\)/\1${MY_IFACE}\2/g" ${MY_FILE_SYSCTL}
sed -i "s/\(.*\)ens3\(.*\)/\1${MY_IFACE}\2/g" ${MY_FILE_SYSCTL}
sysctl -p

###   Language configuration    ###
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8" | debconf-set-selections ;
echo "locales locales/default_environment_locale select fr_FR.UTF-8" | debconf-set-selections ;
sed -i "s/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen ;
dpkg-reconfigure --frontend=noninteractive locales ;

### Time and Date configuration ###
ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime ;
echo "tzdata tzdata/Areas select Europe" | debconf-set-selections ;
echo "tzdata tzdata/Zones/Europe select Paris" | debconf-set-selections ;
dpkg-reconfigure --frontend=noninteractive tzdata

###    OpenSSH configuration    ###
sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1any/" ${MY_FILE_SSHD}
dpkg-reconfigure --frontend=noninteractive openssh-server
systemctl restart sshd

###    Postfix configuration    ###
postconf -e "mydestination = localhost, localhost.localdomain, ${MY_NEW_HOSTNAME}, ${MY_NEW_HOSTNAME}.${MY_NEW_DOMAIN}"
postconf -e "inet_protocols=ipv4"

###   Resolved configuration    ###
sed -i "s/^#\{0,1\}\(DNS=\).*/\1${MY_DNS_NEW1}/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(FallbackDNS=\).*/\1${MY_DNS_NEW2}/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(Domains=\).*/\1${MY_NEW_DOMAIN}/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(LLMNR=\).*/\1no/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(MulticastDNS=\).*/\1no/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(DNSSEC=\).*/\1no/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(DNSOverTLS=\).*/\1no/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(DNSStubListener=\).*/\1no/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(Cache=\).*/\1yes/" ${MY_FILE_RESOLVD}
sed -i "s/^#\{0,1\}\(ReadEtcHosts=\).*/\1yes/" ${MY_FILE_RESOLVD}
systemctl restart systemd-resolved

###   Timesyncd configuration   ###
sed -i "s/^#\{0,1\}\(NTP=\).*/\1${MY_NTP_NEW1}/" ${MY_FILE_TSYNCD}
sed -i "s/^#\{0,1\}\(FallbackNTP=\).*/\1${MY_NTP_NEW2}/" ${MY_FILE_TSYNCD}
timedatectl set-timezone Europe/Paris
timedatectl set-ntp 1
systemctl restart systemd-timesyncd

###    Network configuration    ###
nmcli con show
nmcli con add type ethernet con-name ${MY_NEW_CONNAME} ifname ${MY_NEW_NETIF} ip4 ${MY_NEW_NETIP} gw4 ${MY_NEW_NETGW}
nmcli con mod ${MY_NEW_CONNAME} ipv4.dns "${MY_NEW_DNS1} ${MY_NEW_DNS2}"
nmcli con up ${MY_NEW_CONNAME} ifname ${MY_NEW_NETIF}

nmcli con add type bridge ifname ${MY_NEW_NETRBIDGE} ip4 ${MY_NEW_NETIP} gw4 ${MY_NEW_NETGW}
nmcli con add type bridge-slave ifname ${MY_NEW_NETIF} master ${MY_NEW_NETRBIDGE}
nmcli con up bridge-${MY_NEW_NETRBIDGE}
nmcli connection delete System\ ${MY_NEW_NETIF}

ip addr del ${MY_NEW_NETIP} dev ${MY_NEW_NETIF}
ip link add name ${MY_NEW_NETRBIDGE} type bridge
ip link set dev ${MY_NEW_NETRBIDGE} up
ip link set dev ${MY_NEW_NETIF} master ${MY_NEW_NETRBIDGE}
ip link set dev ${MY_NEW_NETRBIDGE} up
ip link set dev ${MY_NEW_NETIF} up
ip addr add ${MY_NEW_NETIP} dev ${MY_NEW_NETRBIDGE}
ip route add default via ${MY_NEW_NETGW}
sed -i "1s/^/nameserver ${MY_NEW_DNS1}\n/" /etc/resolv.conf

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
'

 }
fi

