**Network / Reseau**

[[_TOC_]]

# Local Doc
- [linux-network-configuration.md](/linux-network-configuration.md)
- [linux-systemd-networkd.md](/linux-systemd-networkd.md)
- [linux-debian-network-configuration.md](/linux-debian-network-configuration.md)
- [linux-redhat-centos-network-configuration.md](/linux-redhat-centos-network-configuration.md)
- [linux-firewall.md](/linux-firewall.md)

----

# DNS
## Lookup
```shell
dig @8.8.8.8 any google.com
nslookup -type=any google.com 8.8.8.8
```
> Common query types: any ns mx soa
## Zone transfert
```shell
dig @ns1.google.com google.com AXFR
```

----

# rsync
```shell
rsync -avzS -e 'ssh -p 22 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' /media/temp/ user01@server02:/media/temp
```

----

# Parallel SCP / SSH / RSYNC
```shell
DESTHOSTLIST="server02 server03 server04"
parallel-scp   -l root -H "${DESTHOSTLIST}"    /tmp/temp1.txt /tmp/
parallel-ssh   -l root -H "${DESTHOSTLIST}"    "mv /tmp/temp1.txt /tmp/temp2.txt"
parallel-rsync -l root -H "${DESTHOSTLIST}"    -avzS -e "ssh -p 22 -q -x -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" -x --progress /tmp/temp1.txt /tmp
```

----

# TS client, dimension 90%
```shell
rdesktop -g 90% 192.168.1.2
```

----

# Send a file via FTP
## With WPUT
```shell
wput toto.mp3 ftp://user01@server02/"Disque dur"/Musiques/
```

## With NCFTPPUT
```shell
/usr/bin/ncftpput -R -v -u user01 server02 "Disque dur/Musiques/" toto.mp3
```

----

# Send a mail with attachment
```shell
uuencode chemin/fichier_original.txt nom_de_la_piece_jointe.txt | mailx -s titre_du_mail emailaddr1@gmail.com
(uuencode toto toto.txt ; uuencode titi titi.txt) | mailx -s "mon titre" emailaddr1@gmail.com
```

----

# tunneling ssh in background
```shell
ssh -R :2223:localhost:22 -fN 192.168.0.8
```

