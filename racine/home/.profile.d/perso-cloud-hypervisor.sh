if [ ${PERSO_ENABLED} = 1 ] ; then

 chyperinit () {
  if [[ ${1} != "-y" ]]; then
   echo "Virtualisation directories creation and download of cloud-hypervisor, hypervisor-fw and firecracker."
   echo "Usage:"
   echo "If you are sure : ${FUNCNAME[0]} -y"
   return 0
  fi
  CH_ORIGINALS_DIR="/media/donnees/virtualisation/originals/"
  CH_IMG_DIR="/media/donnees/virtualisation/images/"
  #
  CH_FW_BIN="hypervisor-fw"
  CH_FW_URL="https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/0.2.7/hypervisor-fw"
  CH_FW_DIR="/media/donnees/virtualisation/kernel/"
  #
  CH_CH_BIN="cloud-hypervisor"
  CH_CH_URL="https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/v0.7.0/cloud-hypervisor"
  CH_CH_DIR="/media/donnees/virtualisation/bin/"
  #
  CH_CHREMOTE_BIN="ch-remote"
  CH_CHREMOTE_URL="https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/v0.7.0/ch-remote"
  CH_CHREMOTE_DIR="/media/donnees/virtualisation/bin/"
  #
  CH_FC_BIN="firecracker"
  CH_FC_URL="https://github.com/firecracker-microvm/firecracker/releases/download/v0.21.1/firecracker-v0.21.1-x86_64"
  CH_FC_DIR="/media/donnees/virtualisation/bin/"

  for CH_DIR_COUNTER in ${CH_ORIGINALS_DIR} ${CH_IMG_DIR} ${CH_FW_DIR} ${CH_CH_DIR} ${CH_CHREMOTE_DIR} ${CH_FW_DIR} ; do
   if [[ ! -d ${CH_DIR_COUNTER} ]] ; then
    echo "${CH_DIR_COUNTER}  directory creation"
    sudo mkdir -p ${CH_DIR_COUNTER}
    sudo chown ${USER:-${USERNAME}}:libvirt-qemu ${CH_DIR_COUNTER}
   fi
  done


  for CH_BIN_LOOP in FW CH CHREMOTE FC ; do
   CH_TMP_DIR="CH_${CH_BIN_LOOP}_DIR"
   CH_TMP_BIN="CH_${CH_BIN_LOOP}_BIN"
   CH_TMP_URL="CH_${CH_BIN_LOOP}_URL"

   if [[ ! -f "${!CH_TMP_DIR}${!CH_TMP_BIN}" ]] ; then
    echo "${!CH_TMP_DIR}${!CH_TMP_BIN} program download"
    wget -q -O ${!CH_TMP_DIR}${!CH_TMP_BIN} ${!CH_TMP_URL}
    chmod +x ${!CH_TMP_DIR}${!CH_TMP_BIN}
    if [[ ${CH_BIN_LOOP} == "CH" || ${CH_BIN_LOOP} == "FC" ]] ; then
     sudo setcap cap_net_admin+ep ${!CH_TMP_DIR}${!CH_TMP_BIN}
    fi
   fi
  done

  if [[ ! $(which kvm) ]] ; then
   if [ -f /etc/debian_version ]; then apt -y install kvm ; fi
   if [ -f /etc/redhat-release ]; then yum -y install kvm ; fi
   if [ -f /etc/alpine-release ] ; then apk add kvm ; fi
  fi

  return 0
 }


###################################################################

 chyperfirewall () {
  echo "Tips to configure firewall (nftables)

sysctl -w net.ipv4.ip_forward=1

nft add rule inet filter FORWARD iifname vmtap* accept
nft add rule inet filter FORWARD oifname vmtap* ct state related,established accept
nft add rule ip nat postrouting iifname vmtap* masquerade

nft add rule inet filter forward-tcp iifname vmtap* accept
nft add rule inet filter forward-tcp-ct oifname vmtap* ct state related,established accept
nft add rule inet filter forward-udp iifname vmtap* accept
nft add rule ip nat postrouting iifname vmtap* masquerade
"
 }


###################################################################


 chyperscreeninit () {
  export CHSCREENRC="/tmp/ch-screenrc"
  export CHSCREENNAME="virt"

  if [[ ! -e ${CHSCREENRC} ]]; then
   cat /etc/screenrc | grep -v ^# | uniq > ${CHSCREENRC}
   echo 'defshell -bash' >> ${CHSCREENRC}
   echo 'hardstatus on' >> ${CHSCREENRC}
   echo 'hardstatus alwayslastline' >> ${CHSCREENRC}
   echo 'hardstatus string "%{=b Kg} %H %{= Kk}|%{= KW} %-Lw%{= yk}%n %f %t%{-}%+Lw %=%{= Kk}|%{= KW} Sess:%{=b Kg} %S %{= Kk}|%{= KW} Load:%{=b Kg} %l %{= Kk}|%{= KW} %D %d/%m/%Y%{=b Kg} %c:%s"' >> ${CHSCREENRC}
  fi
  if ! screen -list | grep -q "${CHSCREENNAME}"; then
   screen -c ${CHSCREENRC} -S ${CHSCREENNAME} -t terminal -d -m
  fi
 }



###################################################################

 chyperdeblasturl () {
  DEBREPOROOT="https://cdimage.debian.org/cdimage/cloud/buster"
  DEBREPOSUBDIR=$(curl -s ${DEBREPOROOT}/ | grep folder | sort | tail -n 1 | sed "s/.*href=\"\(.*-.*\)\/\".*/\1/")
  DEBREPOLASTFILE=$(curl -s ${DEBREPOROOT}/${DEBREPOSUBDIR}/ | grep debian-.*-genericcloud-amd64-.*.tar.xz | sed "s/.*href=\"\(debian.*tar.xz\)\".*/\1/")
  echo "${DEBREPOROOT}/${DEBREPOSUBDIR}/${DEBREPOLASTFILE}"
 }

 chypercentlasturl () {
  CENTREPOROOT="https://cloud.centos.org/centos/8/x86_64/images"
  CENTREPOLASTFILE=$(curl -s ${CENTREPOROOT}/ | grep qcow2 | grep CentOS.*GenericCloud | sed "s/.*href=\"\(CentOS.*qcow2\)\".*/\1/")
  echo "${CENTREPOROOT}/${CENTREPOLASTFILE}"
 }


###################################################################


 chyperdeb () {
  VM_ORIGINALSDIR="/media/donnees/virtualisation/originals/"
  VM_IMGDIR="/media/donnees/virtualisation/images/"
  VM_DOMAIN="$(hostname -d)"
  VM_USERNAME="${USER:-${USERNAME}}"
  VM_USERPWD="CHANGEME"
  VM_IMGURL="$(chyperdeblasturl)"
  VM_ORGIMGNAME="disk.raw"
  VM_HOSTNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
  VM_CPU=2
  VM_RAM="2048M"
  VM_IMGSIZE="20G"
  VM_SUBNET="192.168.1"
  VM_IPPREFIX="31"
  VM_IPMASK=$(set -- $(( 5 - (${VM_IPPREFIX} / 8) )) 255 255 255 255 $(( (255 << (8 - (${VM_IPPREFIX} % 8))) & 255 )) 0 0 0 ; [ ${1} -gt 1 ] && shift ${1} || shift ; echo ${1-0}.${2-0}.${3-0}.${4-0})
  VM_DNS="8.8.8.8"
  VM_NTP="80.74.64.1"
  VM_VMIF="eth0"
  VM_VMBRIDGE="brwan"
  VM_IPDYNMIN=150
  VM_IPDYNMAX=199

  if [[ ${1} != "-a" && ${1} ]]; then VM_HOSTNAME="${1}" ; fi

  VM_IF="${VM_HOSTNAME}"

  if [[ $2 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]] ; then VM_SUBNET="$(echo ${2} | awk -F\. '{ print $1"."$2"."$3 }')" ; fi

  if [[ ${1} == "-h" || ! ${1} ]] || [[ ! $2 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} && $2 ]] ; then
   echo -e \
    "Usage:\n" \
    "Automatic mode : ${FUNCNAME[0]} -a\n" \
    "Manual mode    : ${FUNCNAME[0]} VM_NAME VM_IP_ADDRESS\n" \
    "This message   : ${FUNCNAME[0]} -h\n\n" \
    "Network subnet to use : ${VM_SUBNET}.${VM_IPDYNMIN}-${VM_SUBNET}.${VM_IPDYNMAX}\n" \
    "Password setting via virt-customize has been replace by usermod in order to encrypt it.\n" \
    "To generate the usermod password : openssl passwd or mkpasswd -m sha-512 PASSWORD (whois package)"
   return 0
  fi

  VM_DEBIPRANDOM=0
  while [ ${VM_DEBIPRANDOM} -le 150 ] || [ ${VM_DEBIPRANDOM} -ge 199 ] || [ -f /tmp/ch-${VM_HOSTNAME}-${2:-${VM_SUBNET}.${VM_DEBIPRANDOM}}.sock ] ; do
   VM_DEBIPRANDOM=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 3)
  done
  VM_IPADDR="${2:-${VM_SUBNET}.${VM_DEBIPRANDOM}}"
  VM_IPADDREND="$(echo ${VM_IPADDR} | cut -d. -f4)"
  if [[ $((${VM_IPADDREND} % 2)) == 0 ]] ; then VM_HV_IPADDREND=$((VM_IPADDREND+1)) ; else VM_HV_IPADDREND=$((VM_IPADDREND-1)) ; fi
  VM_MAC="fe:54:00:af:00:$(echo "obase=16;${VM_IPADDREND}" | bc)"
  VM_IPGW="${VM_SUBNET}.${VM_HV_IPADDREND}"

  if [ -e /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ] ; then echo "IP Address already in use" ; fi
  if [ -e ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 ] ; then echo "VM Disk already in use" ; fi

  echo "Image download" ; wget -q -O ${VM_ORIGINALSDIR}${VM_HOSTNAME}.raw.tar.xz "${VM_IMGURL}"
  echo "Image untar" ; tar Jxf ${VM_ORIGINALSDIR}${VM_HOSTNAME}.raw.tar.xz -C ${VM_ORIGINALSDIR}
  echo "Image rename" ; mv ${VM_ORIGINALSDIR}${VM_ORGIMGNAME} ${VM_IMGDIR}${VM_HOSTNAME}.raw


  virt-customize -a ${VM_IMGDIR}${VM_HOSTNAME}.raw \
   --run-command "
    cat > /etc/systemd/network/20-wired.network << EOF
[Match]
Name=${VM_VMIF}

[Network]
LinkLocalAddressing=no
DHCP=no
Address=${VM_IPADDR}/${VM_IPPREFIX}
Gateway=${VM_IPGW}
EOF

cat > /etc/systemd/network/20-wired.link << EOF
[Match]
#OriginalName=${VM_VMIF}
Type=ether

[Link]
AutoNegotiation=1
Name=${VM_VMIF}
EOF

    cat >> /etc/sysctl.conf << EOF
kernel.domainname = ${VM_DOMAIN}
kernel.hostname = ${VM_HOSTNAME}

net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.${VM_VMIF}.disable_ipv6 = 1
EOF

cat > /etc/machine-info << EOF
PRETTY_HOSTNAME=${VM_HOSTNAME}
ICON_NAME=computer
CHASSIS=vm
DEPLOYMENT=production
EOF

cat >> /etc/hosts << EOF
${VM_IPADDR} ${VM_HOSTNAME}.${VM_DOMAIN} ${VM_HOSTNAME}
${VM_IPGW} gw.${VM_DOMAIN} gw
${VM_NTP} ntp.${VM_DOMAIN} ntp
EOF

    cat >> /etc/profile.d/perso-scripts.sh << 'EOF'
set completion-ignore-case on
set +o noclobber
shopt -s checkwinsize
shopt -s histappend
[[ $- == *i* ]] && stty werase undef
[[ $- == *i* ]] && bind '\C-w:unix-filename-rubout'

alias la='\ls -a --color=auto'
alias ll='\ls -al --color=auto'
alias l='\ls -a1 --color=auto'
alias lrt='\ls -a1rt --color=auto'
alias llrt='\ls -alrt --color=auto'

export TERM=linux

resize_window () {
 old=\$(stty -g)
 stty raw -echo min 0 time 5
 printf '\0337\033[r\033[999;999H\033[6n\0338' > /dev/tty
 IFS='[;R' read -r _ rows cols _ < /dev/tty
 stty "\$old"
 stty cols "\$cols" rows "\$rows"
}
uwt () { echo -ne \"\033]0;\${1:-\${HOSTNAME}}\007\"; }
EOF
" \
   --root-password password:${VM_USERPWD} \
   --run-command "
    sed -i \"s/^#\{0,1\}\(DNS=\).*/\1${VM_DNS}/\" /etc/systemd/resolved.conf ;
    sed -i \"s/^#\{0,1\}\(LLMNR=\).*/\1no/\" /etc/systemd/resolved.conf ;
    sed -i \"s/^#\{0,1\}\(MulticastDNS=\).*/\1no/\" /etc/systemd/resolved.conf ;
    sed -i \"s/^#\{0,1\}\(NTP=\).*/\1${VM_NTP}/\" /etc/systemd/timesyncd.conf ;
    sed -i \"s/^#\{0,1\}\(AddressFamily \).*/\1inet/\" /etc/ssh/sshd_config ;
    sysctl -p ;
    systemctl disable networking ; systemctl stop networking ;
    systemctl disable ntp ; systemctl stop ntp ;
    systemctl disable apparmor ; systemctl stop apparmor ;
    systemctl disable chronyd ; systemctl stop chronyd ;
    systemctl disable apt-daily-upgrade.timer ; systemctl disable apt-daily.timer ;
    systemctl enable systemd-networkd ; systemctl restart systemd-networkd ;
    systemctl enable systemd-resolved ; systemctl restart systemd-resolved ;
    systemctl enable systemd-timesync ; systemctl restart systemd-timesync ;
    dpkg-reconfigure --frontend=noninteractive openssh-server ;
    systemctl restart sshd ;
    sed -i \"s/\(^GRUB_CMDLINE_LINUX=.\).*$/\1console=ttyS0 no_timer_check crashkernel=auto random.trust_cpu=on i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd net.ifnames=0 biosdevname=1 ipv6.disable=0 ip=${VM_IPADDR}::${VM_IPGW}:255.255.255.254:${VM_HOSTNAME}:eth0:off::: \\\"/\" /etc/default/grub ;
    update-grub2
    " \
   --link /run/systemd/resolve/stub-resolv.conf:/etc/resolv.conf \
   --update --install software-properties-common \
   --run-command "add-apt-repository contrib ; add-apt-repository non-free" \
   --update --install screen,bash-completion,sudo,haveged,htop \
   --run-command "systemctl enable haveged ; systemctl restart haveged" \
   --run-command "useradd -m -p '' ${VM_USERNAME}" \
   --password ${VM_USERNAME}:password:${VM_USERPWD} \
   --run-command "adduser ${VM_USERNAME} sudo" \
   --ssh-inject ${VM_USERNAME}:file:${HOME}/.ssh/id_rsa.pub \
   --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub \
   --uninstall cloud-init \
   --move /etc/network/cloud-interfaces-template:/etc/network/cloud-interfaces-template.sav \
   --run-command "adduser ${VM_USERNAME} sudo" ; \
  virt-customize -a ${VM_IMGDIR}${VM_HOSTNAME}.raw \
   --run-command "/usr/sbin/usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' ${VM_USERNAME}" \
   --run-command "/usr/sbin/usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' root" \
   --run-command "chsh -s /bin/bash ${VM_USERNAME}" \
   --append-line /etc/issue:"IP addr: ${VM_IPADDR}" --append-line /etc/issue.net:"IP addr: ${VM_IPADDR}" \
   --append-line /etc/issue:"Gateway: ${VM_IPGW}" --append-line /etc/issue.net:"Gateway: ${VM_IPGW}" \
   --append-line /etc/issue:"User: ${VM_USERNAME}" --append-line /etc/issue.net:"User: ${VM_USERNAME}" \
   --append-line /etc/issue:""  --append-line /etc/issue.net:"" \
   --firstboot-command "
    apt-get -y remove --purge cloud-initramfs-growroot ;
    echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, fr_FR.UTF-8 UTF-8' | debconf-set-selections ;
    echo 'locales locales/default_environment_locale select fr_FR.UTF-8' | debconf-set-selections ;
    sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen ;
    dpkg-reconfigure --frontend=noninteractive locales ;
    ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime ;
    echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections ;
    echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections ;
    dpkg-reconfigure --frontend=noninteractive tzdata
    "


  echo "Image resize"            ; qemu-img resize -q -f raw ${VM_IMGDIR}${VM_HOSTNAME}.raw ${VM_IMGSIZE}
  echo "Image conversion"        ; qemu-img convert -q -O qcow2 ${VM_IMGDIR}${VM_HOSTNAME}.raw ${VM_IMGDIR}${VM_HOSTNAME}.qcow2
  echo "Original Image deletion" ; /bin/rm -f ${VM_IMGDIR}${VM_HOSTNAME}.raw ${VM_ORIGINALSDIR}${VM_HOSTNAME}.raw.tar.xz

  chyperscreeninit

  screen -S virt -X screen -t ${VM_HOSTNAME} sh -c "\
/media/donnees/virtualisation/bin/cloud-hypervisor \
--kernel /media/donnees/virtualisation/kernel/hypervisor-fw \
--disk path=${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \
--cpus boot=${VM_CPU} \
--memory size=${VM_RAM} \
--net tap=,mac=${VM_MAC},ip=${VM_SUBNET}.${VM_HV_IPADDREND},mask=${VM_IPMASK},num_queues=4,queue_size=256 \
--api-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock \
--rng  --console off --serial tty ; \
/bin/rm -f /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ; \
/bin/rm -i ${VM_IMGDIR}${VM_HOSTNAME}.qcow2"

  echo -e "
Hostname : ${VM_HOSTNAME}
OS       : Debian
IP addr  : ${VM_IPADDR}/${VM_IPMASK}
Gateway  : ${VM_IPGW}

Console command :
screen -r virt

SSH command :
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${VM_USERNAME} ${VM_IPADDR}

### Rerun VM !!! IF NEEDED ###
screen -S virt -X screen -t ${VM_HOSTNAME} \\
sh -c \"/media/donnees/virtualisation/bin/cloud-hypervisor \\
--kernel /media/donnees/virtualisation/kernel/hypervisor-fw \\
--disk path=${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \\
--cpus boot=${VM_CPU} \\
--memory size=${VM_RAM} \\
--net tap=,mac=${VM_MAC},ip=${VM_SUBNET}.${VM_HV_IPADDREND},mask=${VM_IPMASK},num_queues=4,queue_size=256 \\
--rng  --console off --serial tty \\
--api-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ; \\
/bin/rm -f /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ; \\
/bin/rm -i ${VM_IMGDIR}${VM_HOSTNAME}.qcow2\"
" > /tmp/ch-${VM_HOSTNAME}.log
cat /tmp/ch-${VM_HOSTNAME}.log

 }




###################################################################


 chypercent () {
  VM_ORIGINALSDIR="/media/donnees/virtualisation/originals/"
  VM_IMGDIR="/media/donnees/virtualisation/images/"
  VM_DOMAIN="$(hostname -d)"
  VM_USERNAME="${USER:-${USERNAME}}"
  VM_USERPWD="CHANGEME"
  VM_IMGURL="$(chypercentlasturl)"
  VM_CPU=2
  VM_RAM="2048M"
  VM_IMGSIZE="20G"
  VM_HOSTNAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
  VM_SUBNET="192.168.1"
  VM_IPPREFIX="31"
  VM_IPMASK=$(set -- $(( 5 - (${VM_IPPREFIX} / 8) )) 255 255 255 255 $(( (255 << (8 - (${VM_IPPREFIX} % 8))) & 255 )) 0 0 0 ; [ ${1} -gt 1 ] && shift ${1} || shift ; echo ${1-0}.${2-0}.${3-0}.${4-0})
  VM_IPDYNMIN=150
  VM_IPDYNMAX=199
  VM_DNS="8.8.8.8"
  VM_NTP="80.74.64.1"
  VM_VMIF="eth0"
  VM_VMBRIDGE="brwan"
  VM_YUMRELEASE="8.1.1911"
  VM_YUMARCH="x86_64"
  VM_SCREEN_DIR="http://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/s/"
  VM_SCREEN_PACKAGE=$(curl -s ${VM_SCREEN_DIR} | grep screen-[0-9] | sed "s/.*\(\"screen.*rpm\"\).*/\1/" | sed "s/\"//g")
  VM_SCREEN_URL="${VM_SCREEN_DIR}${VM_SCREEN_PACKAGE}"
  VM_HAVEGED_DIR="http://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/h/"
  VM_HAVEGED_PACKAGE=$(curl -s ${VM_HAVEGED_DIR} | grep haveged-[0-9] | sed 's/.*\(\"haveged.*rpm\"\).*/\1/' | sed 's/\"//g')
  VM_HAVEGED_URL="${VM_HAVEGED_DIR}${VM_HAVEGED_PACKAGE}"
  VM_HTOP_DIR="http://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/Packages/h/"
  VM_HTOP_PACKAGE=$(curl -s ${VM_HTOP_DIR} | grep htop-[0-9] | sed "s/.*\(\"htop.*rpm\"\).*/\1/" | sed "s/\"//g")
  VM_HTOP_URL="${VM_HTOP_DIR}${VM_HTOP_PACKAGE}"

  if [[ ${1} != "-a" && ${1} ]]; then VM_HOSTNAME="${1}" ; fi

  VM_IF="${VM_HOSTNAME}"

  if [[ $2 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]] ; then VM_SUBNET="$(echo ${2} | awk -F\. '{ print $1"."$2"."$3 }')" ; fi

  if [[ ${1} == "-h" || ! ${1} ]] || [[ ! $2 =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} && $2 ]] ; then
   echo -e \
    "Usage:\n" \
    "Automatic mode : ${FUNCNAME[0]} -a\n" \
    "Manual mode    : ${FUNCNAME[0]} VM_NAME VM_IP_ADDRESS\n" \
    "This message   : ${FUNCNAME[0]} -h\n\n" \
    "Network subnet to use : ${VM_SUBNET}.${VM_IPDYNMIN}-${VM_SUBNET}.${VM_IPDYNMAX}\n" \
    "Password setting via virt-customize has been replace by usermod in order to encrypt it.\n" \
    "To generate the usermod password : openssl passwd or mkpasswd -m sha-512 PASSWORD (whois package)"
   return 0
  fi


  VM_CENTIPRANDOM=0
  while [ ${VM_CENTIPRANDOM} -le 150 ] || [ ${VM_CENTIPRANDOM} -ge 199 ] || [ -f /tmp/ch-${VM_HOSTNAME}-${2:-${VM_SUBNET}.${VM_CENTIPRANDOM}}.sock ] ; do
   VM_CENTIPRANDOM=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 3)
  done
  VM_IPADDR="${2:-${VM_SUBNET}.${VM_CENTIPRANDOM}}"
  VM_IPADDREND="$(echo ${VM_IPADDR} | cut -d. -f4)"
  if [[ $((${VM_IPADDREND} % 2)) == 0 ]] ; then VM_HV_IPADDREND=$((VM_IPADDREND+1)) ; else VM_HV_IPADDREND=$((VM_IPADDREND-1)) ; fi
  VM_MAC="fe:54:00:af:00:$(echo "obase=16;${VM_IPADDREND}" | bc)"
  VM_IPGW="${VM_SUBNET}.${VM_HV_IPADDREND}"

  if [ -e /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ] ; then echo "Address already in use" ; fi
  if [ -e ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 ] ; then echo "VM Disk already in use" ; fi

  echo "Original Image download" ; wget -q -O ${VM_ORIGINALSDIR}${VM_HOSTNAME}.org.qcow2 https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2
  echo "New Image creation" ; qemu-img create -q -f qcow2 ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 ${VM_IMGSIZE}
  echo "Filesystem expansion" ; virt-resize -q --resize /dev/vda1=+11.2G --no-extra-partition ${VM_ORIGINALSDIR}${VM_HOSTNAME}.org.qcow2 ${VM_IMGDIR}${VM_HOSTNAME}.qcow2

  virt-customize -a ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \
   --run-command "rpm --import https://mirrors.ircam.fr/pub/CentOS/RPM-GPG-KEY-CentOS-Official ;
    yum-config-manager --nogpgcheck --add-repo=https://mirrors.ircam.fr/pub/CentOS/${VM_YUMRELEASE}/BaseOS/${VM_YUMARCH}/os/ ;
    yum-config-manager --nogpgcheck --add-repo=https://mirrors.ircam.fr/pub/CentOS/${VM_YUMRELEASE}/extras/${VM_YUMARCH}/os/ ;
    yum-config-manager --nogpgcheck --add-repo=https://mirrors.ircam.fr/pub/CentOS/${VM_YUMRELEASE}/AppStream/${VM_YUMARCH}/os/ ;
    yum-config-manager --setopt=mirrors.ircam.fr_pub_CentOS_${VM_YUMRELEASE}_AppStream_${VM_YUMARCH}_os_.name=ircam.c${VM_YUMRELEASE}.${VM_YUMARCH}.AppStream --save ;
    yum-config-manager --setopt=mirrors.ircam.fr_pub_CentOS_${VM_YUMRELEASE}_BaseOS_${VM_YUMARCH}_os_.name=ircam.c${VM_YUMRELEASE}.${VM_YUMARCH}.BaseOS --save ;
    yum-config-manager --setopt=mirrors.ircam.fr_pub_CentOS_${VM_YUMRELEASE}_extras_${VM_YUMARCH}_os_.name=ircam.c${VM_YUMRELEASE}.${VM_YUMARCH}.extras --save ;
    yum-config-manager --disable BaseOS ;
    yum-config-manager --disable extras ;
    yum-config-manager --disable AppStream" \
   --uninstall "cloud-init,nfs-utils,cockpit-*,NetworkManager" \
   --install "gdisk,dosfstools,xterm-resize,bash-completion" \
   --run-command "yum -y install ${VM_SCREEN_URL} ${VM_HAVEGED_URL} ${VM_HTOP_URL}" \
   --run-command "sgdisk -m /dev/sda ; sgdisk /dev/sda -g -n 2::+900M ; sgdisk -t 2:ef00 /dev/sda"

  virt-customize -a ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 --run-command "mkfs.vfat -F32 /dev/sda2"
  virt-customize -a ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \
   --run-command "mount /dev/sda2 /boot/efi ;
    yum -y install efivar OVMF fwupdate-efi grub2-efi-x64-modules grub2-efi-x64 ;
    grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg ;
    sed -i 's/set timeout=1/set timeout=0/' /boot/efi/EFI/centos/grub.cfg ;
    cp /boot/efi/EFI/centos/grubx64.efi /boot/efi/EFI/BOOT/grubx64.efi ;
    cp /boot/grub2/grubenv /boot/efi/EFI/centos/grubenv ;
    sed -i 's/^#\{0,1\}SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config" \
   --run-command "adduser --uid 1000 --gid 100 --groups wheel -s /bin/bash -m -d /home/${VM_USERNAME} ${VM_USERNAME}" \
   --run-command "systemctl enable haveged" \
   --ssh-inject ${VM_USERNAME}:file:${HOME}/.ssh/id_rsa.pub \
   --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub \
   --run-command "systemctl disable ntp nfs-client nfs-convert nis-domainname rpcbind remote-fs selinux-autorelabel-mark guestfs-firstboot chronyd ;
    sed -i \"s/^#\{0,1\}\(DNS=\).*/\1${VM_DNS}/\" /etc/systemd/resolved.conf ;
    sed -i \"s/^#\{0,1\}\(LLMNR=\).*/\1no/\" /etc/systemd/resolved.conf ;
    sed -i \"s/^#\{0,1\}\(MulticastDNS=\).*/\1no/\" /etc/systemd/resolved.conf ;
    sed -i \"s/^#\{0,1\}\(AddressFamily \).*/\1inet/\" /etc/ssh/sshd_config ;
    systemctl enable systemd-resolved ; systemctl restart systemd-resolved ;
    systemctl restart sshd ;
    rm -f /etc/resolv.conf" \
   --link /run/systemd/resolve/stub-resolv.conf:/etc/resolv.conf \
   --run-command "
    cat >> /etc/sysctl.conf << EOF
kernel.domainname = ${VM_DOMAIN}
kernel.hostname = ${VM_HOSTNAME}
#
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.${VM_VMIF}.disable_ipv6 = 1
EOF
#
cat > /etc/machine-info << EOF
PRETTY_HOSTNAME=${VM_HOSTNAME}
ICON_NAME=computer
CHASSIS=vm
DEPLOYMENT=production
EOF
#
    cat >> /etc/hosts << EOF
${VM_IPADDR} ${VM_HOSTNAME}.${VM_DOMAIN} ${VM_HOSTNAME}
${VM_IPGW} gw.${VM_DOMAIN} gw
${VM_NTP} ntp.${VM_DOMAIN} ntp
EOF
#
cat >> /etc/profile.d/perso-scripts.sh << 'EOF'
set completion-ignore-case on
set +o noclobber
shopt -s checkwinsize
shopt -s histappend

alias la='\ls -a --color=auto'
alias ll='\ls -al --color=auto'
alias l='\ls -a1 --color=auto'
alias lrt='\ls -a1rt --color=auto'
alias llrt='\ls -alrt --color=auto'

export TERM=linux

[[ $- == *i* ]] && stty werase undef
[[ $- == *i* ]] && bind '\C-w:unix-filename-rubout'

resize_window () {
 old=\$(stty -g)
 stty raw -echo min 0 time 5
 printf '\0337\033[r\033[999;999H\033[6n\0338' > /dev/tty
 IFS='[;R' read -r _ rows cols _ < /dev/tty
 stty "\$old"
 stty cols "\$cols" rows "\$rows"
}
EOF
#
" \
   --run-command "
    echo '/dev/vda2 /boot/efi vfat defaults 0 0' >> /etc/fstab ;
    yum-config-manager --add-repo=https://mirrors.ircam.fr/pub/CentOS/${VM_YUMRELEASE}/BaseOS/${VM_YUMARCH}/os/ ;
    grub2-editenv /boot/efi/EFI/centos/grubenv set kernelopts=\"root=/dev/vda1 ro console=ttyS0 no_timer_check crashkernel=auto i8042.noaux i8042.nomux i8042.nopnp i8042.dumbkbd random.trust_cpu=on net.ifnames=0 biosdevname=0 ipv6.disable=1 ip=${VM_IPADDR}::${VM_IPGW}:255.255.255.254:${VM_HOSTNAME}:eth0:off::: rd.neednet=1 \"
    "

  virt-customize -a ${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \
   --run-command "/usr/sbin/usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' ${VM_USERNAME}" \
   --run-command "/usr/sbin/usermod -p '$6$7RlNv6dQUjlRubwX$uT7QKvL7mgrl48fi6q7sD.PnDVU69QEM0QoTM1/vGUcO0FvUDlDSCaV8PEg7SbQRfTul5Umb1Bo2Oub0TrM4h0' root" \
   --append-line /etc/issue:"IP addr: ${VM_IPADDR}" --append-line /etc/issue.net:"IP addr: ${VM_IPADDR}" \
   --append-line /etc/issue:"Gateway: ${VM_IPGW}" --append-line /etc/issue.net:"Gateway: ${VM_IPGW}" \
   --append-line /etc/issue:"User: ${VM_USERNAME}" --append-line /etc/issue.net:"User: ${VM_USERNAME}" \
   --append-line /etc/issue:""  --append-line /etc/issue.net:""


  echo "Original Image deletion" ; /bin/rm -f ${VM_ORIGINALSDIR}${VM_HOSTNAME}.org.qcow2

  chyperscreeninit

  screen -S virt -X screen -t ${VM_HOSTNAME} sh -c "\
/media/donnees/virtualisation/bin/cloud-hypervisor \
--kernel /media/donnees/virtualisation/kernel/hypervisor-fw \
--disk path=${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \
--cpus boot=${VM_CPU} \
--memory size=${VM_RAM} \
--net tap=,mac=${VM_MAC},ip=${VM_SUBNET}.${VM_HV_IPADDREND},mask=${VM_IPMASK},num_queues=4,queue_size=256 \
--api-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock \
--rng  --console off --serial tty ; \
/bin/rm -f /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ; \
/bin/rm -i ${VM_IMGDIR}${VM_HOSTNAME}.qcow2"

  echo -e "
Hostname : ${VM_HOSTNAME}
OS       : Debian
IP addr  : ${VM_IPADDR}/${VM_IPMASK}
Gateway  : ${VM_IPGW}

Console command :
screen -r virt

SSH command :
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${VM_USERNAME} ${VM_IPADDR}

### Rerun VM !!! IF NEEDED ###
screen -S virt -X screen -t ${VM_HOSTNAME} \\
sh -c \"/media/donnees/virtualisation/bin/cloud-hypervisor \\
--kernel /media/donnees/virtualisation/kernel/hypervisor-fw \\
--disk path=${VM_IMGDIR}${VM_HOSTNAME}.qcow2 \\
--cpus boot=${VM_CPU} \\
--memory size=${VM_RAM} \\
--net tap=,mac=${VM_MAC},ip=${VM_SUBNET}.${VM_HV_IPADDREND},mask=${VM_IPMASK},num_queues=4,queue_size=256 \\
--rng  --console off --serial tty \\
--api-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ; \\
/bin/rm -f /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock ; \\
/bin/rm -i ${VM_IMGDIR}${VM_HOSTNAME}.qcow2\"
" > /tmp/ch-${VM_HOSTNAME}.log
cat /tmp/ch-${VM_HOSTNAME}.log

 }




###################################################################


 chyperapihelp () {

  echo '
# Lancement alternatif via API
# La console est attachée à la première commande.

/media/donnees/virtualisation/bin/cloud-hypervisor --api-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock

curl --unix-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock -i \
     -X PUT "http://localhost/api/v1/vm.create"  \
     -H "Accept: application/json"               \
     -H "Content-Type: application/json"         \
     -d '\''{
         "cpus":{"boot_vcpus":2,"max_vcpus":2},
         "memory":{"size":2147483648},
         "kernel":{"path":"/media/donnees/virtualisation/kernel/hypervisor-fw"},
         "disks":[{"path":"/media/donnees/virtualisation/originals/debian.raw"}],
         "net":[{"tap":"vmdeb01"}],
         "rng":{"src":"/dev/urandom"},
         "serial":{"mode":"Tty"},
         "console":{"mode":"Off"}
         }'\''

curl --unix-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock -i -X PUT "http://localhost/api/v1/vm.boot"
curl --unix-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock -i -X GET "http://localhost/api/v1/vm.info" -H "Accept: application/json"
curl --unix-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock -i -X PUT "http://localhost/api/v1/vm.reboot"
curl --unix-socket /tmp/ch-${VM_HOSTNAME}-${VM_IPADDR}.sock -i -X PUT "http://localhost/api/v1/vm.shutdown"
' > /dev/stdout


 }

###################################################################

# sudo ip tuntap del ${VM_IF} mode tap ; [ $? != 0 ] && return 0 ; sudo ip tuntap add name ${VM_IF} mode tap multi_queue ; sudo ip link set dev ${VM_IF} master ${VM_VMBRIDGE}

# --firstboot-command "
#  nmcli conn delete eth0 ;
#  nmcli conn delete System\ ${VM_VMIF} ;
#  nmcli con add type ethernet con-name System\ ${VM_VMIF} ifname ${VM_VMIF} ip4 ${VM_IPADDR}/${VM_IPMASK} gw4 ${VM_IPGW} ;
#  nmcli connection modify System\ ${VM_VMIF} ipv6.method 'disabled' ;
#  nmcli con mod System\ ${VM_VMIF} ipv4.dns ${VM_DNS}\ 8.8.4.4 ;
#  nmcli con up System\ ${VM_VMIF} ifname ${VM_VMIF} ;
#  nmcli connection delete 'Wired connection 1'"


###################################################################

fi
