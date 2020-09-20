install
url --url https://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os/
ignoredisk --only-use=vda
rootpw --iscrypted $6$encryptedpassword
user --groups=wheel --name=user01 --password=$6$encryptedpassword --iscrypted --gecos="user01"

keyboard 'fr'
lang fr_FR
firewall --disabled
selinux --disabled
skipx
network  --bootproto=dhcp --noipv6 --activate
#network  --hostname=server01.example.com
skipx
timezone Europe/Paris --isUtc --ntpservers=195.83.132.135
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
kernel.domainname=example.com\n\
kernel.hostname=server01\n\
net.ipv4.ip_forward=1\n\
net.ipv6.conf.all.disable_ipv6=0\n\
net.ipv6.conf.default.disable_ipv6=1\n\
net.ipv6.conf.lo.disable_ipv6=0\n\
net.ipv6.conf.enp1s0.disable_ipv6=1\n\
" >> /etc/sysctl.conf
%end
