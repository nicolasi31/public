install
url --url https://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os/
ignoredisk --only-use=vda
rootpw --iscrypted $6$lk3W1IOjr7pBbkYm$jHv1PWqqj.aReVb.7offzHxOJFhbwhIfUxmP8RSqgmiiDIDlRwPYe4WVqtJKeucFdpV.rAAsVw5hCateWB8p9.
user --groups=wheel --name=nicolas --password=$6$WucbQEcgt/KgD6eB$TtrBGaLJflNkBU8lO4W4mM5Aisp4jGgO9ryVN6ffjD/rgp4YFJxxZ0J.UHFgr.4Y8fszeeRzhHyG/qvqzWJFE1 --iscrypted --gecos="nicolas"

keyboard 'fr'
lang fr_FR
firewall --disabled
selinux --disabled
skipx
network  --bootproto=dhcp --noipv6 --activate
#network  --hostname=centosvm1.example.com
skipx
timezone Europe/Paris --isUtc --ntpservers=ntp.univ-angers.fr
%packages
@base
@core
chrony
kexec-tools
screen
%end
%addon com_redhat_kdump --enable --reserve-mb='auto'
%end
%post
echo -e "\
kernel.domainname=mydomain.org\n\
kernel.hostname=centosvm1\n\
net.ipv4.ip_forward=1\n\
net.ipv6.conf.all.disable_ipv6=0\n\
net.ipv6.conf.default.disable_ipv6=1\n\
net.ipv6.conf.lo.disable_ipv6=0\n\
net.ipv6.conf.enp1s0.disable_ipv6=1\n\
" >> /etc/sysctl.conf
%end
