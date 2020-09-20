**Network tools**

[[_TOC_]]

# Wireshark
## Remote capture on Linux server from Windows remote host
```shell
plink.exe -ssh -pw CHANGEME root@192.168.0.1 "tcpdump -ni eth0 -s 0 -w - not port 22" | "C:\Program Files\Wireshark\Wireshark.exe" -k -i -
```

# TCPDUMP
## Capture tcp syn packets, but not tcp syn/ack
```shell
sudo tcpdump -i any -n 'tcp[13] & 2 != 0' and 'tcp[13] & 16 == 0'
```

## MAC address Filter
```shell
sudo tcpdump -i enp1s0 -n ether host f4:ca:e5:48:13:2b
```

# NMAP / NPING
## NMAP: check UDP port (DNS in that case)
```shell
sudo nmap -p 53 -sU 8.8.8.8
```
> -sU: Scan UDP

## NPING: Multi ICMP check examples
```shell
sudo nping --icmp -c 5 192.168.0.44 192.168.0.49 192.168.0.43
sudo nping --icmp -c 1 192.168.0.48/30
sudo nping --icmp -c 1 192.168.0.*
sudo nping --icmp -c 1 192.168.0.40-50
```

