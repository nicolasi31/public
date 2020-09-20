install
url --url http://129.102.1.37/pub/CentOS/8/BaseOS/x86_64/os/
repo --name="BaseOS" --baseurl=http://129.102.1.37/pub/CentOS/8/BaseOS/x86_64/os/
ignoredisk --only-use=vda
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=vda
autopart --type=plain
clearpart --all --initlabel --drives=vda
text
rootpw --iscrypted $6$lk3W1IOjr7pBbkYm$jHv1PWqqj.aReVb.7offzHxOJFhbwhIfUxmP8RSqgmiiDIDlRwPYe4WVqtJKeucFdpV.rAAsVw5hCateWB8p9.
user --groups=wheel --name=nicolas --password=$6$WucbQEcgt/KgD6eB$TtrBGaLJflNkBU8lO4W4mM5Aisp4jGgO9ryVN6ffjD/rgp4YFJxxZ0J.UHFgr.4Y8fszeeRzhHyG/qvqzWJFE1 --iscrypted --gecos="nicolas"
keyboard 'fr'
lang fr_FR
firewall --disabled
selinux --disabled
skipx
network --bootproto=dhcp --noipv6 --activate
timezone Europe/Paris --isUtc --ntpservers=195.83.132.135
%packages
#@base
#@core
#chrony
#kexec-tools
bash-completion
yum-utils
%end
%addon com_redhat_kdump --enable --reserve-mb='auto'
%end
%post
echo -e "\
kernel.domainname=example.com\n\
#kernel.hostname=centosvm1\n\
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
" >> /home/nicolas/.bashrc
echo -e "\
192.168.0.100 vmtest01 vmtest01.example.com\n\
192.168.0.252 pxehv pxehv.example.com\n\
192.168.0.254 freebox freebox.example.com\n\
" >> /etc/hosts
yum-config-manager --nogpgcheck --enable --save --setopt=BaseOS.baseurl=http://129.102.1.37/pub/CentOS/8/BaseOS/x86_64/os
yum-config-manager --nogpgcheck --enable --save --setopt=AppStream.baseurl=http://129.102.1.37/pub/CentOS/8/AppStream/x86_64/os
yum-config-manager --nogpgcheck --enable --save --setopt=extras.baseurl=http://129.102.1.37/pub/CentOS/8/extras/x86_64/os
yum -y install http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm
yum -y install http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/h/haveged-1.9.8-1.el8.x86_64.rpm
yum -y install http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm
systemctl enable --now haveged
%end
reboot
