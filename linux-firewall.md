**Linux Firewall Tips and Tricks**

[[_TOC_]]

# NFtables configuration
```shell
WANINT="{ eth0, ens3, enp1s0 }"

sysctl -w net.ipv4.ip_forward=1

echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

if [ -e /proc/sys/net/ipv4/conf/all/rp_filter ] ; then
  for filtre in /proc/sys/net/ipv4/conf/*/rp_filter ; do echo 0 > $filtre ; done
fi

nft flush ruleset
nft add table inet filter
nft add table ip nat
nft add set inet filter natedlan { type ipv4_addr\; flags interval\; }
nft add element inet filter natedlan { 192.168.1.0/24 }
nft add chain inet filter INPUT { type filter hook input priority 0 \; policy drop \; }
nft add rule inet filter INPUT counter iifname lo accept counter comment 'Localhost'
nft add rule inet filter INPUT counter ct state related,established counter accept comment 'Established'
nft add chain inet filter OUTPUT { type filter hook output priority 0 \; policy accept \; }
nft add chain inet filter FORWARD { type filter hook forward priority 0 \; policy drop \; }

nft add rule inet filter FORWARD counter ip saddr @natedlan iifname ${WANINT} counter accept comment 'NAT LAN'
nft add rule inet filter FORWARD counter ip daddr @natedlan oifname ${WANINT} ct state related,established counter accept comment 'NAT LAN'
nft add set ip nat natedlan { type ipv4_addr\; flags interval\; }
nft add element ip nat natedlan { 192.168.1.0/24 }
nft add chain ip nat prerouting { type nat hook prerouting priority 0 \; }
nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }
nft add rule nat postrouting counter ip saddr @natedlan oifname ${WANINT} counter masquerade comment 'NAT LAN'

nft add set inet filter allowedremotenet { type ipv4_addr\; flags interval\; }
nft add element inet filter allowedremotenet { 192.168.2.0/24 }
nft add set     inet filter allowedports { type inet_service\; flags interval\; }
nft add element inet filter allowedports { 80, 443, 10240-10300 }
nft add rule inet filter INPUT ip saddr @allowedremotenet tcp dport @allowedports counter accept comment 'allowed input'

nft add rule inet filter OUTPUT oifname $wanif tcp flags \& \(syn \| ack\) == syn \| ack log flags all prefix \"TCPSYNACK: \" counter comment 'TCPSYNACK'

alias nftopip='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
alias nftopnet2='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
alias nftopnet3='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
alias nftopport='sudo cat /var/log/nftables.log | sed "s/.*\(SPT=[0-9]*\).*\(DPT=[0-9]*\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
```
----
# IPtables configuration
```shell
MONLAN="10.0.0.0/8"
MONIPPUBLIQUE="1.1.1.1"
WAN_IFACE="brwan"

modprobe ip_tables
modprobe nf_nat_ftp
modprobe nf_nat_irc
modprobe iptable_filter
modprobe iptable_mangle
modprobe iptable_nat
modprobe ipt_owner

ip6tables -F ; ip6tables -t nat -F ; ip6tables -t mangle -F
ip6tables -X ; ip6tables -t nat -X ; ip6tables -t mangle -X
ip6tables -P INPUT DROP ; ip6tables -P OUTPUT DROP ; ip6tables -P FORWARD DROP

iptables -F ; iptables -t nat -F ; iptables -t mangle -F
iptables -X ; iptables -t nat -X ; iptables -t mangle -X
iptables -P INPUT DROP ; iptables -P OUTPUT ACCEPT ; iptables -P FORWARD DROP

iptables -A INPUT -i lo -j ACCEPT -m comment --comment "accept localhost"
iptables -A INPUT -i $WAN_IFACE -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT -m comment --comment "accept established session"

iptables -A INPUT -j LOG --log-level warning --log-prefix 'DROP : ' -p tcp -m multiport --dports 0:136,140:630,632:1023 -m comment --comment "tcp priv"

iptables -A FORWARD -j ACCEPT -i $WAN_IFACE -s $MONLAN -m comment --comment "MASQUERADE"
iptables -A FORWARD -j ACCEPT -o $WAN_IFACE -d $MONLAN -m conntrack --ctstate RELATED,ESTABLISHED -m comment --comment "MASQUERADE"
iptables -t nat -A POSTROUTING -j MASQUERADE -s $MONLAN ! -d $MONLAN -m comment --comment "MASQUERADE"

iptables -t nat -A POSTROUTING -o $WAN_IFACE ! -d $MONLAN -j SNAT --to $MONIPPUBLIQUE -m comment --comment "Source NAT en $MONIPPUBLIQUE"

iptables -t mangle -A POSTROUTING -o $KVM_INT -p udp -m udp --dport 68 -j CHECKSUM --checksum-fill

iptables -L -v -n ; iptables -L -v -n -t nat ; iptables -L -v -n -t mangle
ip6tables -L -v -n ; ip6tables -L -v -n -t nat ; ip6tables -L -v -n -t mangle
```

----
# Firewalld configuration
```shell
# Check firewall state :
firewall-cmd --state

# Get zones list :
firewall-cmd --get-zones

# Get services list :
firewall-cmd --get-services

# List information for all zones. Only partial output is displayed :
firewall-cmd --list-all-zones

# List information for the 'public' zone. Only partial output is displayed :
firewall-cmd --zone=public --list-all

# List allowed services for the 'public' zone :
firewall-cmd --zone=public --list-services

# Get default zone :
firewall-cmd --get-default-zone

# Set 'public' as default zone :
firewall-cmd --set-default-zone=public

# List active zones :
firewall-cmd --get-active-zones

# Allow tcp/8080 and tcp/7000-8000 range ports in the 'public' zone :
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=7000-8000/tcp

# Close tcp/8080 and tcp/7000-8000 range ports in the 'public' zone :
firewall-cmd --zone=public --remove-port=8080/tcp
firewall-cmd --zone=public --remove-port=7000-8000/tcp

# Allow http service in the 'public' zone :
firewall-cmd --zone=public --add-service=http

# Close http service in the 'public' zone :
firewall-cmd --zone=public --remove-service=http

# Check if http service allowed in the 'public' zone :
firewall-cmd --zone=public --query-service=http

# Reload configuration :
firewall-cmd --reload
```
