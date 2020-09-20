if [ ${PERSO_ENABLED} = 1 ] ; then

 dlimgurldebqcow2 () {
  VM_DEB_ORG_IMG_URL_ROOT="http://cdimage.debian.org/cdimage/openstack/current-10/"
  VM_DEB_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_DEB_ORG_IMG_URL_ROOT} | grep -o "debian-[0-9]*-openstack-amd64.qcow2" | tac | head -n 1)
  /bin/echo -n ${VM_DEB_ORG_IMG_URL_ROOT}${VM_DEB_ORG_IMG_LAST_FILE}
 }
 
 dlimgurldebtxz () {
  VM_DEB_ORG_IMG_URL_ROOT="http://cdimage.debian.org/cdimage/cloud/buster/"
  VM_DEB_ORG_IMG_URL_LAST_VER=$(curl -s ${VM_DEB_ORG_IMG_URL_ROOT}/ | grep folder | grep -v daily | sort | tail -n 1 | sed "s/.*href=\"\(.*-.*\)\/\".*/\1/")
  VM_DEB_ORG_IMG_LAST_FILE=$(curl -s ${VM_DEB_ORG_IMG_URL_ROOT}/${VM_DEB_ORG_IMG_URL_LAST_VER}/${DEBREPOSUBDIR}/ | grep debian-.*-genericcloud-amd64-.*.tar.xz | sed "s/.*href=\"\(debian.*tar.xz\)\".*/\1/")
  /bin/echo -n ${VM_DEB_ORG_IMG_URL_ROOT}${VM_DEB_ORG_IMG_URL_LAST_VER}/${VM_DEB_ORG_IMG_LAST_FILE}
 }
 
 dlimgurlcent () {
  VM_CENT_ORG_IMG_URL_ROOT="https://cloud.centos.org/centos/"
  VM_CENT_ORG_IMG_URL_LAST_VER=$(wget -q -O - ${VM_CENT_ORG_IMG_URL_ROOT} | grep href..[0-9] | tail -n 1 | cut -d\" -f12)
  VM_CENT_ORG_IMG_URL_SUFFIX="/x86_64/images/"
  VM_CENT_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_CENT_ORG_IMG_URL_ROOT}${VM_CENT_ORG_IMG_URL_LAST_VER}${VM_CENT_ORG_IMG_URL_SUFFIX} | grep -o "CentOS-8-GenericCloud[a-zA-Z0-9_.-]*.qcow2" | tac | head -n 1)
  /bin/echo -n ${VM_CENT_ORG_IMG_URL_ROOT}${VM_CENT_ORG_IMG_URL_LAST_VER}${VM_CENT_ORG_IMG_URL_SUFFIX}${VM_CENT_ORG_IMG_LAST_FILE}
 }
 
 dlimgurlubuuefi () {
  VM_UBU_ORG_IMG_URL_ROOT="https://cloud-images.ubuntu.com/"
  VM_UBU_ORG_IMG_URL_LAST_VER=$(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT} | grep folder.*href.. | tr -s \  | grep $(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT} | grep folder.*href.. | tr -s \  | awk '{ print $13 }' | grep -e "^[0-9]" | sort | tail -n2 | head -n1 ) | cut -d\" -f10 | head -n1 )
  VM_UBU_ORG_IMG_URL_SUFFIX="current/"
  VM_UBUUEFI_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT}xenial/${VM_UBU_ORG_IMG_URL_SUFFIX} | grep "server-cloudimg-amd64-uefi1.img" | tac | head -n 1 | cut -d\" -f10)
  /bin/echo -n ${VM_UBU_ORG_IMG_URL_ROOT}xenial/${VM_UBU_ORG_IMG_URL_SUFFIX}${VM_UBUUEFI_ORG_IMG_LAST_FILE}
 }

 dlimgurlububios () {
  VM_UBU_ORG_IMG_URL_ROOT="https://cloud-images.ubuntu.com/"
  VM_UBU_ORG_IMG_URL_LAST_VER=$(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT} | grep folder.*href.. | tr -s \  | grep $(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT} | grep folder.*href.. | tr -s \  | awk '{ print $13 }' | grep -e "^[0-9]" | sort | tail -n2 | head -n1 ) | cut -d\" -f10 | head -n1 )
  VM_UBU_ORG_IMG_URL_SUFFIX="current/"
  VM_UBUBIOS_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT}${VM_UBU_ORG_IMG_URL_LAST_VER}${VM_UBU_ORG_IMG_URL_SUFFIX} | grep "server-cloudimg-amd64.img" | tac | head -n 1 | cut -d\" -f10)
  /bin/echo -n ${VM_UBU_ORG_IMG_URL_ROOT}${VM_UBU_ORG_IMG_URL_LAST_VER}${VM_UBU_ORG_IMG_URL_SUFFIX}${VM_UBUBIOS_ORG_IMG_LAST_FILE}
 }

 dlimgurlubusfs () {
  VM_UBU_ORG_IMG_URL_ROOT="https://cloud-images.ubuntu.com/"
  VM_UBU_ORG_IMG_URL_LAST_VER=$(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT} | grep folder.*href.. | tr -s \  | grep $(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT} | grep folder.*href.. | tr -s \  | awk '{ print $13 }' | grep -e "^[0-9]" | sort | tail -n2 | head -n1 ) | cut -d\" -f10 | head -n1 )
  VM_UBU_ORG_IMG_URL_SUFFIX="current/"
  VM_UBUSFS_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_UBU_ORG_IMG_URL_ROOT}${VM_UBU_ORG_IMG_URL_LAST_VER}${VM_UBU_ORG_IMG_URL_SUFFIX} | grep server-cloudimg-amd64.squashfs\" | tac | head -n 1 | cut -d\" -f10)
  /bin/echo -n ${VM_UBU_ORG_IMG_URL_ROOT}${VM_UBU_ORG_IMG_URL_LAST_VER}${VM_UBU_ORG_IMG_URL_SUFFIX}${VM_UBUSFS_ORG_IMG_LAST_FILE}
 }

 dlimgurlfed () {
  VM_FED_ORG_IMG_URL_ROOT="https://download.fedoraproject.org/pub/fedora/linux/releases/"
  VM_FED_ORG_IMG_URL_LAST_VER=$(wget -q -O - ${VM_FED_ORG_IMG_URL_ROOT} | grep href | tail -n 2 | head -n 1 | cut -d\" -f8)
  VM_FED_ORG_IMG_URL_SUFFIX="Cloud/x86_64/images/"
  VM_FED_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_FED_ORG_IMG_URL_ROOT}${VM_FED_ORG_IMG_URL_LAST_VER}${VM_FED_ORG_IMG_URL_SUFFIX} | grep -o "Fedora-Cloud-Base-[a-zA-Z0-9_.-]*.x86_64.qcow2" | tac | head -n 1)
  /bin/echo -n ${VM_FED_ORG_IMG_URL_ROOT}${VM_FED_ORG_IMG_URL_LAST_VER}${VM_FED_ORG_IMG_URL_SUFFIX}${VM_FED_ORG_IMG_LAST_FILE}
 }

 dlimgurlcir () {
  VM_CIR_ORG_IMG_URL_ROOT="http://download.cirros-cloud.net/"
  VM_CIR_ORG_IMG_URL_LAST_VER=$(wget -q -O - ${VM_CIR_ORG_IMG_URL_ROOT} | grep href=\"[0-9]\. | tail -n 1 | cut -d\" -f2)
  VM_CIR_ORG_IMG_LAST_FILE=$(wget -q -O - ${VM_CIR_ORG_IMG_URL_ROOT}${VM_CIR_ORG_IMG_URL_LAST_VER} | grep -o "cirros-[0-9.]*-x86_64-disk.img" | tac | head -n 1)
  /bin/echo -n ${VM_CIR_ORG_IMG_URL_ROOT}${VM_CIR_ORG_IMG_URL_LAST_VER}${VM_CIR_ORG_IMG_LAST_FILE}
 }


############################################################################################


 dlimgdownload () {
  VM_ORG_DIR="${2:-/media/donnees/virtualisation/originals/}"
  VM_HDD="20G"
  VM_VMPASSW="${3:-CHANGEME}"

  if [ ! ${1} ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ] ; then
   /bin/echo -e "Usage:" \
    "\n${FUNCNAME[0]} VM_DISTRIB [DST_IMG_DIR] [ROOT_PASSWORD]" \
    "\nExample: ${FUNCNAME[0]} centos ${VM_ORG_DIR} CHANGEME\n" \
    "\nDistrib list: centos cirros debianqcow2 debiantxz fedora ubuntubios ubuntusfs ubuntuuefi\n"
   return 0
  fi

  if [ ! -d ${2} ] && [ ${2} ] ; then
   /bin/echo -e "${2} not a directory"
   return 0
  fi

  case "${1}" in 
   centos)      /bin/echo -e "Downloading Centos Image"       ; IMG_DIST_URL=$(dlimgurlcent) ;;
   cirros)      /bin/echo -e "Downloading Cirros Image"       ; IMG_DIST_URL=$(dlimgurlcir) ;;
   debianqcow2) /bin/echo -e "Downloading Debian Qcow2 Image" ; IMG_DIST_URL=$(dlimgurldebqcow2) ;;
   debiantxz)   /bin/echo -e "Downloading Debian TXZ Image"   ; IMG_DIST_URL=$(dlimgurldebtxz) ;;
   fedora)      /bin/echo -e "Downloading Fedora Image"       ; IMG_DIST_URL=$(dlimgurlfed) ;;
   ubuntubios)  /bin/echo -e "Downloading Ubuntu Bios Image"  ; IMG_DIST_URL=$(dlimgurlububios) ;;
   ubuntusfs)   /bin/echo -e "Downloading UBUNTU SFS Image"   ; IMG_DIST_URL=$(dlimgurlubusfs) ;;
   ubuntuuefi)  /bin/echo -e "Downloading UBUNTU UEFI Image"  ; IMG_DIST_URL=$(dlimgurlubuuefi) ;;
   *) /bin/echo -e "Bad Distribution name" ; return 0 ;;
  esac

  if [ -f ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}) ] ; then
   /bin/echo -e "${VM_ORG_DIR}$(basename ${IMG_DIST_URL})" already exists.
   return 0
  fi

  wget --show-progress --no-use-server-timestamps -P ${VM_ORG_DIR} ${IMG_DIST_URL}
  
  qemu-img create -f qcow2 ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}).2 ${VM_HDD}
  virt-resize -q --expand /dev/vda1 ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}) ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}).2
  /bin/mv -f ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}).2 ${VM_ORG_DIR}$(basename ${IMG_DIST_URL})
  virt-customize -a ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}) \
    --root-password password:${VM_VMPASSW} \
    --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub \
    --selinux-relabel

  if [ "${1}" == "centos" ] || [ "${1}" == "fdora" ] ; then
    virt-customize -a ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}) \
      --run-command "sed -i 's/^#\{0,1\}SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux" \
      --run-command "grub2-editenv /boot/grub2/grubenv set 'kernelopts=root=UUID=97afc4f5-6937-4cc2-a5b9-762f034d85a7 ro console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto selinux=0 apparmor=0'" \
      --selinux-relabel
  fi

  if [ "${1}" == "debianqcow2" ] || [ "${1}" == "debiantxz" ] ; then
    virt-customize -a ${VM_ORG_DIR}$(basename ${IMG_DIST_URL}) \
      --run-command "dpkg-reconfigure openssh-server"
  fi

  return 0
 }

################################################################################

 dlisourldebnet () {
  VM_DEBNET_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/debian-cd/current/amd64/iso-cd/"
  VM_DEBNET_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_DEBNET_ORG_ISO_URL_ROOT} | grep -o "debian-[0-9.]*-amd64-netinst.iso" | tac | head -n 1)
  /bin/echo -n ${VM_DEBNET_ORG_ISO_URL_ROOT}${VM_DEBNET_ORG_ISO_LAST_FILE}
 }
 
 dlisourldebdvd () {
  VM_DEBDVD_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/debian-cd/current/amd64/iso-dvd/"
  VM_DEBDVD_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_DEBDVD_ORG_ISO_URL_ROOT} | grep -o "debian-[0-9.]*-amd64-DVD-1.iso" | tac | head -n 1)
  /bin/echo -n ${VM_DEBDVD_ORG_ISO_URL_ROOT}${VM_DEBDVD_ORG_ISO_LAST_FILE}
 }
 
 dlisourldeblive () {
  VM_DEBLIVE_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/debian-cd/current-live/amd64/iso-hybrid/"
  VM_DEBLIVE_ORG_ISO_LAST_FILE=$(wget -q -O - $VM_DEBLIVE_ORG_ISO_URL_ROOT| grep debian-live-[0-9.]*-amd64-standard.iso | cut -d\" -f8)
  /bin/echo -n ${VM_DEBLIVE_ORG_ISO_URL_ROOT}${VM_DEBLIVE_ORG_ISO_LAST_FILE}
 }

 dlisourlcent () {
  VM_CENT_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/CentOS/"
  VM_CENT_ORG_ISO_URL_LAST_VER=$(wget -q -O - ${VM_CENT_ORG_ISO_URL_ROOT} | grep -e href..[0-9] | tail -n 1 | cut -d\" -f8)
  VM_CENT_ORG_ISO_URL_SUFFIX="isos/x86_64/"
  VM_CENT_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_CENT_ORG_ISO_URL_ROOT}${VM_CENT_ORG_ISO_URL_LAST_VER}${VM_CENT_ORG_ISO_URL_SUFFIX} | grep -o "CentOS-[0-9.]*-x86_64-dvd1.iso" | tac | head -n 1)
  /bin/echo -n ${VM_CENT_ORG_ISO_URL_ROOT}${VM_CENT_ORG_ISO_URL_LAST_VER}${VM_CENT_ORG_ISO_URL_SUFFIX}${VM_CENT_ORG_ISO_LAST_FILE}
 }

 dlisourlfedsrv () {
  VM_FED_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/fedora/linux/releases/"
  VM_FED_ORG_ISO_URL_LAST_VER=$(wget -q -O - ${VM_FED_ORG_ISO_URL_ROOT} | grep -e href..[0-9] | cut -d\" -f8 | tail -n 1)
  VM_FEDSRV_ORG_ISO_URL_SUFFIX="Server/x86_64/iso/"
  VM_FEDSRV_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_FED_ORG_ISO_URL_ROOT}${VM_FED_ORG_ISO_URL_LAST_VER}${VM_FEDSRV_ORG_ISO_URL_SUFFIX} | grep -o "Fedora-Server-dvd-x86_64-[0-9]*-1.6.iso" | tac | head -n 1)
  /bin/echo -n ${VM_FED_ORG_ISO_URL_ROOT}${VM_FED_ORG_ISO_URL_LAST_VER}${VM_FEDSRV_ORG_ISO_URL_SUFFIX}${VM_FEDSRV_ORG_ISO_LAST_FILE}
 }

 dlisourlfedws () {
  VM_FED_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/fedora/linux/releases/"
  VM_FED_ORG_ISO_URL_LAST_VER=$(wget -q -O - ${VM_FED_ORG_ISO_URL_ROOT} | grep -e href..[0-9] | cut -d\" -f8 | tail -n 1)
  VM_FEDWS_ORG_ISO_URL_SUFFIX="Workstation/x86_64/iso/"
  VM_FEDWS_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_FED_ORG_ISO_URL_ROOT}${VM_FED_ORG_ISO_URL_LAST_VER}${VM_FEDWS_ORG_ISO_URL_SUFFIX} | grep -o "Fedora-Workstation-Live-x86_64-[0-9]*-[0-9.]*.iso" | tail -n1)
  /bin/echo -n ${VM_FED_ORG_ISO_URL_ROOT}${VM_FED_ORG_ISO_URL_LAST_VER}${VM_FEDWS_ORG_ISO_URL_SUFFIX}${VM_FEDWS_ORG_ISO_LAST_FILE}
 }
 
 dlisourlubusrv () {
  VM_UBU_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/ubuntu/releases/"
  VM_UBU_ORG_ISO_URL_LAST_VER=$(wget -q -O - ${VM_UBU_ORG_ISO_URL_ROOT} | grep -e href..[0-9] | sort -k10 | tail -n1 | cut -d\" -f8)
  VM_UBUSRV_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_UBU_ORG_ISO_URL_ROOT}${VM_UBU_ORG_ISO_URL_LAST_VER} | grep -o "ubuntu-[0-9.]*-live-server-amd64.iso" | tac | head -n 1)
  /bin/echo -n ${VM_UBU_ORG_ISO_URL_ROOT}${VM_UBU_ORG_ISO_URL_LAST_VER}${VM_UBUSRV_ORG_ISO_LAST_FILE}
 }

 dlisourlubudsk () {
  VM_UBU_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/ubuntu/releases/"
  VM_UBU_ORG_ISO_URL_LAST_VER=$(wget -q -O - ${VM_UBU_ORG_ISO_URL_ROOT} | grep -e href..[0-9] | sort -k10 | tail -n1 | cut -d\" -f8)
  VM_UBUDSK_ORG_ISO_LAST_FILE=$(wget -q -O - ${VM_UBU_ORG_ISO_URL_ROOT}${VM_UBU_ORG_ISO_URL_LAST_VER} | grep -o "ubuntu-[0-9.]*-desktop-amd64.iso" | tac | head -n 1)
  /bin/echo -n ${VM_UBU_ORG_ISO_URL_ROOT}${VM_UBU_ORG_ISO_URL_LAST_VER}${VM_UBUDSK_ORG_ISO_LAST_FILE}
 }

 dlisourlalpext () {
  VM_ALPEXT_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/alpine/latest-stable/releases/x86_64/"
  VM_ALPEXT_ORG_ISO_LAST_FILE=$(wget -q -O - $VM_ALPEXT_ORG_ISO_URL_ROOT| grep alpine-extended-[0-9.]*-x86_64.iso\" | cut -d\" -f8)
  /bin/echo -n ${VM_ALPEXT_ORG_ISO_URL_ROOT}${VM_ALPEXT_ORG_ISO_URL_LAST_VER}${VM_ALPEXT_ORG_ISO_LAST_FILE}
 }

 dlisourlalpvirt () {
  VM_ALPVIRT_ORG_ISO_URL_ROOT="http://129.102.1.37/pub/alpine/latest-stable/releases/x86_64/"
  VM_ALPVIRT_ORG_ISO_LAST_FILE=$(wget -q -O - $VM_ALPVIRT_ORG_ISO_URL_ROOT| grep alpine-virt-[0-9.]*-x86_64.iso\" | cut -d\" -f8)
  /bin/echo -n ${VM_ALPVIRT_ORG_ISO_URL_ROOT}${VM_ALPVIRT_ORG_ISO_URL_LAST_VER}${VM_ALPVIRT_ORG_ISO_LAST_FILE}
 }

################################################################################

 dlisodownload () {
  VM_ISO_DIR="${2:-/media/donnees/virtualisation/isos/}"

  if [ ! ${1} ] || [ "${1}" = "-h" ] || [ "${1}" = "--help" ] ; then
   /bin/echo -e "Usage:" \
    "\n${FUNCNAME[0]} DISTRIB [DST_ISO_DIR]" \
    "\nExample: ${FUNCNAME[0]} centos ${VM_ISO_DIR}" \
    "\nDistrib list: debnet debdvd deblive centos fedsrv fedws ubusrv ubudsk alpext alpvirt"
   return 0
  fi

  if [ ! -d ${2} ] && [ ${2} ] ; then
   /bin/echo -e "${2} not a directory"
   return 0
  fi

  case "${1}" in
   debnet)      /bin/echo -e "Downloading Debian NetInstall ISO"   ; ISO_DIST_URL=$(dlisourldebnet) ;;
   debdvd)      /bin/echo -e "Downloading Debian DVD ISO"          ; ISO_DIST_URL=$(dlisourldebdvd) ;;
   deblive)     /bin/echo -e "Downloading Debian Live ISO"         ; ISO_DIST_URL=$(dlisourldeblive) ;;
   centos)      /bin/echo -e "Downloading Centos ISO"              ; ISO_DIST_URL=$(dlisourlcent) ;;
   fedsrv)      /bin/echo -e "Downloading Fedora Server ISO"       ; ISO_DIST_URL=$(dlisourlfedsrv) ;;
   fedws)       /bin/echo -e "Downloading Fedora Workstation ISO"  ; ISO_DIST_URL=$(dlisourlfedws) ;;
   ubusrv)      /bin/echo -e "Downloading Ubuntu Server ISO"       ; ISO_DIST_URL=$(dlisourlubusrv) ;;
   ubudsk)      /bin/echo -e "Downloading Ubuntu Desktop ISO"      ; ISO_DIST_URL=$(dlisourlubudsk) ;;
   alpext)      /bin/echo -e "Downloading Alpine Extended ISO"     ; ISO_DIST_URL=$(dlisourlalpext) ;;
   alpvirt)     /bin/echo -e "Downloading Alpine Virtual ISO"      ; ISO_DIST_URL=$(dlisourlalpvirt) ;;
   *) /bin/echo -e "Bad Distribution name" ; return 0 ;;
  esac

  if [ -f ${VM_ISO_DIR}$(basename ${ISO_DIST_URL}) ] ; then
   /bin/echo -e "${VM_ISO_DIR}$(basename ${ISO_DIST_URL})" already exists.
   return 0
  fi

  wget --show-progress --no-use-server-timestamps -c -P ${VM_ISO_DIR} ${ISO_DIST_URL}

  return 0
 }


################################################################################

 dlgitlabpersoscripts () {
  MY_GITLAB_URL_ROOT="https://gitlab.com/nicolasi31/public/-/raw/master"
  PERSOSCRIPTLIST="perso-00-enabled.sh perso-alias_and_variables.sh \
perso-cat_functions.sh perso-cisco.sh perso-cloud-hypervisor.sh \
perso-dash.sh perso-distrib.sh perso-download.sh perso-firecracker.sh \
perso-freebox.sh perso-genfile.sh perso-kvm.sh perso-mail.sh \
perso-miscfunctions.sh perso-mm-ipradio.sh perso-mm-iptv4sat.sh \
perso-mm-iptv.sh perso-network.sh perso-nftables.sh perso-per_arch.sh \
perso-persoscripts.sh perso-podcast.sh perso-ps_and_ls_colors.sh \
perso-pxe.sh perso-sauvegarde.sh  perso-tipsdatabase.sh \
perso-tipsgnome.sh perso-tipskvm.sh perso-tipsmultimedia.sh \
perso-tipsnewinstall.sh perso-tipswindows.sh perso-usbkey.sh"

  if [ ! -d ${HOME}/.profile.d ] ; then
   /bin/echo -e "${HOME}/.profile.d doesnt exist. Creating."
   mkdir ${HOME}/.profile.d
  fi

  if [ ! -e ${HOME}/.bash_login ] ; then
   /bin/echo -e "${HOME}/.bash_login file doesnt exist, downloading."
   wget -P ${HOME}/ ${MY_GITLAB_URL_ROOT}/racine/home/.bash_login
  fi

  for PERSOSCRIPT in ${PERSOSCRIPTLIST} ; do
   if [ ! -e ${HOME}/.profile.d/${PERSOSCRIPT} ] ; then
    /bin/echo -e "${HOME}/.profile.d/${PERSOSCRIPT} file doesnt exist, downloading."
    wget -P ${HOME}/.profile.d/ ${MY_GITLAB_URL_ROOT}/racine/home/.profile.d/${PERSOSCRIPT}
   else
    /bin/echo -e "${HOME}/.profile.d/${PERSOSCRIPT} already exists."
   fi
  done
 }

################################################################################


fi
