if [ ${PERSO_ENABLED} = 1 ] ; then

 usbkey-create () {
  # DELETE ALL PARTITIONS BE CAREFULL!!! USE AT YOUR OWN RISKS!!!"
  # Install packages if needed : grub-efi-amd64-bin grub-efi-ia32-bin grub-pc-bin parted dosfstools

  /bin/echo -e "DELETE ALL PARTITIONS BE CAREFULL!!! USE AT YOUR OWN RISKS!!!"
  read -e -p "Are you sure (YES/NO)? " -i NO USBFORMATCONFIRM
  if [ ${USBFORMATCONFIRM} != "YES" ] ; then /bin/echo "Abort!" ; return 0 ; fi

  read -e -p "USBKEY device name: " -i sdz PARTEDDEVICE
  if [ ! -e /dev/${PARTEDDEVICE} ] ; then /bin/echo "Bad device name! Abort." ; return 0 ; fi

  read -e -p "USBKEY name prefix: " -i S128 KEYNAME
  if [ ${#KEYNAME} -lt 1 ] ; then /bin/echo "Bad device prefix! Abort." ; return 0 ; fi

# /bin/echo "OK" ; return 0

#  PARTEDDEVICE="sdz"
#  KEYNAME="S128"
  KEYLINTMPDIR="/tmp/usbkey/1"
  PERSISTMPDIR="/tmp/usbkey/2"
  DEBISOPATH="/tmp/usbkey/debian-live-10.5.0-amd64-standard.iso"

  mkdir -p /tmp/usbkey/1 /tmp/usbkey/2
  wget -c -P /tmp/usbkey/ https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-10.5.0-amd64-standard.iso

  parted /dev/${PARTEDDEVICE} -- mktable gpt
  parted /dev/${PARTEDDEVICE} -- mkpart efi fat32 1MiB 64MiB
  parted /dev/${PARTEDDEVICE} -- mkpart biosgrub fat32 64MiB 128MiB
  parted /dev/${PARTEDDEVICE} -- set 1 esp on
  parted /dev/${PARTEDDEVICE} -- set 2 bios_grub on
  parted /dev/${PARTEDDEVICE} -- mkpart primary ext4 128MiB 5376MiB
  parted /dev/${PARTEDDEVICE} -- mkpart primary fat32 5376MiB -1

  sync

  mkfs.vfat -F 32 /dev/${PARTEDDEVICE}1
  mkfs.vfat -F 32 /dev/${PARTEDDEVICE}2
  mkfs.ext4 -m 0 -L ${KEYNAME}LIN /dev/${PARTEDDEVICE}3
  mkfs.vfat -F 32 -n ${KEYNAME}WIN /dev/${PARTEDDEVICE}4

  mount /dev/${PARTEDDEVICE}3 ${KEYLINTMPDIR}

  mkdir -p ${KEYLINTMPDIR}/boot/efi ${KEYLINTMPDIR}/boot/grub
  mount /dev/${PARTEDDEVICE}1 ${KEYLINTMPDIR}/boot/efi

  grub-install --force --no-floppy --locales=fr --target=i386-pc    --boot-directory=${KEYLINTMPDIR}/boot --removable --no-nvram /dev/${PARTEDDEVICE}
  grub-install --force --no-floppy --locales=fr --target=i386-efi   --boot-directory=${KEYLINTMPDIR}/boot --efi-directory=${KEYLINTMPDIR}/boot/efi \
   --no-uefi-secure-boot --removable --no-nvram /dev/${PARTEDDEVICE}
  grub-install --force --no-floppy --locales=fr --target=x86_64-efi --boot-directory=${KEYLINTMPDIR}/boot --efi-directory=${KEYLINTMPDIR}/boot/efi \
   --no-uefi-secure-boot --removable --no-nvram /dev/${PARTEDDEVICE}

  wget -O ${KEYLINTMPDIR}/boot/grub/grub.cfg https://gitlab.com/nicolasi31/public/-/raw/master/grub-usbkey.cfg
  sed -i "s/persistence-debian.data/persistence-${KEYNAME}.data/" ${KEYLINTMPDIR}/boot/grub/grub.cfg

  wget -P ${KEYLINTMPDIR}/ https://mirrors.ircam.fr/pub/debian/pool/non-free/f/firmware-nonfree/firmware-iwlwifi_20200619-1_all.deb
  # wget -P ${KEYLINTMPDIR}/ https://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os/Packages/linux-firmware-20191202-97.gite8a0f4c9.el8.noarch.rpm

  cat > ${KEYLINTMPDIR}/wlp2s0.link << _EOF_
[Match]
#OriginalName=wlp2s0
Type=wlan

[Link]
#AutoNegotiation=1
Name=wlp2s0
RequiredForOnline=no
_EOF_

  cat > ${KEYLINTMPDIR}/wlp2s0.network << _EOF_
[Match]
Name=wlp2s0

[Network]
LinkLocalAddressing=no
DHCP=ipv4
_EOF_

  dd if=/dev/null of=${KEYLINTMPDIR}/persistence-${KEYNAME}.data bs=1 count=0 seek=4G
  /sbin/mkfs.ext4 -F -m 0 -L live-rw ${KEYLINTMPDIR}/persistence-${KEYNAME}.data

  mount ${KEYLINTMPDIR}/persistence-${KEYNAME}.data ${PERSISTMPDIR}
  cat > ${PERSISTMPDIR}/persistence.conf << _EOF_
# persistence backwards compatibility:
#/ union,source=.
/ union,source=debian-jessie-amd64
#/home/user1 link,source=config-files/user1
_EOF_
  mkdir ${PERSISTMPDIR}/debian-jessie-amd64
  umount ${PERSISTMPDIR}

  mount ${DEBISOPATH} ${PERSISTMPDIR}/

  cp -rv ${PERSISTMPDIR}/live/ ${PERSISTMPDIR}/d-i/ ${KEYLINTMPDIR}/
  sync
  umount ${PERSISTMPDIR}
  umount ${DEBISOPATH} ${KEYLINTMPDIR}/boot/efi ${KEYLINTMPDIR}

  /bin/echo "Wifi config example:"
  /bin/echo "wpa_passphrase SSID MOTDEPASSE >> /etc/wpa_supplicant/wpa_supplicant-wlp2s0.conf"

 }

fi

