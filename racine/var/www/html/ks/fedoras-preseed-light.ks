install
url --url="http://192.168.0.252/mount/fedoras/"
text

keyboard 'us'
lang en_US
firewall --disabled
selinux --disabled
skipx
network  --bootproto=dhcp --device=eth0 --noipv6 --activate
network  --hostname=server01.example.com
rootpw --iscrypted $6$encryptedpassword
services --enabled="chronyd"
skipx
timezone Europe/Paris --isUtc --ntpservers=195.83.132.135
user --groups=wheel --name=user01 --password=$6$encryptedpassword
%packages
@base
@core
chrony
kexec-tools
screen
%end
#%addon com_redhat_kdump --enable --reserve-mb='auto'
#%end
%post
mkdir /home/user01/.ssh /root/.ssh
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcRI48S user01@station01" >> /tmp/authorized_keys
cp /tmp/authorized_keys /home/user01/.ssh/
cp /tmp/authorized_keys /root/.ssh/
rm -f /tmp/authorized_keys
chown -R user01 /home/user01/
echo -e "\
kernel.domainname=example.com\n\
kernel.hostname=server01\n\
net.ipv4.ip_forward=1\n\
net.ipv6.conf.all.disable_ipv6=0\n\
net.ipv6.conf.default.disable_ipv6=1\n\
net.ipv6.conf.lo.disable_ipv6=0\n\
net.ipv6.conf.eth0.disable_ipv6=1\n\
" >> /etc/sysctl.conf
echo -e "\
set completion-ignore-case on\n\
set +o noclobber\n\
shopt -s checkwinsize\n\
shopt -s histappend\n\
export HISTCONTROL=ignoreboth\n\
export HISTFILE=${HOME}/.bash_history\n\
export HISTFILESIZE=2000\n\
export HISTSIZE=1000\n\
export LIBVIRT_DEFAULT_URI='qemu:///system'\n\
stty werase undef\n\
bind '\C-w:unix-filename-rubout'\n\
alias la='\ls -a --tabsize=0 --literal --color=auto --show-control-chars --human-readable'\n\
alias ll='\ls -al --tabsize=0 --literal --color=auto --show-control-chars --human-readable'\n\
alias l='\ls -a1 --tabsize=0 --literal --color=auto --show-control-chars --human-readable'\n\
alias lrt='\ls -art --tabsize=0 --literal --color=auto --show-control-chars --human-readable'\n\
alias llrt='\ls -alrt --tabsize=0 --literal --color=auto --show-control-chars --human-readable'\n\
alias battery='/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0'\n\
alias myip='/usr/bin/w3m -dump https://wtfismyip.com/text'\n\
alias myip2='/usr/bin/dig +short myip.opendns.com @resolver1.opendns.com'\n\
alias ssaver='sleep 1 ; DISPLAY=:0.0 xset dpms force off'\n\
alias dateshort='echo `/bin/date +%Y-%m-%d_-_%Hh%Mm%S`'\n\
" >> /tmp/.bashrc
cat /tmp/.bashrc >> /home/user01/.bashrc
cat /tmp/.bashrc >> /root/.bashrc
rm -f /tmp/.bashrc
echo -e "\
192.168.0.100 server01 server01.example.com\n\
192.168.0.252 pxevm pxevm.example.com\n\
192.168.0.254 router router.example.com\n\
" >> /etc/hosts
%end

