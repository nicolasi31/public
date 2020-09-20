**Storage**

[[_TOC_]]

----

# LVM
```shell
vgscan
vgchange -a y
```

----

# dd
## 30Go partition creation
```shell
dd if=/dev/zero of=/mnt/wd640/fichier_partition bs=1024 count=30000000
```

## partition / hdd save and restore
```shell
dd if=/dev/sdx of=/path/to/image
dd if=/path/to/image of=/dev/sdx
```

## with compression
```shell
dd if=/dev/sdx | gzip > /path/to/image.gz
gzip -dc /path/to/image.gz | dd of=/dev/sdx
```

## DVD rip
```shell
dd if=/dev/dvd of=Name_of_DVD.iso
```

----

# geniso
## create iso file with a directory content and copy to USBKEY
```shell
genisoimage -o /tmp/bin.iso -hfs -J -r -graft-points /home/user01/bin/
```
or
```shell
xorriso -outdev /tmp/bin.iso -blank as_needed \
 -map /home/user01/bin /bin \
 -commit_eject all
dd bs=4M if=/tmp/bin.iso of=/dev/sdc
```

----

# growisofs
## To master and burn an ISO9660 volume with Joliet and Rock-Ridge extensions on a DVD or Blu-ray Disc
```shell
growisofs -Z /dev/dvd -R -J /some/files
```

## To append more data to same media
```shell
growisofs -M /dev/dvd -R -J /more/files
```

> Make sure to use the same options for both initial burning and when appending data.
> To finalize the multisession DVD maintaining maximum compatibility:
```shell
growisofs -M /dev/dvd=/dev/zero
```

## write a pre-mastered ISO-image to a DVD
```shell
growisofs -dvd-compat -Z /dev/dvd=image.iso
```

----

# mkisofs and dvdrecord
creer les repertoires VIDEO_TS et audio_TS
```shell
mkisofs -dvd-video -o dvd.iso mastructure/
dvdrecord -dao dev=0,0,0 dvd.iso
```

----

# TAR
## créate a tar archive, excluding mp3, mp4 and jpg
```shell
tar jcvf www.tar.bz2 www \
 --exclude="*.jpg" \
 --exclude="*.JPG" \
 --exclude="*.mp3" \
 --exclude="*.MP3" \
 --exclude="*.mp4" \
 --exclude="*.MP4"
```

```shell
TARGPGDATE=$(date +%Y%m%d%H%M%S)
tar jcvf html-pxe-${TARGPGDATE}.tar.bz2 \
 --exclude=VMware-VMvisor-Installer-6.5.0.update01-5969303.x86_64.iso \
 --exclude=debian10.live.filesystem.squashfs \
 --exclude=centos.7.squashfs.img html
gpg -o html-pxe-${TARGPGDATE}.tar.bz2.gpg --symmetric html-pxe-${TARGPGDATE}.tar.bz2
```

----

# zip (non recursive...)
```shell
ZIPDATE=$(date +%Y%m%d%H%M%S)
zip \
 -e html-pxe-${ZIPDATE}.zip \
 html \
 --exclude VMware-VMvisor-Installer-6.5.0.update01-5969303.x86_64.iso \
 --exclude debian10.live.filesystem.squashfs \
 --exclude centos.7.squashfs.img
```

----

# TAR and GPG
## How do I password protect a tgz file with tar and gpg
- https://superuser.com/questions/370389/how-do-i-password-protect-a-tgz-file-with-tar-in-unix
```shell
TARGPGDATE=$(date +%Y%m%d%H%M%S)
gpg -o fileToTar.${TARGPGDATE}.tgz.gpg --symmetric fileToTar.${TARGPGDATE}.tgz
# This will prompt you for a passphrase.
# Note: -c is short for --symmetric, i.e., use the default symmetric cipher, which means that
# the same passphrase is used for both encryption and decryption. (As opposed to asymmetric,
# which involves public keys and private keys.)
# To decrypt the file later on, just do a:
gpg fileToTar.${TARGPGDATE}.tgz.gpg
```

## file saving with gpg et tar
```shell
TARGPGDATE=$(date +%Y%m%d%H%M%S)
tar -cf- /etc/network/interfaces | gpg -c > interfaces.tar.${TARGPGDATE}.gpg
gpg -d -o - interfaces.tar.${TARGPGDATE}.gpg  | tar vtf -
gpg -d -o - interfaces.tar.${TARGPGDATE}.gpg  | tar vxf -
```

----

# 7zip
## create encrypted 7zip archive, including files name (headers)
```shell
7z a -r -p -mhe=on interfaces.$(date +%Y%m%d%H%M%S).7z /etc/network/interfaces
```

## exclusion
```shell
7z a -mhe=on -p \
 -x\!user01/.cache \
 -x\!user01/Documents \
 -x\!user01/Images \
 /media/donnees/user01-ubuntu-$(date +%Y%m%d%H%M%S).7z /home/user01
```

# ISCSI configuration
```shell
ISCSI_TARGET_NAME="iqn.2018-12.com.example:pxe.iscsi1"
ISCSI_TARGET_ID=1
ISCSI_LUN=1
ISCSI_SERVER_IP="192.168.0.252"
ISCSI_SERVER_PORT="3260"
ISCSI_SRC_DEVICE="/dev/vdb"

tgtadm --lld iscsi --op new --mode target --tid ${ISCSI_TARGET_ID} -T ${ISCSI_TARGET_NAME}
tgtadm --lld iscsi --op new --mode logicalunit --tid ${ISCSI_TARGET_ID} --lun ${ISCSI_LUN} -b ${ISCSI_SRC_DEVICE}
tgtadm --lld iscsi --op bind --mode target --tid ${ISCSI_TARGET_ID} -I ALL

tgtadm --lld iscsi --op show --mode target

iscsiadm -m node -T "${ISCSI_TARGET_NAME}" -p ${ISCSI_SERVER_IP} -u

iscsiadm --mode node --targetname ${ISCSI_TARGET_NAME} --portal ${ISCSI_SERVER_IP}:${ISCSI_SERVER_PORT} --login
```

