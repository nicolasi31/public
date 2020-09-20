if [ ${PERSO_ENABLED} = 1 ] ; then
 tipskvm () {
cat > /dev/stdout << "_EOF_"
virsh -q destroy centos8vm ; virsh -q undefine centos8vm --remove-all-storage
virt-builder centos-8.0 --hostname centos8vm.$(hostname -d) \
 -o "$(virsh pool-dumpxml default  | grep path | cut -d\> -f2 | cut -d\< -f1)/centos8vm.qcow2" --size 20G --format qcow2 \
 --uninstall cloud-init,selinux-policy,selinux-policy-targeted,rpm-plugin-selinux,plymouth-core-libs,plymouth,plymouth-scripts,iwl7260-firmware,linux-firmware.noarch \
 --uninstall iwl1000-firmware,iwl100-firmware,iwl105-firmware,iwl135-firmware,iwl2000-firmware,iwl2030-firmware,iwl3160-firmware,iwl3945-firmware \
 --uninstall iwl4965-firmware,iwl5000-firmware,iwl5150-firmware,iwl6000-firmware,iwl6000g2a-firmware,iwl6050-firmware \
 --install bash-completion,yum-utils,glibc-langpack-fr \
 --run-command "yum-config-manager --nogpgcheck --setopt=BaseOS.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os --enable --save" \
 --run-command "yum-config-manager --nogpgcheck --setopt=AppStream.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/AppStream/x86_64/os --enable --save" \
 --run-command "yum-config-manager --nogpgcheck --setopt=extras.baseurl=https://mirrors.ircam.fr/pub/CentOS/8/extras/x86_64/os --enable --save" \
 --install https://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/h/haveged-1.9.8-1.el8.x86_64.rpm \
 --install https://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm \
 --install https://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm \
 --root-password password:CHANGEME --run-command "useradd -m -g 100 -G wheel -s /bin/bash -p '' ${USER:-${USERNAME}}" --password ${USER:-${USERNAME}}:password:CHANGEME \
 --ssh-inject ${USER:-${USERNAME}}:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub --ssh-inject root:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub \
 --run-command "echo -e 'kernel.domainname=$(hostname -d)\nkernel.hostname=centos8vm\nnet.ipv6.conf.enp1s0.disable_ipv6=1' > /etc/sysctl.d/10-perso.conf" \
 --run-command 'sed -i "s/timeout=5/timeout=0/" /boot/grub2/grub.cfg ; sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config' \
 --run-command "echo -e 'PRETTY_HOSTNAME=centos8vm\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production' > /etc/machine-info ; echo centos8vm > /etc/hostname" \
 --run-command 'sed -i "s/\(^OPTIONS=.\).*\(.\)$/\1-4\2/" /etc/sysconfig/chronyd' \
 --firstboot-command "systemctl disable firewalld.service ; localectl set-locale LANG=fr_FR.utf8 ; localectl set-keymap fr" \
 --firstboot-command "sleep 5 ; echo 'IP addr: '\$(ip addr show enp1s0 | grep inet\  | tr -s \" \" | cut -d\  -f3 | cut -d\/ -f1 ) >> /etc/issue" \
 --firstboot-command "echo 'IP addr: '\$(ip addr show enp1s0 | grep inet\  | tr -s \" \" | cut -d\  -f3 | cut -d\/ -f1 ) >> /etc/issue.net" \
 --firstboot-command 'echo "$(ip addr show enp1s0 | grep inet\  | tr -s " " | cut -d\  -f3 | cut -d\/ -f1 ) centos8vm.$(hostname -d) centos8vm" >> /etc/hosts'
virt-copy-in -a "$(virsh pool-dumpxml default  | grep path | cut -d\> -f2 | cut -d\< -f1)/centos8vm.qcow2" ${HOME}/.profile.d/perso*.sh /etc/profile.d/
virt-install --connect qemu:///system --virt-type kvm --hvm --import --boot menu=off,useserial=on --noautoconsole \
 --name centos8vm --os-type=linux --os-variant=centos8 \
 --cpu mode=host-passthrough --vcpus 2 --ram 4096 \
 --video none --graphics none --sound none --controller usb,model=none \
 --disk "$(virsh -q pool-refresh default ; virsh vol-path centos8vm.qcow2 --pool default)",format=qcow2,bus=virtio \
 --network=network:routed122,model=virtio,mac=52:54:00:00:7A:65,target=centos8vm \
 --memballoon virtio \
 --channel unix,mode=bind,path=/var/lib/libvirt/qemu/centos8vm.agent,target_type=virtio,name=org.qemu.guest_agent.0
virsh console centos8vm

###################

virsh -q destroy debian10vm ; virsh -q undefine debian10vm --remove-all-storage
virt-builder debian-10 --hostname debian10vm.$(hostname -d) \
 -o "$(virsh pool-dumpxml default  | grep path | cut -d\> -f2 | cut -d\< -f1)/debian10vm.qcow2" --size 20G --format qcow2 \
 --uninstall libpython-stdlib,libpython2-stdlib,libpython2.7-minimal,libpython2.7-stdlib,python-minimal,python2,python2-minimal,python2.7,python2.7-minimal \
 --uninstall cloud-init,firmware-linux-free --update --install screen,bash-completion,sudo,htop,qemu-guest-agent,apt-transport-https \
 --root-password password:CHANGEME --run-command "useradd -m -g 100 -G sudo -s /bin/bash -p '' ${USER:-${USERNAME}}" --password ${USER:-${USERNAME}}:password:CHANGEME \
 --ssh-inject ${USER:-${USERNAME}}:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub --ssh-inject root:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub \
 --run-command "echo 'kernel.domainname=$(hostname -d)\nkernel.hostname=debian10vm\nnet.ipv6.conf.enp1s0.disable_ipv6=1' >> /etc/sysctl.d/10-perso.conf " \
 --run-command 'dpkg-reconfigure --frontend=noninteractive openssh-server ; sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config' \
 --run-command "sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub ; sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=.*\)\"$/\1 3\"/' /etc/default/grub ; update-grub2" \
 --run-command "/bin/echo -e 'PRETTY_HOSTNAME=debian10vm\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production' > /etc/machine-info ; echo debian10vm > /etc/hostname" \
 --run-command "sed -i 's/ens2/enp1s0/' /etc/network/interfaces ; systemctl enable networking" \
 --run-command "sed -i 's/http:\/\/deb.debian.org/https:\/\/mirrors.ircam.fr\/pub/' /etc/apt/sources.list" \
 --run-command "sed -i 's/http:\/\/security.debian.org/https:\/\/mirrors.ircam.fr\/pub/' /etc/apt/sources.list" \
 --run-command "echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8' | debconf-set-selections ;
   echo 'locales locales/default_environment_locale select fr_FR.UTF-8' | debconf-set-selections ;
   sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen ; ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime ;
   echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections ; echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections ;
   dpkg-reconfigure --frontend=noninteractive tzdata ; dpkg-reconfigure --frontend=noninteractive locales" \
 --firstboot-command 'sed -i "s/\(^127.0.1.1.*$\)/#\1/" /etc/hosts' \
 --firstboot-command "sleep 5 ; echo 'IP addr: '\$(ip addr show enp1s0 | grep inet\  | tr -s \" \" | cut -d\  -f3 | cut -d\/ -f1 ) >> /etc/issue" \
 --firstboot-command "echo 'IP addr: '\$(ip addr show enp1s0 | grep inet\  | tr -s \" \" | cut -d\  -f3 | cut -d\/ -f1 ) >> /etc/issue.net" \
 --firstboot-command 'echo "$(ip addr show enp1s0 | grep inet\  | tr -s " " | cut -d\  -f3 | cut -d\/ -f1 ) debian10vm.$(hostname -d) debian10vm" >> /etc/hosts'
virt-copy-in -a "$(virsh pool-dumpxml default  | grep path | cut -d\> -f2 | cut -d\< -f1)/debian10vm.qcow2" ${HOME}/profile.d/perso-*sh /etc/profile.d/
virt-install --connect qemu:///system --virt-type kvm --hvm --import --boot menu=off,useserial=on --noautoconsole \
 --name debian10vm --os-type=linux --os-variant=debian10 \
 --cpu mode=host-passthrough --vcpus 2 --ram 4096 \
 --video none --graphics none --sound none --controller usb,model=none \
 --disk "$(virsh -q pool-refresh default ; virsh vol-path debian10vm.qcow2 --pool default)",format=qcow2,bus=virtio \
 --network=network:routed122,model=virtio,mac=52:54:00:00:7A:66,target=debian10vm \
 --memballoon virtio \
 --channel unix,mode=bind,path=/var/lib/libvirt/qemu/debian10vm.agent,target_type=virtio,name=org.qemu.guest_agent.0
virsh console debian10vm

###################

wget -q -O /media/donnees/virtualisation/bin/alpine-make-vm-image https://raw.githubusercontent.com/alpinelinux/alpine-make-vm-image/v0.6.0/alpine-make-vm-image ; \
chmod +x /media/donnees/virtualisation/bin/alpine-make-vm-image ; \
virsh destroy alpinevm ; virsh undefine alpinevm --remove-all-storage ; \
sudo /media/donnees/virtualisation/bin/alpine-make-vm-image -f qcow2 -b v3.12 -s 20G -p "screen sudo bash bash-completion shadow" -t /media/donnees/virtualisation/images/alpinevm.qcow2 ; \
sudo chown ${USER:-${USERNAME}}:users /media/donnees/virtualisation/images/alpinevm.qcow2 ; \
if [ ! -d /tmp/alpine ] ; then mkdir /tmp/alpine/ ; fi ; \
/bin/echo -e "rc-update add networking\nrc-service networking restart\nsetup-hostname alpinevm\nsetup-timezone -z Europe/Paris\nsetup-keymap fr fr\nsetup-dns -d $(hostname -d) -n 192.168.122.2\nusermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' root" > /tmp/alpine/alpine-vminstall.sh ; \
chmod +x /tmp/alpine/alpine-vminstall.sh ; \
/bin/echo -e "auto lo\niface lo inet loopback\nauto eth0\niface eth0 inet dhcp\n hostname alpinevm" > /tmp/alpine/interfaces ; \
/bin/echo -e "kernel.domainname=$(hostname -d)\nkernel.hostname=alpinevm\nnet.ipv4.ip_forward=1\nnet.ipv6.conf.all.disable_ipv6=0\nnet.ipv6.conf.default.disable_ipv6=1\nnet.ipv6.conf.lo.disable_ipv6=0\nnet.ipv6.conf.eth0.disable_ipv6=1" > /tmp/alpine/10-perso.conf ; \
/bin/echo -e "SERIAL ttyS0 115200\nDEFAULT menu.c32\nPROMPT 0\nMENU TITLE Alpine/Linux Boot Menu\nMENU HIDDEN\nMENU AUTOBOOT Alpine will be booted automatically in # seconds.\nTIMEOUT 1\nLABEL virt\n  MENU LABEL Linux virt\n  LINUX vmlinuz-virt\n  INITRD initramfs-virt\n  APPEND root=/dev/vda modules=ext4 console=ttyS0 time\n\nMENU SEPARATOR\n" > /tmp/alpine/extlinux.conf ; \
virt-copy-in -a /media/donnees/virtualisation/images/alpinevm.qcow2 /tmp/alpine/alpine-vminstall.sh /root/ ; \
virt-copy-in -a /media/donnees/virtualisation/images/alpinevm.qcow2 /tmp/alpine/interfaces /etc/network/ ; \
virt-copy-in -a /media/donnees/virtualisation/images/alpinevm.qcow2 /tmp/alpine/10-perso.conf /etc/sysctl.d/ ; \
virt-copy-in -a /media/donnees/virtualisation/images/alpinevm.qcow2 /tmp/alpine/extlinux.conf /boot/ ; \
virt-install --connect qemu:///system --virt-type kvm --hvm --boot hd,menu=off,useserial=on --noautoconsole \
 --name alpinevm --os-type=linux --os-variant=alpinelinux3.8 \
 --cpu mode=host-passthrough --vcpus 2 --ram 4096 \
 --video none --graphics none --sound none --controller usb,model=none \
 --disk "$(virsh -q pool-refresh default ; virsh vol-path alpinevm.qcow2 --pool default)",format=qcow2,bus=virtio \
 --network=network:routed122,model=virtio,target=alpinevm \
 --memballoon virtio --rng /dev/random \
 --channel unix,mode=bind,path=/var/lib/libvirt/qemu/alpinevm.agent,target_type=virtio,name=org.qemu.guest_agent.0 ; \
virsh console alpinevm

# --disk /media/donnees/virtualisation/originals/alpine.iso,device=cdrom,bus=ide
# rm -f /media/donnees/virtualisation/originals/alpine.iso
# wget -q http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-virt-3.12.0_rc1-x86_64.iso -O /media/donnees/virtualisation/originals/alpine.iso
# qemu-img create -q -f qcow2 /media/donnees/virtualisation/images/alpinevm.qcow2 20G
# sudo rm -f /media/donnees/virtualisation/images/alpinevm.qcow2 ; \



###################

# brwan.xml
<network>
  <name>brwan</name>
  <forward mode='bridge'/>
  <bridge name='brwan'/>
</network>

# routed122.xml
<network xmlns:dnsmasq='http://libvirt.org/schemas/network/dnsmasq/1.0'>
  <name>routed122</name>
  <uuid>01234567-89ab-cdfe-f012-3456789abcde</uuid>
  <forward mode='open'/>
  <bridge name='virbr122' zone='libvirt' stp='on' delay='0' macTableManager='libvirt'/>
  <mac address='52:54:00:aa:67:da'/>
  <domain name='example.com'/>
  <dns>
    <forwarder addr='192.168.0.254'/>
    <host ip='192.168.122.2'>
      <hostname>zotac</hostname>
    </host>
  </dns>
  <ip address='192.168.122.2' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.100' end='192.168.122.199'/>
      <host mac='52:54:00:00:7a:65' name='centos8vm' ip='192.168.122.110'/>
      <host mac='52:54:00:00:7a:66' name='debian10vm' ip='192.168.122.111'/>
    </dhcp>
  </ip>
  <dnsmasq:options>
    <dnsmasq:option value='dhcp-option=option:ntp-server,195.83.132.135'/>
    <dnsmasq:option value='dhcp-option=option:router,192.168.122.2'/>
  </dnsmasq:options>
</network>

###################
# Poubelle

# --firstboot-command "/bin/echo $(hostname -I)' centos8vm.$(hostname -d) centos8vm' >> /etc/hosts ; localectl set-locale LANG=fr_FR.utf8' ; localectl set-keymap fr'"
# --firstboot-command "/bin/echo $(hostname -I)' debian10vm.$(hostname -d) debian10vm' >> /etc/hosts"
# --run-command "sed -i 's/\(^127.0.0.1 *\)localhost.\*/\1centos8vm.$(hostname -d) centos8vm localhost localhost.localdomain localhost4 localhost4.localdomain4/' /etc/hosts" \
# --run-command "sed -i 's/\(^127.0.0.1.*\)localhost.*\$/\1debian10vm.$(hostname -d) debian10vm localhost localhost.localdomain/' /etc/hosts" \

# --run-command "echo 'if [ \"\${SHELL}\" = \"/bin/bash\" ] ; then set completion-ignore-case on ; set +o noclobber ; shopt -s checkwinsize' > /etc/profile.d/10-perso.sh" \
# --run-command "echo 'shopt -s histappend ; [[ $- == *i* ]] && stty werase undef ; [[ $- == *i* ]] && bind \"\C-w:unix-filename-rubout\" ; fi' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'alias la=\"\ls -a --color=auto\" ll=\"\ls -al --color=auto\" l=\"\ls -a1 --color=auto\"' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'alias lrt=\"\ls -a1rt --color=auto\" llrt=\"\ls -alrt --color=auto\"' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'export TERM=screen' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'rw () { o=\$(stty -g);stty raw -echo min 0 time 5;printf \"\\0337\\033[r\\033[999;999H\\033[6n\\0338\">/dev/tty;' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'IFS=\"[;R\" read -r _ r c _ < /dev/tty;stty \"\$o\";stty cols \"\$c\" rows \"\$r\"; }' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'uwt () { echo -ne \"\033]0;\${1:-\${HOSTNAME}}\007\"; }' >> /etc/profile.d/10-perso.sh" \

# --run-command "echo 'if [ \"\${SHELL}\" = \"/bin/bash\" ] ; then set completion-ignore-case on ; set +o noclobber ; shopt -s checkwinsize' > /etc/profile.d/10-perso.sh" \
# --run-command "echo 'shopt -s histappend ; [[ $- == *i* ]] && stty werase undef ; [[ $- == *i* ]] && bind \"\C-w:unix-filename-rubout\" ; fi' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'alias la=\"\ls -a --color=auto\" ll=\"\ls -al --color=auto\" l=\"\ls -a1 --color=auto\"' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'alias lrt=\"\ls -a1rt --color=auto\" llrt=\"\ls -alrt --color=auto\"' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'export TERM=screen ; export LANG=fr_FR.UTF8' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'rw () { o=\$(stty -g);stty raw -echo min 0 time 5;printf \"\\\0337\\\033[r\\\033[999;999H\\\033[6n\\\0338\">/dev/tty;' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'IFS=\"[;R\" read -r _ r c _ < /dev/tty;stty \"\$o\";stty cols \"\$c\" rows \"\$r\"; }' >> /etc/profile.d/10-perso.sh" \
# --run-command "echo 'uwt () { /bin/echo -ne \"\\\033]0;\${1:-\${HOSTNAME}}\\\007\"; }' >> /etc/profile.d/10-perso.sh" \

_EOF_

 }
fi

