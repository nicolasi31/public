if [ ${PERSO_ENABLED} = 1 ] ; then

 kvmcreatecentuefi () {
  VM_ORG_DIR="/media/donnees/virtualisation/originals/"
  VM_IMGSIZE="20G"
  VM_PASSW="${3:-CHANGEME}"
  wget --show-progress --no-use-server-timestamps -nv -c -P ${VM_ORG_DIR} $(kvmlastimgcent)
  VM_IMG_BIOS_NAME=$(basename $(kvmlastimgcent))
  VM_IMG_UEFI_NAME=$(echo ${VM_IMG_BIOS_NAME} | sed "s/qcow2/uefi.qcow2/")
  if [ -f ${VM_ORG_DIR}${VM_IMG_UEFI_NAME} ] ; then
   /bin/echo -e "File ${VM_ORG_DIR}${VM_IMG_UEFI_NAME} exist.\nDo nothing"
   return 0
  fi
  qemu-img create -q -f qcow2 ${VM_ORG_DIR}${VM_IMG_UEFI_NAME} ${VM_IMGSIZE}
  virt-resize -q --resize /dev/vda1=+11.2G --no-extra-partition ${VM_ORG_DIR}${VM_IMG_BIOS_NAME} ${VM_ORG_DIR}${VM_IMG_UEFI_NAME}
  virt-customize -a ${VM_ORG_DIR}${VM_IMG_UEFI_NAME} \
   --root-password password:${VM_PASSW} \
   --run-command "mount /dev/sda2 /boot/efi ;
    yum -y install efivar OVMF fwupdate-efi grub2-efi-x64-modules grub2-efi-x64 ;
    grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg ;
    sed -i 's/set timeout=1/set timeout=0/' /boot/efi/EFI/centos/grub.cfg ;
    cp /boot/efi/EFI/centos/grubx64.efi /boot/efi/EFI/BOOT/grubx64.efi ;
    cp /boot/grub2/grubenv /boot/efi/EFI/centos/grubenv ;
    sed -i 's/^#\{0,1\}SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config" \
   --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub
}


################################################################################


 kvmcreatecent () {
  if [ ! ${1} ] || [ "${1}" = "-h" ] || [ "${1}" = "-help" ] ; then
   echo -e "Usage:" \
    "\n${FUNCNAME[0]} VM_NAME [VM_USER] [VM_PASSWORD] [DNSDOMAIN] [VM_INTF] [KVM_NET] [CPU_NBR] [RAM_MB] [DISK_GB]" \
    "\n\nExample:" "\n${FUNCNAME[0]} centos8vm ${USER:-${USERNAME}} CHANGEME $(hostname -d) enp1s0 routed122 2 4096 20\n" \
    "\nAutomatic mode:\n${FUNCNAME[0]} -a\n" \
    "\nVM list:\nvirsh list --all\n" \
    "\nConsole :\nread -e -p \"VM to connect to: \" VM_NAME ; virsh console \${VM_NAME}\n" \
    "\nSSH VM:\nread -e -p \"VM name:\" VM;" \
    "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${2:-${USER:-${USERNAME}}}" \
    "\$(virsh domifaddr \$VM --source agent|grep ipv4|grep -v ^\ lo|tr -s \" \"|cut -d\" \" -f5|cut -d/ -f1)\n" \
    "\nRetrieve VM IP addr :" \
    "\nread -e -p \"VM name: \" VM_NAME ; virsh domifaddr \${VM_NAME} --source agent | grep ipv4 | tr -s \" \" | cut -d\" \" -f5\n" \
    "\nSparsify (reduce image disk usage):\n!!! Only IF VM is SHUTDOWN !!!" \
    "\nread -e -p \"VM to sparsify: \" VM_NAME ; virt-sparsify --in-place \${VM_NAME}\n" \
    "\nVM deletion:\n!!! Including Disk Image !!!" \
    "\nread -e -p \"VM to remove: \" VM_NAME ; virsh destroy \${VM_NAME} ; virsh undefine \${VM_NAME} --remove-all-storage"
   return 0
  elif [ "${1}" = "-a" ] ; then
   CKVM_VMNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
  elif [[ "${1}" =~ ^-.* ]] ; then
   echo "Syntax error: ${1}, bad VM name" ; return 0
  else
   CKVM_VMNAME="${1}"
  fi

  CKVM_VMUSER="${2:-${USER:-${USERNAME}}}"
  CKVM_VMPASSW="${3:-CHANGEME}"
  CKVM_VMDOMAIN="${4:-$(hostname -d)}"
  CKVM_VMINTF="${5:-enp1s0}"
  CKVM_VMKVMNET="${6:-brwan}"
  CKVM_VMKVMNETDNS="$(virsh net-dumpxml ${CKVM_VMKVMNET} | grep "ip address" | cut -d\' -f2)"
  CKVM_VMCPU="${7:-2}"
  CKVM_VMRAM="${8:-4096}"
  CKVM_VMDISK="${9:-20}"
  CKVM_OS_VERSION=8

  CKVM_IMGDIR="$(virsh pool-dumpxml default | grep path | cut -d\> -f2 | cut -d\< -f1)"

  CKVM_MIR_HOST="mirrors.ircam.fr"
  CKVM_MIR_ROOT="pub"

  CKVM_IPADDR_CMD='ip addr show '${CKVM_VMINTF}' | grep "inet " | tr -s " " | cut -d" "  -f3 | cut -d\/ -f1'
  CKVM_WAITFOR_IPADDR_CMD='VMIPADDRTMP="" ; while [ "${VMIPADDRTMP}" = "" ] ; do VMIPADDRTMP=$('${CKVM_IPADDR_CMD}') ; sleep 1 ; done'

  CKVM_PKGINST="bash-completion,yum-utils,glibc-langpack-fr"
  CKVM_PKGINST="${CKVM_PKGINST},https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/fedora/epel/${CKVM_OS_VERSION}/Everything/x86_64/Packages/h/haveged-1.9.13-2.el8.x86_64.rpm"
  CKVM_PKGINST="${CKVM_PKGINST},https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/fedora/epel/${CKVM_OS_VERSION}/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm"
  CKVM_PKGINST="${CKVM_PKGINST},https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/fedora/epel/${CKVM_OS_VERSION}/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm"
  CKVM_PKGUNINST="iwl7260-firmware,linux-firmware.noarch,iwl1000-firmware,iwl100-firmware,iwl105-firmware,iwl135-firmware,iwl2000-firmware,iwl2030-firmware,iwl3160-firmware"
  CKVM_PKGUNINST="${CKVM_PKGUNINST},iwl3945-firmware,iwl4965-firmware,iwl5000-firmware,iwl5150-firmware,iwl6000-firmware,iwl6000g2a-firmware,iwl6050-firmware"
  CKVM_PKGUNINST="${CKVM_PKGUNINST},cloud-init,selinux-policy,selinux-policy-targeted,rpm-plugin-selinux,plymouth-core-libs,plymouth,plymouth-scripts"

  LIBGUESTFS_CACHEDIR="${CKVM_IMGDIR}/"
  TMPDIR="${CKVM_IMGDIR}/" \
  virt-builder centos-${CKVM_OS_VERSION}.0 --hostname ${CKVM_VMNAME}.${CKVM_VMDOMAIN} \
   -o "${CKVM_IMGDIR}/${CKVM_VMNAME}.qcow2" --size ${CKVM_VMDISK}G --format qcow2 \
   --uninstall ${CKVM_PKGUNINST} --install ${CKVM_PKGINST} \
   --run-command "yum-config-manager --nogpgcheck --enable --save \
    --setopt=BaseOS.baseurl=https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/CentOS/${CKVM_OS_VERSION}/BaseOS/x86_64/os" \
   --run-command "yum-config-manager --nogpgcheck --enable --save \
    --setopt=AppStream.baseurl=https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/CentOS/${CKVM_OS_VERSION}/AppStream/x86_64/os" \
   --run-command "yum-config-manager --nogpgcheck --enable --save \
    --setopt=extras.baseurl=https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/CentOS/${CKVM_OS_VERSION}/extras/x86_64/os" \
   --install https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/fedora/epel/${CKVM_OS_VERSION}/Everything/x86_64/Packages/h/haveged-1.9.13-2.el8.x86_64.rpm \
   --install https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/fedora/epel/${CKVM_OS_VERSION}/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm \
   --install https://${CKVM_MIR_HOST}/${CKVM_MIR_ROOT}/fedora/epel/${CKVM_OS_VERSION}/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm \
   --root-password password:${CKVM_VMPASSW} \
   --run-command "useradd -m -g 100 -G wheel -s /bin/bash -p '' ${CKVM_VMUSER}" --password ${CKVM_VMUSER}:password:${CKVM_VMPASSW} \
   --ssh-inject ${CKVM_VMUSER}:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub --ssh-inject root:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub \
   --run-command "echo -e '\nkernel.domainname=${CKVM_VMDOMAIN}\nkernel.hostname=${CKVM_VMNAME}' >> /etc/sysctl.conf" \
   --run-command "echo -e '\nnet.ipv6.conf.${CKVM_VMINTF}.disable_ipv6=1' >> /etc/sysctl.conf" \
   --run-command 'sed -i "s/timeout=5/timeout=0/" /boot/grub2/grub.cfg ; sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config' \
   --run-command "echo -e 'PRETTY_HOSTNAME=${CKVM_VMNAME}\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production' > /etc/machine-info" \
   --run-command "echo ${CKVM_VMNAME} > /etc/hostname" \
   --run-command 'sed -i "s/\(^OPTIONS=.\).*\(.\)$/\1-4\2/" /etc/sysconfig/chronyd' \
   --firstboot-command "sysctl -p ; systemctl disable firewalld.service ; localectl set-locale LANG=fr_FR.utf8 ; localectl set-keymap fr" \
   --firstboot-command "systemctl restart systemd-sysctl.service" \
   --firstboot-command "\$(${CKVM_WAITFOR_IPADDR_CMD}) ; echo -e '\n'\$(${CKVM_IPADDR_CMD})' '${CKVM_VMNAME}'.'${CKVM_VMDOMAIN}' '${CKVM_VMNAME} >> /etc/hosts" \
   --firstboot-command "\$(${CKVM_WAITFOR_IPADDR_CMD}) ; echo -e '\nIP: '\$(${CKVM_IPADDR_CMD}) >> /etc/motd"

  virt-copy-in -a "${CKVM_IMGDIR}/${CKVM_VMNAME}.qcow2" ${HOME}/.profile.d/perso-*sh /etc/profile.d/

  virt-sparsify --in-place "${CKVM_IMGDIR}/${CKVM_VMNAME}.qcow2"

  virt-install --connect qemu:///system --virt-type kvm --hvm --import \
   --boot menu=off,useserial=on --machine q35 --noautoconsole \
   --name ${CKVM_VMNAME} --os-type=linux --os-variant=centos${CKVM_OS_VERSION} \
   --cpu mode=host-passthrough --vcpus ${CKVM_VMCPU} --ram ${CKVM_VMRAM} \
   --video none --graphics none --sound none --controller usb,model=none \
   --disk "$(virsh -q pool-refresh default ; virsh vol-path ${CKVM_VMNAME}.qcow2 --pool default)",format=qcow2,bus=virtio \
   --network=network:${CKVM_VMKVMNET},model=virtio,target=${CKVM_VMNAME} \
   --memballoon virtio --rng /dev/random \
   --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${CKVM_VMNAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0

  echo -e "IP information:\nWaiting for network..."
  CKVM_VMMACADDR="$(virsh dumpxml ${CKVM_VMNAME} | grep mac\ address | grep mac\ address | tr -s ' ' | cut -d\'  -f2)"
  CKVM_VMIPADDR="" ; while [ "${CKVM_VMIPADDR}" == "" ]; do CKVM_VMIPADDR=$(ip neigh show  | grep ${CKVM_VMMACADDR} | cut -d\  -f1) ; sleep 1 ; done
  CKVM_VMNETMASK=$(ip route | grep ${CKVM_VMKVMNETDNS} | cut -d\/ -f2 | cut -d\  -f1)
  virsh -q desc --live --config ${CKVM_VMNAME} "Name    : ${CKVM_VMNAME}
VM OS   : Centos ${CKVM_OS_VERSION}
User    : ${CKVM_VMUSER}
IP      : ${CKVM_VMIPADDR}
MASK    : ${CKVM_VMNETMASK}
VMMAC   : ${CKVM_VMMACADDR}
GW/DNS  : ${CKVM_VMKVMNETDNS}
Network : ${CKVM_VMKVMNET}
VM UUID : $(virsh domuuid ${CKVM_VMNAME})

Console:
virsh console ${CKVM_VMNAME}

SSH:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${CKVM_VMUSER} ${CKVM_VMIPADDR}"
  virsh -q desc --live --config --title ${CKVM_VMNAME} "${CKVM_VMNAME}          ${CKVM_VMIPADDR}/${CKVM_VMNETMASK}  ${CKVM_VMMACADDR}"
  virsh desc ${CKVM_VMNAME}
 }


################################################################################


 kvmcreatedeb () {
  if [ ! ${1} ] || [ "${1}" = "-h" ] || [ "${1}" = "-help" ] ; then
   echo -e "Usage:" \
    "\n${FUNCNAME[0]} VM_NAME" "\n${FUNCNAME[0]} VM_NAME VM_USER" "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD DNSDOMAIN" "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD DNSDOMAIN VM_INTF" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD DNSDOMAIN VM_INTF KVM_NET" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD DNSDOMAIN VM_INTF KVM_NET CPU_NBR" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD DNSDOMAIN VM_INTF KVM_NET CPU_NBR RAM_MB" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER VM_PASSWORD DNSDOMAIN VM_INTF KVM_NET CPU_NBR RAM_MB DISK_GB" \
    "\n\nExample:" "\n${FUNCNAME[0]} debian10vm ${USER:-${USERNAME}} CHANGEME $(hostname -d) enp1s0 routed122 2 4096 20\n" \
    "\nAutomatic mode:\n${FUNCNAME[0]} -a\n" \
    "\nVM list:\nvirsh list --all\n" \
    "\nConsole :\nread -e -p \"VM to connect to: \" VM_NAME ; virsh console \${VM_NAME}\n" \
    "\nSSH VM:\nread -e -p \"VM name:\" VM;" \
    "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${2:-${USER:-${USERNAME}}}" \
    "\$(virsh domifaddr \$VM --source agent|grep ipv4|grep -v ^\ lo|tr -s \" \"|cut -d\" \" -f5|cut -d/ -f1)\n" \
    "\nRetrieve VM IP addr :" \
    "\nread -e -p \"VM name: \" VM_NAME ; virsh domifaddr \${VM_NAME} --source agent | grep ipv4 | tr -s \" \" | cut -d\" \" -f5\n" \
    "\nSparsify (reduce image disk usage):\n!!! Only IF VM is SHUTDOWN !!!" \
    "\nread -e -p \"VM to sparsify: \" VM_NAME ; virt-sparsify --in-place \${VM_NAME}\n" \
    "\nVM deletion:\n!!! Including Disk Image !!!" \
    "\nread -e -p \"VM to remove: \" VM_NAME ; virsh destroy \${VM_NAME} ; virsh undefine \${VM_NAME} --remove-all-storage"
   return 0
  elif [ "${1}" = "-a" ] ; then
   DKVM_VMNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
  elif [[ "${1}" =~ ^-.* ]] ; then
   echo "Syntax error: ${1}, bad VM name" ; return 0
  else
   DKVM_VMNAME="${1}"
  fi

  DKVM_VMUSER="${2:-${USER:-${USERNAME}}}"
  DKVM_VMPASSW="${3:-CHANGEME}"
  DKVM_VMDOMAIN="${4:-$(hostname -d)}"
  DKVM_VMINTF="${5:-enp1s0}"
  DKVM_VMKVMNET="${6:-brwan}"
  DKVM_VMKVMNETDNS="$(virsh net-dumpxml ${DKVM_VMKVMNET} | grep "ip address" | cut -d\' -f2)"
  DKVM_VMCPU="${7:-2}"
  DKVM_VMRAM="${8:-4096}"
  DKVM_VMDISK="${9:-20}"
  DKVM_OS_VERSION=10

  DKVM_IMGDIR="$(virsh pool-dumpxml default | grep path | cut -d\> -f2 | cut -d\< -f1)"

  DKVM_MIR_HOST="mirrors.ircam.fr"
  DKVM_MIR_ROOT="pub"

  DKVM_IPADDR_CMD='ip addr show '${DKVM_VMINTF}' | grep "inet " | tr -s " " | cut -d" "  -f3 | cut -d\/ -f1'
  DKVM_WAITFOR_IPADDR_CMD='VMIPADDRTMP="" ; while [ "${VMIPADDRTMP}" = "" ] ; do VMIPADDRTMP=$('${DKVM_IPADDR_CMD}') ; sleep 1 ; done'

  DKVM_PKGINST="screen,bash-completion,sudo,htop,qemu-guest-agent,apt-transport-https"
  DKVM_PKGUNINST="libpython-stdlib,libpython2-stdlib,libpython2.7-minimal,libpython2.7-stdlib,python-minimal,python2,python2-minimal,python2.7,python2.7-minimal"
  DKVM_PKGUNINST="${DKVM_PKGUNINST},cloud-init,firmware-linux-free,geoip-database,debian-faq,doc-debian"

  TMPDIR="${DKVM_IMGDIR}/" \
  virt-builder debian-${DKVM_OS_VERSION} --hostname ${DKVM_VMNAME}.${DKVM_VMDOMAIN} \
   -o "${DKVM_IMGDIR}/${DKVM_VMNAME}.qcow2" --size ${DKVM_VMDISK}G --format qcow2 \
   --run-command "sed -i 's/^deb-src/#deb-src/' /etc/apt/sources.list" \
   --run-command "sed -i 's/main$/main contrib non-free/' /etc/apt/sources.list" \
   --uninstall ${DKVM_PKGUNINST} --update --install  ${DKVM_PKGINST} \
   --root-password password:${DKVM_VMPASSW} \
   --run-command "useradd -m -g 100 -G sudo -s /bin/bash -p '' ${DKVM_VMUSER}" --password ${DKVM_VMUSER}:password:${DKVM_VMPASSW} \
   --ssh-inject ${DKVM_VMUSER}:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub --ssh-inject root:file:/home/${USER:-${USERNAME}}/.ssh/id_rsa.pub \
   --run-command "echo '\nkernel.domainname=${DKVM_VMDOMAIN}\nkernel.hostname=${DKVM_VMNAME}' >> /etc/sysctl.conf" \
   --run-command "echo '\nnet.ipv6.conf.${DKVM_VMINTF}.disable_ipv6=1' >> /etc/sysctl.conf" \
   --run-command 'dpkg-reconfigure --frontend=noninteractive openssh-server ; sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config' \
   --run-command "sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub ; sed -i 's/\(^GRUB_CMDLINE_LINUX_DEFAULT=.*\)\"$/\1 3\"/' /etc/default/grub" \
   --run-command "update-grub2" \
   --run-command "/bin/echo -e 'PRETTY_HOSTNAME=${DKVM_VMNAME}\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production' > /etc/machine-info" \
   --run-command "echo ${DKVM_VMNAME} > /etc/hostname" \
   --run-command "sed -i 's/ens2/${DKVM_VMINTF}/' /etc/network/interfaces ; systemctl enable networking" \
   --run-command "sed -i \"s/http:\/\/deb.debian.org/https:\/\/${DKVM_MIR_HOST}\/${DKVM_MIR_ROOT}/\" /etc/apt/sources.list" \
   --run-command "sed -i \"s/http:\/\/security.debian.org/https:\/\/${DKVM_MIR_HOST}\/${DKVM_MIR_ROOT}/\" /etc/apt/sources.list" \
   --run-command "echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8' | debconf-set-selections ;
     echo 'locales locales/default_environment_locale select fr_FR.UTF-8' | debconf-set-selections ;
     sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen ; ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime ;
     echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections ; echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections ;
     dpkg-reconfigure --frontend=noninteractive tzdata ; dpkg-reconfigure --frontend=noninteractive locales" \
   --firstboot-command 'sysctl -p ; sed -i "s/\(^127.0.1.1.*$\)/#\1/" /etc/hosts' \
   --firstboot-command "\$(${DKVM_WAITFOR_IPADDR_CMD}) ; echo '\n'\$(${DKVM_IPADDR_CMD})' '${DKVM_VMNAME}'.'${DKVM_VMDOMAIN}' '${DKVM_VMNAME} >> /etc/hosts" \
   --firstboot-command "\$(${DKVM_WAITFOR_IPADDR_CMD}) ; echo '\nIP: '\$(${DKVM_IPADDR_CMD}) >> /etc/motd"

  virt-copy-in -a "${DKVM_IMGDIR}/${DKVM_VMNAME}.qcow2" ${HOME}/.profile.d/perso-*sh /etc/profile.d/

  virt-sparsify --in-place "${DKVM_IMGDIR}/${DKVM_VMNAME}.qcow2"

  virt-install --connect qemu:///system --virt-type kvm \
   --hvm --import --boot menu=off,useserial=on --machine q35 --noautoconsole \
   --name ${DKVM_VMNAME} --os-type=linux --os-variant=debian${DKVM_OS_VERSION} \
   --cpu mode=host-passthrough --vcpus ${DKVM_VMCPU} --ram ${DKVM_VMRAM} \
   --video none --graphics none --sound none --controller usb,model=none \
   --disk "$(virsh -q pool-refresh default ; virsh vol-path ${DKVM_VMNAME}.qcow2 --pool default)",format=qcow2,bus=virtio \
   --network=network:${DKVM_VMKVMNET},model=virtio,target=${DKVM_VMNAME} \
   --memballoon virtio --rng /dev/random \
   --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${DKVM_VMNAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0

  echo -e "IP information:\nWaiting for network..."
  DKVM_VMMACADDR="$(virsh dumpxml ${DKVM_VMNAME} | grep mac\ address | grep mac\ address | tr -s ' ' | cut -d\'  -f2)"
  DKVM_VMIPADDR="" ; while [ "${DKVM_VMIPADDR}" == "" ]; do DKVM_VMIPADDR=$(ip neigh show  | grep ${DKVM_VMMACADDR} | cut -d\  -f1) ; sleep 1 ; done
  DKVM_VMNETMASK=$(ip route | grep ${DKVM_VMKVMNETDNS} | cut -d\/ -f2 | cut -d\  -f1)
  virsh -q desc --live --config ${DKVM_VMNAME} "Name    : ${DKVM_VMNAME}
VM OS   : Debian ${DKVM_OS_VERSION}
User    : ${DKVM_VMUSER}
IP      : ${DKVM_VMIPADDR}
MASK    : ${DKVM_VMNETMASK}
VMMAC   : ${DKVM_VMMACADDR}
GW/DNS  : ${DKVM_VMKVMNETDNS}
Network : ${DKVM_VMKVMNET}
VM UUID : $(virsh domuuid ${DKVM_VMNAME})

Console:
virsh console ${DKVM_VMNAME}

SSH:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${DKVM_VMUSER} ${DKVM_VMIPADDR}"
  virsh -q desc --live --config --title ${DKVM_VMNAME} "${DKVM_VMNAME}          ${DKVM_VMIPADDR}/${DKVM_VMNETMASK}  ${DKVM_VMMACADDR}"
  virsh desc ${DKVM_VMNAME}
 }


################################################################################


 kvmcreatealp () {
  if [ ! ${1} ] || [ "${1}" = "-h" ] || [ "${1}" = "-help" ] ; then
   /bin/echo -e "Usage:" \
    "\n${FUNCNAME[0]} VM_NAME" "\n${FUNCNAME[0]} VM_NAME VM_USER" "\n${FUNCNAME[0]} VM_NAME VM_USER DNSDOMAIN" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER DNSDOMAIN VM_INTF" "\n${FUNCNAME[0]} VM_NAME VM_USER DNSDOMAIN VM_INTF KVM_NET" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER DNSDOMAIN VM_INTF KVM_NET CPU_NBR" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER DNSDOMAIN VM_INTF KVM_NET CPU_NBR RAM_MB" \
    "\n${FUNCNAME[0]} VM_NAME VM_USER DNSDOMAIN VM_INTF KVM_NET CPU_NBR RAM_MB DISK_GB" \
    "\n\nExample:" "\n${FUNCNAME[0]} alpine312vm ${USER:-${USERNAME}} $(hostname -d) enp1s0 routed122 2 4096 20\n" \
    "\nAutomatic mode:\n${FUNCNAME[0]} -a\n" \
    "\nVM list:\nvirsh list --all\n" \
    "\nConsole :\nread -e -p \"VM to connect to: \" VM_NAME ; virsh console \${VM_NAME}\n" \
    "\nSSH VM:\nread -e -p \"VM name:\" VM;" \
    "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${2:-${USER:-${USERNAME}}}" \
    "\$(virsh domifaddr \$VM --source agent|grep v4|grep -v ^\ lo|tr -s\\ |cut -d\\  -f5|cut -d/ -f1)\n" \
    "\nRetrieve VM IP addr :" \
    "\nread -e -p \"VM name: \" VM_NAME ; virsh domifaddr \${VM_NAME} --source agent | grep ipv4 | tr -s \" \" | cut -d\" \" -f5\n" \
    "\nSparsify (reduce image disk usage):\n!!! Only IF VM is SHUTDOWN !!!" \
    "\nread -e -p \"VM to sparsify: \" VM_NAME ; virt-sparsify --in-place \${VM_NAME}\n" \
    "\nVM deletion:\n!!! Including Disk Image !!!" \
    "\nread -e -p \"VM to remove: \" VM_NAME ; virsh destroy \${VM_NAME} ; virsh undefine \${VM_NAME} --remove-all-storage"
   return 0
  elif [ "${1}" = "-a" ] ; then
   AKVM_VMNAME=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  elif [[ "${1}" =~ ^-.* ]] ; then
   /bin/echo -e "Syntax error: ${1}, bad VM name" ; return 0
  else
   AKVM_VMNAME="${1}"
  fi

  AKVM_IMGDIR="$(virsh pool-dumpxml default | grep path | cut -d\> -f2 | cut -d\< -f1)"
  AKVM_VMUSER="${2:-${USER:-${USERNAME}}}"
  AKVM_VMDOMAIN="${3:-$(hostname -d)}"
  AKVM_VMINTF="${4:-eth0}"
  AKVM_VMKVMNET="${5:-brwan}"
  AKVM_VMKVMNETDNS="$(virsh net-dumpxml ${AKVM_VMKVMNET} | grep "ip address" | cut -d\' -f2)"
  AKVM_VMCPU="${6:-2}"
  AKVM_VMRAM="${7:-4096}"
  AKVM_VMDISK="${8:-20}"
  AKVM_OS_VERSION="3.8"
  AKVM_OS_REAL_VERSION="3.12"
  AKVM_ALPSCRIPTURL="https://raw.githubusercontent.com/alpinelinux/alpine-make-vm-image/master/alpine-make-vm-image"
  AKVM_ALPSCRIPT="/tmp/alpine-make-vm-image"
  AKVM_CFG_FILE="alpine-cfg-init.sh"
  AKVM_PKGINST="openssh-server qemu-guest-agent screen sudo bash bash-completion shadow htop"

  if [ $(virsh list --name --all | grep -c "${AKVM_VMNAME}") = 1 ] ; then /bin/echo -e "${AKVM_VMNAME} already exist." ; return 0 ; fi

  if [ ! -e ${AKVM_ALPSCRIPT} ] ; then wget -q -O ${AKVM_ALPSCRIPT} ${AKVM_ALPSCRIPTURL} ; chmod +x ${AKVM_ALPSCRIPT} ; fi

  if [ ! -d /tmp/${AKVM_VMNAME} ] ; then mkdir -p /tmp/${AKVM_VMNAME}/scripts/ ; fi

  cat > /tmp/${AKVM_VMNAME}/scripts/${AKVM_CFG_FILE} <<-EOFINITSCRIPT
#!/bin/sh

echo 'Set up networking'
cat > /etc/network/interfaces <<-EOFINTF
iface lo inet loopback
iface eth0 inet dhcp
 hostname ${AKVM_VMNAME}
EOFINTF
ln -s networking /etc/init.d/net.lo
ln -s networking /etc/init.d/net.eth0
rc-update add net.eth0 default
rc-update add net.lo boot

echo 'Set up Timezone'
setup-timezone -z Europe/Paris

echo 'Set up Hostname'
setup-hostname ${AKVM_VMNAME}

echo 'Set up Keymap'
setup-keymap fr fr

echo 'Set up DNS'
setup-dns -d ${AKVM_VMDOMAIN} -n ${AKVM_VMKVMNETDNS}

echo 'Adjust rc.conf'
sed -Ei \
 -e 's/^[# ](rc_depend_strict)=.*/\1=NO/' \
 -e 's/^[# ](rc_logger)=.*/\1=YES/' \
 -e 's/^[# ](unicode)=.*/\1=YES/' \
 /etc/rc.conf

echo 'Enable Users'
chsh -s /bin/bash root
useradd -m -d /home/${AKVM_VMUSER} -g 100 -G wheel -s /bin/bash ${AKVM_VMUSER}
# To generate the usermod password : openssl passwd or mkpasswd -m sha-512 PASSWORD (whois package)
usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' ${AKVM_VMUSER}
usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' root
echo "${AKVM_VMUSER} ALL=(ALL) ALL" > /etc/sudoers.d/${AKVM_VMUSER}

echo 'SSH keys'
mkdir /root/.ssh
cat > /root/.ssh/authorized_keys <<-EOFSSHKEY
ssh-rsa AAAAB3Nza123blablabla/3QzeRUoc= user01@server01
EOFSSHKEY
mkdir /home/${AKVM_VMUSER}/.ssh
cp /root/.ssh/authorized_keys /home/${AKVM_VMUSER}/.ssh/ 
chown -R ${AKVM_VMUSER}:users /home/${AKVM_VMUSER}/.ssh

echo 'Set up Sysctl'
cat > /etc/sysctl.d/10-perso.conf <<-EOFSYSCTL
kernel.domainname=${AKVM_VMDOMAIN}
kernel.hostname=${AKVM_VMNAME}
net.ipv4.ip_forward=0
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=0
net.ipv6.conf.${AKVM_VMINTF}.disable_ipv6=1
EOFSYSCTL

echo 'Update inittab file'
sed -i 's/^\(tty[2-6]\)/#\1/' /etc/inittab

echo 'Set up Bootloader'
cat > /boot/extlinux.conf <<-EOFSYSLINUX
SERIAL ttyS0 115200
DEFAULT menu.c32
PROMPT 0
MENU TITLE Alpine/Linux Boot Menu
MENU HIDDEN
MENU AUTOBOOT Alpine will be booted automatically in # seconds.
TIMEOUT 1
LABEL virt
MENU LABEL Linux virt
LINUX vmlinuz-virt
  INITRD initramfs-virt
  APPEND root=/dev/vda modules=ext4 console=ttyS0 time
  MENU SEPARATOR
EOFSYSLINUX

echo 'SSH service activation'
sed -i 's/^#\{0,1\}\(AddressFamily \).*/\1inet/' /etc/ssh/sshd_config
rc-update add sshd

echo 'Qemu Guest Agent service activation'
echo 'GA_PATH="/dev/vport1p1"' >> /etc/conf.d/qemu-guest-agent
rc-update add qemu-guest-agent

EOFINITSCRIPT
  chmod +x  /tmp/${AKVM_VMNAME}/scripts/${AKVM_CFG_FILE}

  sudo ${AKVM_ALPSCRIPT} -f qcow2 -b v${AKVM_OS_REAL_VERSION} -s ${AKVM_VMDISK}G -p "${AKVM_PKGINST}" \
   -c -t ${AKVM_IMGDIR}/${AKVM_VMNAME}.qcow2 /tmp/${AKVM_VMNAME}/scripts/${AKVM_CFG_FILE}
  sudo chown ${USER:-${USERNAME}}:users ${AKVM_IMGDIR}/${AKVM_VMNAME}.qcow2

  virt-copy-in -a ${AKVM_IMGDIR}/${AKVM_VMNAME}.qcow2 ${HOME}/.profile.d/perso-*.sh /etc/profile.d/

  virt-install --connect qemu:///system --virt-type kvm --hvm \
   --boot hd,menu=off,useserial=on --machine q35 --noautoconsole \
   --name ${AKVM_VMNAME} --os-type=linux --os-variant=alpinelinux${AKVM_OS_VERSION} \
   --cpu mode=host-passthrough --vcpus ${AKVM_VMCPU} --ram ${AKVM_VMRAM} \
   --video none --graphics none --sound none --controller usb,model=none \
   --disk "$(virsh -q pool-refresh default ; virsh vol-path ${AKVM_VMNAME}.qcow2 --pool default)",format=qcow2,bus=virtio \
   --network=network:${AKVM_VMKVMNET},model=virtio,target=${AKVM_VMNAME} \
   --memballoon virtio --rng /dev/random \
   --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${AKVM_VMNAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0

  echo -e "IP information:\nWaiting for network..."
  AKVM_VMMACADDR="$(virsh dumpxml ${AKVM_VMNAME} | grep mac\ address | grep mac\ address | tr -s ' ' | cut -d\'  -f2)"
  AKVM_VMIPADDR="" ; while [ "${AKVM_VMIPADDR}" == "" ]; do AKVM_VMIPADDR=$(ip neigh show  | grep ${AKVM_VMMACADDR} | cut -d\  -f1) ; sleep 1 ; done
  AKVM_VMNETMASK=$(ip route | grep ${AKVM_VMKVMNETDNS} | cut -d\/ -f2 | cut -d\  -f1)
  virsh -q desc --live --config ${AKVM_VMNAME} "Name    : ${AKVM_VMNAME}
VM OS   : Alpine ${AKVM_OS_REAL_VERSION}
User    : ${AKVM_VMUSER}
IP      : ${AKVM_VMIPADDR}
MASK    : ${AKVM_VMNETMASK}
VMMAC   : ${AKVM_VMMACADDR}
GW/DNS  : ${AKVM_VMKVMNETDNS}
Network : ${AKVM_VMKVMNET}
VM UUID : $(virsh domuuid ${AKVM_VMNAME})

Console:
virsh console ${AKVM_VMNAME}

SSH:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${AKVM_VMUSER} ${AKVM_VMIPADDR}"

  virsh -q desc --live --config --title ${AKVM_VMNAME} "${AKVM_VMNAME}          ${AKVM_VMIPADDR}/${AKVM_VMNETMASK}  ${AKVM_VMMACADDR}"
  virsh desc ${AKVM_VMNAME}

  if [ -d "/tmp/${AKVM_VMNAME}" ] ; then rm -rf /tmp/${AKVM_VMNAME}/ ; fi

 }


################################################################################


 kvmupdatedescandtitle () {
  if [ ! ${1} ] || [ "${1}" = "-h" ] || [ "${1}" = "-help" ] ; then
   echo -e "Usage:\n${FUNCNAME[0]} VM_NAME\n${FUNCNAME[0]} VM_NAME VM_USER VM_NETWORK VM_DOMAIN" \
    "\n\nExample:" "\n${FUNCNAME[0]} vmname ${USER:-${USERNAME}} routed122 $(hostname -d)\n" ; return 0
  fi
  if [ ! $(virsh domid ${1}) ] ; then echo 'Bad VM name' ; return 0 ; fi
  if [ ${3} ] && [ ! $(virsh net-list --name | grep ${3}) ] ; then echo 'Bad Network' ; return 0 ; fi
  UKVM_VMNAME="${1}"
  UKVM_VMUSER="${2:-${USER:-${USERNAME}}}"
  UKVM_VMKVMNET="${3:-$(virsh dumpxml ${UKVM_VMNAME} | grep source\ netw | cut -d\' -f2)}"
  UKVM_VMDOMAIN="${4:-$(hostname -d)}"
  UKVM_VMKVMNETDNS="$(virsh net-dumpxml ${UKVM_VMKVMNET} | grep ip\ address | cut -d\' -f2)"
  UKVM_VMKVMGW="$(ip route show default | grep $(virsh net-dumpxml ${UKVM_VMKVMNET} | grep "bridge name" | cut -d\' -f2) | cut -d\  -f3)"
  UKVM_VMKVMGW="${UKVM_VMKVMGW:-$(ip add show dev $(virsh net-dumpxml ${UKVM_VMKVMNET} | grep "bridge name" | cut -d\' -f2) | grep inet\  | tr -s \  | cut -d\  -f3 | cut -d\/  -f1)}"
  UKVM_VMMACADDR="$(virsh dumpxml ${UKVM_VMNAME} | grep mac\ address | grep mac\ address | tr -s ' ' | cut -d\'  -f2)"
  if [ "${UKVM_VMKVMNETDNS}" = "" ] ; then
   UKVM_VMKVMNETDNS="192.168.0.252"
  fi
  UKVM_VMIPADDR="" ; while [ "${UKVM_VMIPADDR}" == "" ]; do UKVM_VMIPADDR=$(ip neigh show  | grep ${UKVM_VMMACADDR} | cut -d\  -f1) ; sleep 1 ; done
#  UKVM_VMNETMASK=$(ip route | grep ${UKVM_VMKVMGW} | cut -d\/ -f2 | cut -d\  -f1)
  UKVM_VMNETMASK=$(ip route show | grep ^${UKVM_VMIPADDR%???} | cut -d\  -f1 | cut -d\/ -f2)

  echo -e "# Previous Title:" ; virsh desc --title ${UKVM_VMNAME}
  echo -e "\n# Previous Description:" ; virsh desc ${UKVM_VMNAME}

  virsh -q desc --live --config ${UKVM_VMNAME} "Name    : ${UKVM_VMNAME}
User    : ${UKVM_VMUSER}
IP      : ${UKVM_VMIPADDR}
MASK    : ${UKVM_VMNETMASK}
VMMAC   : ${UKVM_VMMACADDR}
GW      : ${UKVM_VMKVMGW}
DNS     : ${UKVM_VMKVMNETDNS}
Network : ${UKVM_VMKVMNET}
VM UUID : $(virsh domuuid ${UKVM_VMNAME})

Console:
virsh console ${UKVM_VMNAME}

SSH:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${UKVM_VMUSER} ${UKVM_VMIPADDR}"
  virsh -q desc --live --config --title ${UKVM_VMNAME} \
   "${UKVM_VMNAME}$(head -c $((20 - ${#UKVM_VMNAME})) /dev/zero | tr '\0' ' ')${UKVM_VMIPADDR}/${UKVM_VMNETMASK}$(head -c $((16 - ${#UKVM_VMIPADDR})) /dev/zero | tr '\0' ' ')${UKVM_VMMACADDR}"

  echo -e "\n ###\n\n# New Title:" ; virsh desc --title ${UKVM_VMNAME}
  echo -e "\n# New Description:" ; virsh desc ${UKVM_VMNAME}

 }


################################################################################


 kvmcreatemvmfc () {
  if [ "${1}" = "-a" ] ; then
   MKVM_VMNAME=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  elif [ $# -lt 2 ] || [ "${1}" = "-h" ] || [ "${1}" = "-help" ] ; then
   echo -e "Usage:          ${FUNCNAME[0]} VM_NAME centos|debian|alpine [VM_NETWORK]
Example:        ${FUNCNAME[0]} microvm01 centos brwan
Automatic mode: ${FUNCNAME[0]} -a [centos|debian|alpine]" ; return 0
  elif [[ "${1}" =~ ^-.* ]] ; then
   /bin/echo -e "Syntax error: ${1}, bad VM name" ; return 0
  elif [ "${2}" != "centos" ] && [ "${2}" != "debian" ] ; then
   /bin/echo -e "Bad OS ${2}" ; return 0
  else
   MKVM_VMNAME="${1}"
  fi
  MKVM_OS="${2:-debian}"
  MKVM_VMKVMNET="${3:-brwan}"
  MKVM_IMG_DIR="/media/donnees/virtualisation/images"
  MKVM_RAM="4194304"
  MKVM_CPU="2"
  MKVM_KERNEL_IMG="/media/donnees/virtualisation/firecracker/kernel/bzImage"
  MKVM_KERNEL_OPT="console=hvc0 console=ttyS0 root=/dev/vda reboot=k panic=1 pci=off nomodules acpi=noirq noapic i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd random.trust_cpu=on rw ipv6.disable=1 net.ifnames=1 biosdevname=1 ip=192.168.0.100::192.168.0.254:255.255.255.0:${MKVM_VMNAME}:eth0:off:192.168.0.254:8.8.8.8:195.83.132.135"
  # ip=::::${MKVM_VMNAME}::on:::

  if [ "${MKVM_OS}" = "centos" ]; then VM_ORG_IMG="/media/donnees/virtualisation/firecracker/originals/firecracker-centos-root.ext4"
  elif [ "${MKVM_OS}" = "alpine" ]; then VM_ORG_IMG="/media/donnees/virtualisation/firecracker/originals/firecracker-alpine-root.ext4"
  else VM_ORG_IMG="/media/donnees/virtualisation/firecracker/originals/firecracker-debian-root.ext4"
  fi

  if [ -f ${MKVM_IMG_DIR}/${MKVM_VMNAME}.raw ] ; then echo "${MKVM_VMNAME} already exist."; return 0 ; fi
  cp ${VM_ORG_IMG} ${MKVM_IMG_DIR}/${MKVM_VMNAME}.raw

  cat > /tmp/mvm-${MKVM_VMNAME}.xml <<-_EOF_
<domain type='kvm'>
  <name>${MKVM_VMNAME}</name>
  <title>${MKVM_VMNAME}</title>
  <description>${MKVM_VMNAME}</description>
  <memory unit='KiB'>${MKVM_RAM}</memory>
  <currentMemory unit='KiB'>${MKVM_RAM}</currentMemory>
  <vcpu placement='static'>${MKVM_CPU}</vcpu>
  <resource>
    <partition>/machine</partition>
  </resource>
  <os>
    <type arch='x86_64' machine='microvm'>hvm</type>
    <kernel>${MKVM_KERNEL_IMG}</kernel>
    <cmdline>${MKVM_KERNEL_OPT}</cmdline>
    <boot dev='hd'/>
  </os>
  <cpu mode='host-passthrough'/>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup'/>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled='no'/>
    <suspend-to-disk enabled='no'/>
  </pm>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='${MKVM_IMG_DIR}/${MKVM_VMNAME}.raw' index='1'/>
      <backingStore/>
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='virtio-mmio'/>
    </disk>
    <controller type='usb' index='0' model='none'>
      <alias name='usb'/>
    </controller>
    <controller type='pci' index='0' model='pcie-root'>
      <alias name='pci.0'/>
    </controller>
    <controller type='virtio-serial' index='0'>
      <alias name='virtio-serial0'/>
      <address type='virtio-mmio'/>
    </controller>
    <interface type='network'>
      <source network='${MKVM_VMKVMNET}'/>
      <model type='virtio'/>
      <target dev='${MKVM_VMNAME}'/>
      <alias name='net0'/>
      <address type='virtio-mmio'/>
    </interface>
    <serial type='pty'>
      <source path='/dev/pts/6'/>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
      <alias name='serial0'/>
    </serial>
    <serial type='dev'>
      <source path='/dev/input/event0'/>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
      <alias name='serial1'/>
    </serial>
    <console type='pty' tty='/dev/pts/6'>
      <source path='/dev/pts/6'/>
      <target type='serial' port='0'/>
      <alias name='serial0'/>
    </console>
    <channel type='unix'>
      <source mode='bind' path='/var/lib/libvirt/qemu/${MKVM_VMNAME}.agent'/>
      <target type='virtio' name='org.qemu.guest_agent.0' state='connected'/>
      <alias name='channel0'/>
      <address type='virtio-serial' controller='0' bus='0' port='1'/>
    </channel>
    <input type='mouse' bus='ps2'>
      <alias name='input0'/>
    </input>
    <input type='keyboard' bus='ps2'>
      <alias name='input1'/>
    </input>
    <memballoon model='virtio'>
      <alias name='balloon0'/>
      <address type='virtio-mmio'/>
    </memballoon>
    <rng model='virtio'>
      <backend model='random'>/dev/urandom</backend>
      <alias name='rng0'/>
      <address type='virtio-mmio'/>
    </rng>
    <vsock model='virtio'>
      <cid auto='yes' address='4'/>
      <alias name='vsock0'/>
      <address type='virtio-mmio'/>
    </vsock>
  </devices>
  <seclabel type='dynamic' model='dac' relabel='yes'>
    <label>+112:+119</label>
    <imagelabel>+112:+119</imagelabel>
  </seclabel>
</domain>
_EOF_
  virsh define /tmp/mvm-${MKVM_VMNAME}.xml
  /bin/rm /tmp/mvm-${MKVM_VMNAME}.xml
  virsh start ${MKVM_VMNAME}
#  virsh console ${MKVM_VMNAME}
 }


################################################################################

 kvmcreatemvmostack () {
  if [ "${1}" = "-a" ] ; then
   MKVM_VMNAME=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  elif [ $# -lt 2 ] || [ "${1}" = "-h" ] || [ "${1}" = "-help" ] ; then
   echo -e "Usage:          ${FUNCNAME[0]} VM_NAME centos|debian [VM_NETWORK]
Example:        ${FUNCNAME[0]} microvm01 centos brwan
Automatic mode: ${FUNCNAME[0]} -a [centos|debian]" ; return 0
  elif [[ "${1}" =~ ^-.* ]] ; then
   /bin/echo -e "Syntax error: ${1}, bad VM name" ; return 0
  elif [ "${2}" != "centos" ] && [ "${2}" != "debian" ] ; then
   /bin/echo -e "Bad OS ${2}" ; return 0
  else
   MKVM_VMNAME="${1}"
  fi
  MKVM_OS="${2:-debian}"
  MKVM_VMKVMNET="${3:-brwan}"
  # MKVM_VMKVMMAC=",mac=52:54:00:00:7A:65"
  MKVM_IMG_DIR="/media/donnees/virtualisation/images"
  MKVM_IMG_EXTENSION="qcow2"
  MKVM_RAM="4096"
  MKVM_CPU="2"
  MKVM_VMUSER="user01"
  MKVM_VMDOMAIN="example.com"
  MKVM_VMINTF="eth0"
  MKVM_KERNEL_IMG="/media/donnees/virtualisation/kernel/bzImage"
  MKVM_KERNEL_OPT="console=hvc0 console=ttyS0 root=/dev/vda reboot=k panic=1 pci=off nomodules rw time ipv6.disable=1 net.ifnames=1 biosdevname=1 selinux=0 apparmor=0 ip=::::${MKVM_VMNAME}::on:::"

  if [ -f ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} ] ; then
   /bin/echo "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} already exists." ; return 0
  fi

  qemu-img create -f ${MKVM_IMG_EXTENSION} ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} 20G
  virt-format --partition=none --filesystem=ext4 --format=${MKVM_IMG_EXTENSION} -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}
  if [ ${MKVM_OS} == "centos" ] ; then
   # MKVM_ORG_IMG="/media/donnees/virtualisation/originals/CentOS-8-ec2-8.2.2004-20200611.2.x86_64.qcow2"
   # MKVM_ORG_PART="/dev/sda2"
   MKVM_ORG_IMG="/media/donnees/virtualisation/originals/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2"
   MKVM_ORG_PART="/dev/sda1"
   MKVM_OS_VARIANT="centos8"
  elif [ ${MKVM_OS} == "debian" ] ; then
   MKVM_ORG_IMG="/media/donnees/virtualisation/originals/debian-10-openstack-amd64.qcow2"
   MKVM_ORG_PART="/dev/sda1"
   MKVM_OS_VARIANT="debian10"
  else
   /bin/echo -n "Bad OS"
   return 0
  fi

  guestfish --ro -a ${MKVM_ORG_IMG} -m ${MKVM_ORG_PART} -- tar-out / - | guestfish --rw -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} -m /dev/sda -- tar-in - /

  virt-customize -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} \
   --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub \
   --hostname ${MKVM_VMNAME} \
   --run-command "/bin/echo -e 'kernel.domainname=${MKVM_VMDOMAIN}\nkernel.hostname=${MKVM_VMNAME}' > /etc/sysctl.d/10-${MKVM_VMNAME}.conf" \
   --run-command "/bin/echo -e 'net.ipv6.conf.${MKVM_VMINTF}.disable_ipv6=1' >> /etc/sysctl.d/10-${MKVM_VMNAME}.conf" \
   --selinux-relabel

  if [ ${MKVM_OS} == "centos" ] ; then
   export MKVM_MIR_HOST="mirrors.ircam.fr"
   export MKVM_MIR_ROOT="pub"
   export MKVM_OS_VERSION="8"
   # To generate the usermod password : openssl passwd or mkpasswd -m sha-512 PASSWORD (whois package)
   virt-customize -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} \
    --run-command "useradd -m -g 100 -G wheel -s /bin/bash -p '' ${MKVM_VMUSER}" \
    --run-command "usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' ${MKVM_VMUSER}" \
    --run-command "usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' root" \
    --ssh-inject ${MKVM_VMUSER}:file:${HOME}/.ssh/id_rsa.pub \
    --install "yum-utils" \
    --run-command "yum-config-manager --nogpgcheck --enable --save --setopt=BaseOS.baseurl=https://${MKVM_MIR_HOST}/${MKVM_MIR_ROOT}/CentOS/${MKVM_OS_VERSION}/BaseOS/x86_64/os" \
    --run-command "yum-config-manager --nogpgcheck --enable --save --setopt=AppStream.baseurl=https://${MKVM_MIR_HOST}/${MKVM_MIR_ROOT}/CentOS/${MKVM_OS_VERSION}/AppStream/x86_64/os" \
    --run-command "yum-config-manager --nogpgcheck --enable --save --setopt=extras.baseurl=https://${MKVM_MIR_HOST}/${MKVM_MIR_ROOT}/CentOS/${MKVM_OS_VERSION}/extras/x86_64/os" \
    --install https://${MKVM_MIR_HOST}/${MKVM_MIR_ROOT}/fedora/epel/${MKVM_OS_VERSION}/Everything/x86_64/Packages/h/haveged-1.9.13-2.el8.x86_64.rpm \
    --install https://${MKVM_MIR_HOST}/${MKVM_MIR_ROOT}/fedora/epel/${MKVM_OS_VERSION}/Everything/x86_64/Packages/s/screen-4.6.2-10.el8.x86_64.rpm \
    --install https://${MKVM_MIR_HOST}/${MKVM_MIR_ROOT}/fedora/epel/${MKVM_OS_VERSION}/Everything/x86_64/Packages/h/htop-2.2.0-6.el8.x86_64.rpm \
    --install "bash-completion,glibc-langpack-en" \
    --uninstall "glibc-all-langpacks,kernel-core,kernel-modules,microcode_ctl.x86_64,gdk-pixbuf2" \
    --run-command "echo -e 'PRETTY_HOSTNAME=${MKVM_VMNAME}\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production' > /etc/machine-info" \
    --run-command 'sed -i "s/\(^OPTIONS=.\).*\(.\)$/\1-4\2/" /etc/sysconfig/chronyd' \
    --firstboot-command "systemctl disable firewalld.service" \
    --selinux-relabel
  elif [ ${MKVM_OS} == "debian" ] ; then
   virt-customize -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} \
    --run-command "useradd -m -g 100 -G sudo -s /bin/bash -p '' ${MKVM_VMUSER}" \
    --run-command "usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' ${MKVM_VMUSER}" \
    --run-command "usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' root" \
    --ssh-inject ${MKVM_VMUSER}:file:${HOME}/.ssh/id_rsa.pub \
    --uninstall 'libpython2.7-stdlib,python3.7-minimal,aptitude-common,locales,grub-common,libicu63,linux-image-4.19.0-9-cloud-amd64,locales-all' \
    --install 'qemu-guest-agent' \
    --run-command 'dpkg-reconfigure --frontend=noninteractive openssh-server ; sed -i "s/^#\{0,1\}\(AddressFamily \).*/\1inet/" /etc/ssh/sshd_config' \
    --run-command "/bin/echo -e 'PRETTY_HOSTNAME=${MKVM_VMNAME}\nICON_NAME=computer\nCHASSIS=vm\nDEPLOYMENT=production' > /etc/machine-info" \
    --run-command "ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime ; echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections ; echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections ; dpkg-reconfigure --frontend=noninteractive tzdata" \
    --run-command "echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections ; echo 'locales locales/default_environment_locale select C.UTF-8' | debconf-set-selections ; apt install locales ; dpkg-reconfigure --frontend=noninteractive locales"
  fi

  if [ -f ${HOME}/.bash_profile ] ; then virt-copy-in -a "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}" ${HOME}/.bash_profile /home/${MKVM_VMUSER}/ ; fi
  if [ -d ${HOME}/.profile.d ] ; then virt-copy-in -a "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}" ${HOME}/.profile.d /home/${MKVM_VMUSER}/ ; fi
  if [ -f ${HOME}/.profile.d/perso-alias_and_variables.sh ] ; then virt-customize -a "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}" --run-command "sed -i \"s/^\([[:space:]]*export LANG=.*$\)/export LANG=C/\" /home/${MKVM_VMUSER}/.profile.d/perso-alias_and_variables.sh" ; fi
  if [ -f ${HOME}/.vimrc ] ; then virt-copy-in -a "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}" ${HOME}/.vimrc /home/${MKVM_VMUSER}/ ; fi
  if [ -f ${HOME}/.screenrc ] ; then virt-copy-in -a "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}" ${HOME}/.screenrc /home/${MKVM_VMUSER}/ ; fi

  virt-sparsify --in-place "${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION}"

  virt-install --connect qemu:///system --virt-type kvm --hvm --import  --name ${MKVM_VMNAME} --machine microvm --arch x86_64 \
   --boot menu=off,useserial=on,kernel=${MKVM_KERNEL_IMG},kernel_args="${MKVM_KERNEL_OPT}" \
   --cpu mode=host-passthrough  --vcpus ${MKVM_CPU} --ram ${MKVM_RAM} \
   --video none --graphics none --sound none  --controller usb,model=none \
   --os-type=linux --os-variant=${MKVM_OS_VARIANT} \
   --disk ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION},format=${MKVM_IMG_EXTENSION},bus=virtio,driver.iommu=on,address.type=virtio-mmio \
   --network=network:${MKVM_VMKVMNET},target=${MKVM_VMNAME},model=virtio,driver.iommu=on,address.type=virtio-mmio${MKVM_VMKVMMAC} \
   --memballoon virtio,driver.iommu=on,address.type=virtio-mmio \
   --rng random,address.type=virtio-mmio \
   --vsock model=virtio,address.type=virtio-mmio \
   --controller type=virtio-serial,driver.iommu=on,address.type=virtio-mmio \
   --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${MKVM_VMNAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0,address.type=virtio-mmio \
   --noautoconsole \
   --features acpi=off,apic=off \
   --qemu-commandline="-M microvm,x-option-roms=off,pit=off,pic=off,isa-serial=off,rtc=off -nodefaults -no-user-config -no-acpi" ; \

  /bin/echo -en "\nWaiting for IP address (through qemu-guest-agent)"
  MKVM_VMWAIT=1
  while [ ${MKVM_VMWAIT} -eq 1 ] ; do
   virsh domifaddr ${MKVM_VMNAME} --source agent > /dev/null 2>&1
   MKVM_VMWAIT=$?
   /bin/echo -n . ; sleep 1
  done
  MKVM_VMKVMIP=$(virsh domifaddr ${MKVM_VMNAME} --source agent | grep $(virsh dumpxml ${MKVM_VMNAME} | grep mac.address | cut -d\' -f2) | tr -s \  | cut -d\  -f5 | cut -d\/ -f1)
  /bin/echo -e "\n\nTo connect to ${MKVM_VMNAME}:\nssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${MKVM_VMUSER} ${MKVM_VMKVMIP}\nor\nvirsh console ${MKVM_VMNAME}"


  # virt-make-fs --format=qcow2 debian-10-genericcloud-amd64-20200511-260.tar ${MKVM_VMNAME}.qcow2
  # virt-format --filesystem=ext4 --format=qcow2 -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.qcow2
  # virt-get-kernel -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} -o /media/donnees/virtualisation/kernel/
  # sudo guestmount -a ${MKVM_IMG_DIR}/${MKVM_VMNAME}.${MKVM_IMG_EXTENSION} -m /dev/sda /media/temp/1/ ; sudo virt-copy-out -a /media/donnees/virtualisation/originals/debian-10-openstack-amd64.qcow2 / /media/temp/1/ ; guestunmount /media/temp/1/
  # MKVM_KERNEL_OPT="console=hvc0 console=ttyS0 root=/dev/vda reboot=k panic=1 pci=off nomodules acpi=noirq noapic i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd random.trust_cpu=on rw ipv6.disable=1 net.ifnames=1 biosdevname=1 ip=192.168.0.100::192.168.0.254:255.255.255.0:${MKVM_VMNAME}:eth0:off:192.168.0.254:8.8.8.8:195.83.132.135"
  # --run-command "systemctl disable networking" \
  # --run-command "systemctl disable apparmor.service" \
  # --run-command "systemctl disable apt-daily-upgrade.timer" \
  # --run-command "systemctl disable apt-daily.timer" \
  # --run-command "systemctl disable cloud-config.service" \
  # --run-command "systemctl disable cloud-final.service" \
  # --run-command "systemctl disable cloud-init-local.service" \
  # --run-command "systemctl disable cloud-init.service" \
  # --run-command "systemctl disable remotefs.service" \
  #
  # MKVM_VMPASSWORD="CHANGEME"
  #  --root-password password:${MKVM_VMPASSWORD} \
  #  --password ${MKVM_VMUSER}:password:${MKVM_VMPASSWORD} \
  #
  # debian
  # --run-command "echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8' | debconf-set-selections" \
  # --run-command "echo 'locales locales/default_environment_locale select fr_FR.UTF-8' | debconf-set-selections" \
  # --run-command "sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen ; dpkg-reconfigure --frontend=noninteractive locales" \
  # centos
  # --firstboot-command "localectl set-locale LANG=fr_FR.utf8 ; localectl set-keymap fr" \
  # --uninstall ",NetworkManager-libnm,cockpit-ws.x86_64,dracut-network.x86_64,cloud-utils-growpart,nfs-utils,sssd-nfs-idmap,libnfsidmap,slang,dracut-config-generic,dracut-config-rescue" \
  # --uninstall ",selinux-policy-targeted,libselinux-utils,python3-babel,platform-python-pip,xfsprogs,mozjs60,cracklib-dicts,geolite2-country,geolite2-city,grub2-common,grub2-tools" \
 }


################################################################################


 kvmcreatepxe() {
  VM_NAME="${1:-pxeclient}"
  VM_TITLE="${1:-pxeclient}"
  VM_DESC="${1:-pxeclient}"
  VM_CPU="2"
  VM_RAM="2048"
  VM_HDD="20G"
  VM_NETWORK="${2:-brwan}"
  VM_IMG_DIR="/media/donnees/virtualisation/images"
  if [ $# -lt 1 ] ; then
   echo "Usage: ${FUNCNAME[0]} VM_NAME [VM_NETWORK]";
  elif [ -f ${VM_IMG_DIR}/${VM_NAME}.qcow2 ] ; then
   echo "${VM_NAME} exist.";
  elif [ ! -d ${VM_IMG_DIR} ] ; then
   echo "${VM_IMG_DIR} does not exist.";
  else
   qemu-img create -f qcow2 ${VM_IMG_DIR}/${VM_NAME}.qcow2 ${VM_HDD}
   virt-install --connect qemu:///system --virt-type kvm --hvm \
    --name ${VM_NAME} --metadata title="${VM_NAME}" --metadata description="${VM_NAME}" \
    --boot uefi,network,hd,menu=off,useserial=on --machine q35 \
    --serial pty --graphics none --video none --sound none \
    --cpu mode=host-passthrough --vcpus ${VM_CPU} --ram ${VM_RAM} \
    --os-type=linux --os-variant=generic --controller usb,model="none" \
    --disk ${VM_IMG_DIR}/${VM_NAME}.qcow2,format=qcow2,bus=virtio \
    --network=network:${VM_NETWORK},model=virtio --noautoconsole \
    --memballoon virtio --rng /dev/random \
    --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${VM_NAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0 \
    --pxe
#    --cpu mode='host-model' --controller usb,model="none" \
#    --network=network:${NETNAME},portgroup="${VM_NETPG}",model=virtio,mac=${VMMAC},virtualport_type=openvswitch \
  fi
 }


################################################################################


 kvmcreatecihttp() { 
  VM_NAME="${1:-ciclient}"
  VM_TITLE="${1:-ciclient}"
  VM_DESC="${1:-ciclient}"
  VM_CPU="2"
  VM_RAM="2048"
  VM_HDD="20G"
  VM_NETWORK="brwan"
  VM_BRIDGE=$(virsh net-dumpxml ${VM_NETWORK} | grep "bridge name" | cut -d\' -f2)
  VM_VMPASSW="CHANGEME"
  VM_ORG_DIR="/media/donnees/virtualisation/originals"
  VM_IMG_DIR="/media/donnees/virtualisation/images"
  VM_DEB_ORG_IMG_URL_ROOT="http://cdimage.debian.org/cdimage/openstack/current-10/"
  VM_CENT_ORG_IMG_URL_ROOT="https://cloud.centos.org/centos/8/x86_64/images/"
  VM_DEB_ORG_IMG_URL="${VM_DEB_ORG_IMG_URL_ROOT}$(wget -q -O - ${VM_DEB_ORG_IMG_URL_ROOT} | grep -o "debian-[0-9]*-openstack-amd64.qcow2" | tac | head -n 1)"
  VM_CENT_ORG_IMG_URL="${VM_CENT_ORG_IMG_URL_ROOT}$(wget -q -O - ${VM_CENT_ORG_IMG_URL_ROOT} | grep -o "CentOS-8-GenericCloud[a-zA-Z0-9_.-]*.qcow2" | tac | head -n 1)"
  VM_GITLAB_URL="https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/cloud-init/"
  if [[ $# != 3 && $# != 4 ]] ; then /bin/echo -e "Usage: ${FUNCNAME[0]} VM_NAME centos|debian static|dhcp [ip_address]\nSubnet: 192.168.0.0/24"; return 0 ; fi
  if [ -f ${VM_IMG_DIR}/${VM_NAME}.qcow2 ] ; then echo "${VM_NAME} already exist."; return 0 ; fi
  if [ ! -d ${VM_IMG_DIR} ] ; then echo "${VM_IMG_DIR} does not exist."; return 0 ; fi
  if [ ! -d ${VM_ORG_DIR} ] ; then echo "${VM_ORG_DIR} does not exist."; return 0 ; fi

  if [ "$3" != "static" ] ; then
   VM_NETMODE="dhcp"
  else
   VM_NETMODE="static"
   if [[ "$(echo ${4} | cut -d. -f1,2,3)" =~ "$(ip add show ${VM_BRIDGE} | grep inet\  | tr -s ' ' | cut -d\  -f3 | cut -d. -f1,2,3)" ]] ; then
    VM_NETMODE="${VM_NAME}-${4}"
    sudo /usr/bin/ip neigh del ${4} dev ${VM_BRIDGE} ; ping -q -c 3 ${4}
    [ $(ip nei show "${4}" | grep lladdr | wc -l) -gt 0 ] && { /bin/echo -e "${4} already in use." ; return 0 ; }
   else
    /bin/echo -e "Bad IP addr. "${4:-"Please, provide an IP addr"}"\nSubnet: 192.168.0.0/24" ; return 0
   fi
  fi

  VM_USERDATA_URL="${VM_GITLAB_URL}${VM_NETMODE}/user-data"
  if [ $(wget -O /dev/null ${VM_USERDATA_URL} 2>&1 | grep -F HTTP | grep -c 200\ OK) == 0 ] ; then
   /bin/echo -e "${VM_USERDATA_URL} does not exist." ; return 0
  fi

  qemu-img create -f qcow2 ${VM_IMG_DIR}/${VM_NAME}.qcow2 ${VM_HDD}
  [ $2 == "debian" ] && [ ! -f ${VM_ORG_DIR}/debian.qcow2 ] && { wget -q -O ${VM_ORG_DIR}/debian.qcow2 ${VM_DEB_ORG_IMG_URL}; }
  [ $2 == "debian" ] && { virt-resize -q --expand /dev/vda1 ${VM_ORG_DIR}/debian.qcow2 ${VM_IMG_DIR}/${VM_NAME}.qcow2; }
  [ $2 == "centos" ] && [ ! -f ${VM_ORG_DIR}/centos.qcow2 ] && { wget -q -O ${VM_ORG_DIR}/centos.qcow2 ${VM_CENT_ORG_IMG_URL}; }
  [ $2 == "centos" ] && { virt-resize -q --expand /dev/vda1 ${VM_ORG_DIR}/centos.qcow2 ${VM_IMG_DIR}/${VM_NAME}.qcow2; }

#  virt-customize -a ${VM_IMG_DIR}/${VM_NAME}.qcow2 --run-command "hostnamectl set-hostname ${VM_NAME}.$(hostname -d)"
#  virt-customize -a ${VM_IMG_DIR}/${VM_NAME}.qcow2 --run-command "echo \"kernel.hostname = ${VM_NAME}\" >> /etc/sysctl.conf"
  virt-customize -a ${VM_IMG_DIR}/${VM_NAME}.qcow2 --root-password password:${VM_VMPASSW} \
   --run-command "/bin/echo -e \"kernel.hostname=${VM_NAME}\nkernel.domainname=$(hostname -d)\" >> /etc/sysctl.d/01-perso.conf"

  virt-install --connect qemu:///system --virt-type kvm --hvm --import \
   --name ${VM_NAME} --metadata title="${VM_NAME}" --metadata description="${VM_NAME}" \
   --boot menu=off,useserial=on --machine q35 \
   --serial pty --graphics none --video none --sound none \
   --cpu mode=host-passthrough --vcpus ${VM_CPU} --ram ${VM_RAM} \
   --os-type=linux --os-variant=generic \
   --disk ${VM_IMG_DIR}/${VM_NAME}.qcow2,format=qcow2,bus=virtio \
   --network=network:${VM_NETWORK},model=virtio --noautoconsole \
   --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${VM_NAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0 \
   --qemu-commandline="-smbios type=1,serial=ds=nocloud-net;s=${VM_GITLAB_URL}${VM_NETMODE}/"
#   --boot uefi,menu=off,useserial=on --machine q35 \
#   --qemu-commandline="-smbios type=1,serial=ds=nocloud-net;s=http://10.71.86.252/kvm/${VM_NAME}/${VM_NETMODE}/"
#   --disk /tmp/VM_mini.20190930223709/mini-cidata.iso,device=cdrom,bus=virtio
#   --extra-args="ip=::::${VM_NAME}.$(hostname -d):eth0:on::: selinux=0 apparmor=0 nomodeset 3" \
 }

################################################################################

 kvmcreateciiso() {
  VM_NAME="$1"
  VM_TITLE="$1"
  VM_DESC="$1"
  VM_CPU="2"
  VM_RAM="4096"
  VM_HDD="40G"
  VM_NETWORK="default"
  VM_ORG="/media/donnees/virtualisation/originals"
  [ -d ${VM_ORG} ] || mkdir ${VM_ORG}
  VM_IMG="/media/donnees/virtualisation/images"
  [ -d ${VM_IMG} ] || mkdir ${VM_IMG}
  VM_TMPDIR="/tmp/VM_${VM_NAME}_$(date +%Y%m%d%H%M%S)"
  VM_DEB_ORG_IMG_URL_ROOT="http://cdimage.debian.org/cdimage/openstack/current-10/"
  VM_CENT_ORG_IMG_URL_ROOT="https://cloud.centos.org/centos/8/x86_64/images/"
  VM_DEB_ORG_IMG_URL="${VM_DEB_ORG_IMG_URL_ROOT}$(wget -q -O - ${VM_DEB_ORG_IMG_URL_ROOT} | grep -o "debian-[0-9]*-openstack-amd64.qcow2" | tac | head -n 1)"
  VM_CENT_ORG_IMG_URL="${VM_CENT_ORG_IMG_URL_ROOT}$(wget -q -O - ${VM_CENT_ORG_IMG_URL_ROOT} | grep -o "CentOS-8-GenericCloud[a-zA-Z0-9_.-]*.qcow2" | tac | head -n 1)"
  if [ $# != 3 ] ; then
   echo "Usage: ${FUNCNAME[0]} VM_NAME centos|debian static|dhcp";
  elif [ -f ${VM_IMG}/${VM_NAME}.qcow2 ] ; then
   echo "${VM_NAME} exist.";
  else
   [ ! -d ${VM_ORG} ] && { mkdir -p ${VM_ORG}; }
   [ ! -d ${VM_IMG} ] && { mkdir -p ${VM_IMG}; }
   qemu-img create -f qcow2 ${VM_IMG}/${VM_NAME}.qcow2 ${VM_HDD}
   [ $2 == "debian" ] && [ ! -f ${VM_ORG}/debian.qcow2 ] && { wget -q -O ${VM_ORG}/debian.qcow2 ${VM_DEB_ORG_IMG_URL}; }
   [ $2 == "debian" ] && { virt-resize -q --expand /dev/vda1 ${VM_ORG}/debian.qcow2 ${VM_IMG}/${VM_NAME}.qcow2; }
   [ $2 == "centos" ] && [ ! -f ${VM_ORG}/centos.qcow2 ] && { wget -q -O ${VM_ORG}/centos.qcow2 ${VM_CENT_ORG_IMG_URL}; }
   [ $2 == "centos" ] && { virt-resize -q --expand /dev/vda1 ${VM_ORG}/centos.qcow2 ${VM_IMG}/${VM_NAME}.qcow2; }
   mkdir ${VM_TMPDIR}
   printf "#cloud-config\npassword: \$6\$rounds=4096\$J5BXR123blablabla456OWtnbnOuChZAHRVB56hIaj.\nchpasswd: { expire: False }\nssh_pwauth: True\n" > ${VM_TMPDIR}/user-data
   if [ $3 == static ] ; then
    printf "instance-id: iid-${VM_NAME}01\nlocal-hostname: ${VM_NAME}\nnetwork-interfaces: |\n  iface eth0 inet static\n  address 10.71.86.99/24\n  gateway 10.71.86.33\n  dns-nameservers 10.71.86.252 8.8.8.8\n  dns-domain dmz01.$(hostname -d)\n  dns-search dmz01.$(hostname -d)\nhostname: ${VM_NAME}\n" > ${VM_TMPDIR}/meta-data
    printf "bootcmd:\n  - sed -i '/iface eth/d' /etc/network/interfaces\n  - sed -i 's/^allow-hotplug eth0$/auto eth0/' /etc/network/interfaces\n  - sed -i 's/^ONBOOT=no$/ONBOOT=yes/' /etc/sysconfig/network-scripts/ifcfg-eth0\n  - ifdown eth0\n  - ifup eth0 " >> ${VM_TMPDIR}/user-data
   else printf "instance-id: iid-${VM_NAME}01\nlocal-hostname: ${VM_NAME}\n" > ${VM_TMPDIR}/meta-data ; fi
   genisoimage -output ${VM_TMPDIR}/seed.iso -volid cidata -joliet -rock ${VM_TMPDIR}/user-data ${VM_TMPDIR}/meta-data
   virt-install --connect qemu:///system --virt-type kvm --hvm --import \
    --name ${VM_NAME} --metadata title="${VM_NAME}" --metadata description="${VM_NAME}" \
    --boot menu=off,useserial=on --serial pty --graphics none \
    --video virtio --sound none --controller usb,model="none" \
    --cpu mode=host-model --vcpus ${VM_CPU} --ram ${VM_RAM} \
    --os-type=linux --os-variant=generic \
    --disk ${VM_IMG}/${VM_NAME}.qcow2,format=qcow2,bus=virtio \
    --network=network:${VM_NETWORK},model=virtio --noautoconsole \
    --disk ${VM_TMPDIR}/seed.iso,device=cdrom,bus=virtio
  fi
 }


################################################################################


 kvmcreatehelp() {
 echo -e "Usefull Commands:
-----------------
VM_NAME=\"mini\"
VM_VMIMG=\"/media/donnees/virtualisation/images/${VM_NAME}.qcow2\"
VM_NIC=\"eth0\"
VM_NET=\"brdmz01\"
VM_NETPG=\"vlan086\"
VM_NETMODE=\"static\" # VM_NETMODE=\"dhcp\"
VM_IP=\"10.71.88.99/24\"
VM_MAC=\"52:54:00:AF:88:63\"
VM_CPU=\"2\"
VM_RAM=\"4096\"
VM_HDD=\"40G\"
VM_CDROM=\"vdb\"
VM_USER=\"${USER:-${USERNAME}}\"
VM_DOMAINNAME=\"dmz01.$(hostname -d)\"
VM_DEB_ORG_IMG_URL_ROOT=\"http://cdimage.debian.org/cdimage/openstack/current-10/\"
VM_CENT_ORG_IMG_URL_ROOT=\"https://cloud.centos.org/centos/8/x86_64/images/\"
VM_DEB_ORG_IMG_URL=\"\${VM_DEB_ORG_IMG_URL_ROOT}\$(wget -q -O - \${VM_DEB_ORG_IMG_URL_ROOT} | grep -o "debian-[0-9]*-openstack-amd64.qcow2" | tac | head -n 1)\"
VM_CENT_ORG_IMG_URL=\"\${VM_CENT_ORG_IMG_URL_ROOT}\$(wget -q -O - \${VM_CENT_ORG_IMG_URL_ROOT} | grep -o "CentOS-8-GenericCloud[a-zA-Z0-9_.-]*.qcow2" | tac | head -n 1)\"
export LIBVIRT_DEFAULT_URI=\"qemu+ssh://\${USER:-${USERNAME}}@\${HOSTNAME}/system\"

qemu-img create -f qcow2 \${VM_IMG}/\${VM_NAME}.qcow2 \${VM_HDD}
virt-resize -q --expand /dev/vda1 \${VM_ORG}/centos.qcow2 \${VM_IMG}/\${VM_NAME}.qcow2;
virt-install --connect qemu:///system --virt-type kvm --hvm \\
  --name \${VM_NAME} --metadata title=\"\${VM_NAME}\" --metadata description=\"\${VM_NAME}\" \\
  --boot menu=off,useserial=on --serial pty --graphics none \\
  --video virtio --sound none --controller usb,model=\"none\" \\
  --cpu mode=host-model --vcpus \${VM_CPU} --ram \${VM_RAM} \\
  --os-type=linux --os-variant=generic \\
  --disk \${VM_IMG}/\${VM_NAME}.qcow2,format=qcow2,bus=virtio \\
  --network=network:\${VM_NET},model=virtio --noautoconsole \\
  --pxe \\
#  --cpu mode='host-passthrough' \\
#  --network=network:\${VM_NET},portgroup=\"\${VM_NETPG}\",model=virtio,mac=\${VM_MAC},virtualport_type=openvswitch \\
#  --disk /tmp/VM_mini.20190930223709/mini-cidata.iso,device=cdrom,bus=virti\o
#  --qemu-commandline="-smbios type=1,serial=ds=nocloud-net\;s=http://10.71.86.252/kvm/\${VM_NAME}/\${VM_NETMODE}/" \\



virt-sparsify --in-place \${VM_VMIMG}
guestmount -i  -a \${VM_VMIMG} /media/temp1/
guestfish --ro -a \${VM_VMIMG} -i command \"ls\"
guestfish --rw -a \${VM_VMIMG} -i edit /etc/sysconfig/selinux
virt-customize -a \${VM_VMIMG} --root-password password:CHANGEME
virt-customize -a \${VM_VMIMG} --password \${VM_USER}:password:CHANGEME
virt-customize -d \${VM_NAME} --ssh-inject \${VM_USER}:file:/root/.ssh/id_rsa.pub
virt-customize -d \${VM_NAME} --hostname \${VM_NAME}.\${VM_DOMAINNAME}
virt-customize -d \${VM_NAME} --update --selinux-relabel
virt-customize -d \${VM_NAME} --install screen,bash-completion,psmisc,tcpdump,bind-utils,telnet,qemu-guest-agent,xauth,curl,nmap,iperf3,nftables --selinux-relabel
virt-customize -d \${VM_NAME} --mkdir /root/tmp
virt-customize -d \${VM_NAME} --upload downloads/script.sh:/root/tmp/script.sh
virt-customize -d \${VM_NAME} --run /root/tmp/script.sh
virt-customize -d \${VM_NAME} --delete /root/tmp/script.sh
virt-customize -d \${VM_NAME} --run-command \"rmdir /root/tmp\"
virt-viewer \${VM_NAME}
virsh desc \${VM_NAME} --config --live \"Network=\${VM_NET}, IP=\${VM_IP}, MAC=\${VM_MAC}\"
virsh desc \${VM_NAME} --config --live --title \"\${VM_NAME} \${VM_IP} \${VM_MAC}\"
virsh change-media \${VM_NAME} \${VM_CDROM} --eject --config
virsh destroy \${VM_NAME}
virsh undefine \${VM_NAME}
virsh send-key \${VM_NAME} --holdtime 1000 KEY_LEFTCTRL KEY_LEFTALT KEY_DELETE
virsh dominfo \${VM_NAME}
virsh domstats \${VM_NAME}
virsh domifaddr \${VM_NAME} --source agent --interface \${VM_NIC}
virsh console \${VM_NAME}
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l \${VM_USER} \${VM_IP:0:-3}"

 }


fi
