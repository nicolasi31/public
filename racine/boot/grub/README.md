**Table of Content**

[[_TOC_]]

----

# Configs
- [custom.cfg](custom.cfg)
- [pxe.cfg](pxe.cfg)
- [usbkey.cfg](usbkey.cfg)
- [/etc/default/grub](/etc/default/grub)

----

# Debian Bootable USBKEY
## REMARKS
> EFI and BIOS multiboot usbkey creation script.\
> DELETE ALL PARTITIONS BE CAREFULL!!! USE AT YOUR OWN RISKS!!!\
> The ext4 doesn't have to be huge, depends on persistence file (if used).\
> The vfat can use the rest of the key storage (except EFI and BIOS dedicated partitions).\
> vfat fs implies a 4GB max limit for files.\
> vfat chosen over NTFS and exfat in order to be able to mount the key on Android too.\
> Replace PARTEDDEVICE and KEYNAME with your own info

## SCRIPTS
```shell
#!/bin/bash

# DELETE ALL PARTITIONS BE CAREFULL!!! USE AT YOUR OWN RISKS!!!
# Replace PARTEDDEVICE and KEYNAME with your own info
# Install GRUB and Parted packages if needed : grub-efi-amd64-bin grub-efi-ia32-bin grub-pc-bin parted dosfstools

/bin/echo -e "DELETE ALL PARTITIONS BE CAREFULL!!! USE AT YOUR OWN RISKS!!!"
read -e -p "Are you sure (YES/NO)? " -i NO USBFORMATCONFIRM
if [ ${USBFORMATCONFIRM} != "YES" ] ; then /bin/echo "Abort!" ; return 0 ; fi

read -e -p "USBKEY device name: " -i sdz PARTEDDEVICE
if [ ! -e /dev/${PARTEDDEVICE} ] ; then /bin/echo "Bad device name! Abort." ; return 0 ; fi

read -e -p "USBKEY name prefix: " -i S128 KEYNAME
if [ ${#KEYNAME} -lt 1 ] ; then /bin/echo "Bad device prefix! Abort." ; return 0 ; fi

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

wget -O ${KEYLINTMPDIR}/boot/grub/grub.cfg https://gitlab.com/nicolasi31/public/-/raw/master/grub/usbkey.cfg
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

```

## RESULT FDISK

> In this example an encrypted 5th partition has been added

```shell
root@localhost:~# fdisk -l /dev/sdc
Disk /dev/sdc: 114.61 GiB, 123060879360 bytes, 240353280 sectors
Disk model: Ultra USB 3.0   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 34A3D910-B28B-46A7-91EF-38D8FEF56870
Device         Start       End   Sectors  Size Type
/dev/sdc1       2048    262143    260096  127M EFI System
/dev/sdc2     262144    524287    262144  128M BIOS boot
/dev/sdc3     524288  11010047  10485760    5G Linux filesystem
/dev/sdc4   11010048 178782207 167772160   80G Microsoft basic data
/dev/sdc5  178782208 240353246  61571039 29.4G Linux filesystem
```

----

# Fedora Bootable USBKEY

# Script
From a Fedora system
- Install livecd-tools package
- Create a bootable partition on The USBKEY
- Format The USBKEY in ext4 or vfat
- Run the command:
```shell
livecd-iso-to-disk --reset-mbr --overlay-size-mb 300 --home-size-mb 200 --unencrypted-home /PathTo/Fedora-Workstation-Live-x86_64-32-1.6.iso /dev/sdz1
```
> /dev/sdz1 : USBKEY ext4/vfat partition

# Manual
- Mount Fedora ISO file
- Create a LiveOS directory on USBKEY root
- Copy the following files from the ISO in the LiveOS directory
  - /isolinux/initrd.img
  - /isolinux/vmlinuz
  - /LiveOS/squashfs.img
- Create an overlay file for persistence in the LiveOS directory
```shell
dd if=/dev/null of=/LiveOS/overlay-MYUSBKEYPartitionLabel-MYUSBKEYPartitionUUID bs=1 count=0 seek=1024M status=progress
```
> MYUSBKEYPartitionLabel : Name/Label of the USBKEY partition where is located LiveOS directory.\
> MYUSBKEYPartitionUUID : UUID of the USBKEY partition where is located LiveOS directory.\
> Do not format the overlay file.
- Update your grub.conf (example in the usbkey.cfg).

