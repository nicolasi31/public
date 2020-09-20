#!/bin/bash

LOCALUSER="admin"
#NEWHOSTNAME="$(ip add | grep ether | tr -s ' ' | cut -d ' ' -f3 | tr -d ':' | tr '[:lower:]' '[:upper:]')"
NEWHOSTNAME="$(cat /etc/sysctl.d/01-perso.conf | grep -v ^# | grep hostname | tr -d ' ' | cut -d= -f2)"
NEWDOMAIN="$(cat /etc/sysctl.d/01-perso.conf | grep -v ^# | grep domainname | tr -d ' ' | cut -d= -f2)"
NEWIPADD="$(ip add | grep inet\  | grep -v \ lo$ | tr -s ' ' | cut -d ' ' -f 3 | cut -d\/ -f1)"

[ -f /etc/centos-release ] && {
 yum -y remove cloud-init selinux-policy selinux-policy-targeted rpm-plugin-selinux plymouth-core-libs plymouth plymouth-scripts iwl7260-firmware linux-firmware.noarch iwl1000-firmware iwl100-firmware iwl105-firmware iwl135-firmware iwl2000-firmware iwl2030-firmware iwl3160-firmware iwl3945-firmware iwl4965-firmware iwl5000-firmware iwl5150-firmware iwl6000-firmware iwl6000g2a-firmware iwl6050-firmware
 yum -y install curl wget bind-utils tcpdump yum-utils glibc-langpack-fr http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/h/haveged-1.9.8-1.el8.x86_64.rpm http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm
 yum-config-manager --nogpgcheck --setopt=BaseOS.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os --enable --save
 yum-config-manager --nogpgcheck --setopt=AppStream.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/AppStream/x86_64/os --enable --save
 yum-config-manager --nogpgcheck --setopt=extras.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/extras/x86_64/os --enable --save

 # grub2-editenv /boot/grub2/grubenv set kernelopts="root=/dev/vda1 ro console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto LANG=fr_FR.UTF-8 net.ifnames=0 biosdevname=0 ipv6.disable=0"

 cat >> /etc/default/grub << "_EOF_"
GRUB_TIMEOUT=0
GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto LANG=fr_FR.UTF-8 net.ifnames=0 biosdevname=0 ipv6.disable=0"
_EOF_
 grub2-mkconfig

 sed -i "s/\(OPTIONS=\".*\)\"$/\1 -4\"/" /etc/sysconfig/chronyd 
 systemctl restart chronyd

 systemctl disable --now rpcbind
 systemctl stop rpcbind.socket

 systemctl disable nfs-client.target
 systemctl disable nfs-convert.service
 systemctl disable remote-fs.target

 sed "s/\(^pool.*$\)/#\1/" /etc/chrony.conf
 /bin/echo -e "pool 195.83.132.135 iburst" >> /etc/chrony.conf
 systemctl restart chronyd

}

[ -f /etc/debian_version ] && {
 apt update
 apt -y install wget curl dnsutils tcpdump screen bash-completion htop qemu-guest-agent apt-transport-https
 echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8' | debconf-set-selections
 echo 'locales locales/default_environment_locale select fr_FR.UTF-8' | debconf-set-selections
 sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen ; ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
 echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections ; echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections
 dpkg-reconfigure --frontend=noninteractive tzdata ; dpkg-reconfigure --frontend=noninteractive locales

 sed -i "s/^\(deb.*$\)/#\1/" /etc/apt/sources.list
 cat > /etc/apt/sources.list.d/perso.list << "_EOF_"
deb https://mirrors.ircam.fr/pub/debian/          buster            main contrib non-free
deb https://mirrors.ircam.fr/pub/debian/          buster-updates    main contrib non-free
deb https://mirrors.ircam.fr/pub/debian/          buster-backports  main contrib non-free
deb https://mirrors.ircam.fr/pub/debian-security/ buster/updates    main contrib non-free
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
#deb https://download.docker.com/linux/debian buster stable
# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
# GNS3
#deb http://ppa.launchpad.net/gns3/ppa/ubuntu zesty main
_EOF_

 apt udpate

 cat > /etc/default/grub.d/perso.cfg << "_EOF_"
GRUB_TIMEOUT=0
GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 consoleblank=0 systemd.show_status=true time language=fr country=FR locale=fr_FR.UTF-8 net.ifnames=0 biosdevname=0 ipv6.disable=0"
_EOF_
 update-grub2

 sed -i "s/\(NTPD_OPTS='-g\)'$/\1 -4'/" /etc/default/ntp

 systemctl disable apparmor.service
 systemctl disable apt-daily.timer
 systemctl disable apt-daily-upgrade.timer
 systemctl disable cloud-config.service
 systemctl disable cloud-final.service
 systemctl disable remote-fs.target

 sed -i "s/\(^pool.*$\)/#\1/" /etc/ntp.conf 
 /bin/echo -e "server 195.83.132.135" >> /etc/ntp.conf
 systemctl restart ntp

}

wget -q --directory-prefix=/etc/profile.d/ \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-00-enabled.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-alias_and_variables.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-cat_functions.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-cisco.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-cloud-hypervisor.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-dash.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-distrib.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-firecracker.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-freebox.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-genfile.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-kvm.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-mail.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-miscfunctions.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-mm-ipradio.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-mm-iptv4sat.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-mm-iptv.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-network.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-nftables.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-per_arch.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-podcast.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-ps_and_ls_colors.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-pxe.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-sauvegarde.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-tipsdatabase.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-tipsgnome.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-tipskvm.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-tipsmultimedia.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-tipsnewinstall.sh \
 https://gitlab.com/nicolasi31/public/-/raw/master/profile.d/perso-tipswindows.sh

wget -q -O /home/${LOCALUSER}/.screenrc https://gitlab.com/nicolasi31/public/-/raw/master/.screenrc
wget -q -O /home/${LOCALUSER}/.vimrc https://gitlab.com/nicolasi31/public/-/raw/master/.vimrc

sysctl -p
/bin/echo -e "${NEWIPADD} ${NEWHOSTNAME}.${NEWDOMAIN} ${NEWHOSTNAME}" >> /etc/hosts
hostnamectl set-hostname ${NEWHOSTNAME}.${NEWDOMAIN}

/bin/echo -e "PRETTY_HOSTNAME=${NEWHOSTNAME}\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production" >> /etc/machine-info 

systemctl enable --now qemu-guest-agent

cat > /etc/rsyslog.d/01-perso.conf << "_EOF_"
:programname, contains, "kernel" -/var/log/kernel.log
& stop
:programname, contains, "systemd" -/var/log/systemd.log
& stop
:programname, contains, "systemd-logind" -/var/log/systemd-logind.log
& stop
:programname, contains, "systemd-journald" -/var/log/systemd-journald.log
& stop
:programname, contains, "systemd-resolved" -/var/log/systemd-resolved.log
& stop
:programname, contains, "rsyslogd" -/var/log/rsyslogd.log
& stop
:programname, contains, "chronyd" -/var/log/chronyd.log
& stop
:programname, contains, "dracut" -/var/log/dracut.log
& stop
:programname, contains, "rngd" -/var/log/rngd.log
& stop
:programname, contains, "augenrules" -/var/log/augenrules.log
& stop
:programname, contains, "NetworkManager" -/var/log/NetworkManager.log
& stop
:programname, contains, "named" -/var/log/named.log
& stop
:programname, contains, "dhcpd" -/var/log/dhcpd.log
& stop
:programname, contains, "in.tftpd" -/var/log/tftpd.log
& stop
_EOF_

systemctl restart rsyslog

