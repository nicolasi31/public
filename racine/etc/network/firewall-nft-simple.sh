#!/bin/bash

#WANINT="{ eth0, ens3, enp1s0 }"
WANINT="{ wlp2s0 }"

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

nft add rule inet filter OUTPUT oifname @wanif tcp flags \& \(syn \| ack\) == syn \| ack log flags all prefix \"TCPSYNACK: \" counter comment 'TCPSYNACK'

alias nftopip='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
alias nftopnet2='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
alias nftopnet3='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
alias nftopport='sudo cat /var/log/nftables.log | sed "s/.*\(SPT=[0-9]*\).*\(DPT=[0-9]*\).*/\1\n\2/" | sort -n | uniq -c | sort -n'

