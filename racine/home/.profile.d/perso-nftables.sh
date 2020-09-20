if [ ${PERSO_ENABLED} = 1 ] ; then
 alias nftail='sudo tail -f /var/log/nftables.log  | sed -u "s/MAC[A-Z]*=[a-f0-9:]* //g" | sed -u "s/LEN=[0-9]* TOS=.* PREC=.* TTL=[0-9]* ID=[0-9]* //"  | sed -u "s/LEN=[0-9]* //" | sed -u "s/SEQ=[0-9]* .*$//" | sed -u "s/ID=[0-9]*//" | sed -u "s/kernel: \[[0-9]*.[0-9]*\] //"'

 alias nftopip='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
 alias nftopnet2='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
 alias nftopnet3='sudo cat /var/log/nftables.log | sed "s/.*\(SRC=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*\(DST=[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
 alias nftopport='sudo cat /var/log/nftables.log | sed "s/.*\(SPT=[0-9]*\).*\(DPT=[0-9]*\).*/\1\n\2/" | sort -n | uniq -c | sort -n'
fi
