**PXE**

[[_TOC_]]

----

# Distrib kernels and initram
```shell
DEST_DIR="/var/www/html/efi64/boot"
MIRROR_URL="http://129.102.1.37/pub"
wget -O ${DEST_DIR}/initrd.img.c8         ${MIRROR_URL}/CentOS/8/BaseOS/x86_64/os/images/pxeboot/initrd.img
wget -O ${DEST_DIR}/vmlinuz.c8            ${MIRROR_URL}/CentOS/8/BaseOS/x86_64/os/images/pxeboot/vmlinuz
wget -O ${DEST_DIR}/vmlinuz.d10           ${MIRROR_URL}/debian/dists/stable/main/installer-amd64/current/images/netboot/gtk/debian-installer/amd64/linux
wget -O ${DEST_DIR}/initrd.gz.d10         ${MIRROR_URL}/debian/dists/stable/main/installer-amd64/current/images/netboot/gtk/debian-installer/amd64/initrd.gz
wget -O ${DEST_DIR}/initramfs-virt.alpine ${MIRROR_URL}/alpine/latest-stable/releases/x86_64/netboot/initramfs-virt
wget -O ${DEST_DIR}/vmlinuz-virt.alpine   ${MIRROR_URL}/alpine/latest-stable/releases/x86_64/netboot/vmlinuz-virt
```

----

# My own Templates download
```shell
DEST_DIR="/var/www/html/ks"
GITLAB_MYURL="https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates"
wget -O ${DEST_DIR}/debian-preseed-kvm-full.cfg   ${GITLAB_MYURL}/debian/debian-preseed-kvm-full.cfg
wget -O ${DEST_DIR}/debian-preseed-hv-full.cfg    ${GITLAB_MYURL}/debian/debian-preseed-hv-full.cfg
wget -O ${DEST_DIR}/debian-preseed-hv-light.cfg   ${GITLAB_MYURL}/debian/debian-preseed-hv-light.cfg
wget -O ${DEST_DIR}/centos-preseed-hv.ks          ${GITLAB_MYURL}/centos/centos-preseed-hv.ks
wget -O ${DEST_DIR}/centos-preseed-live.ks        ${GITLAB_MYURL}/centos/centos-preseed-live.ks
wget -O ${DEST_DIR}/centos-preseed.ks             ${GITLAB_MYURL}/centos/centos-preseed.ks
wget -O ${DEST_DIR}/ubuntu-preseed-hv-full.cfg    ${GITLAB_MYURL}/ubuntu/ubuntu-preseed-hv-full.cfg
wget -O ${DEST_DIR}/ubuntu-preseed-hv-light.cfg   ${GITLAB_MYURL}/ubuntu/ubuntu-preseed-hv-light.cfg
wget -O ${DEST_DIR}/fedora-preseed-hv.ks          ${GITLAB_MYURL}/fedora/fedora-preseed-hv.ks
```

----

# CENTOS: add drivers in INITRAM via DRACUT
```shell
dracut --add-drivers "virtio_balloon virtio_scsi virtio_console virtio_net dm_mirror dm_region_hash dm_log dm_mod vfat xfs ext4" --force /boot/initramfs-4.18.0-193.el8.x86_64.img 4.18.0-193.el8.x86_64
dracut --add-drivers "virtio_balloon virtio_scsi virtio_console virtio_net dm_mirror dm_region_hash dm_log dm_mod vfat xfs ext4" --force /boot/initramfs-4.18.0-193.6.3.el8_2.x86_64.img 4.18.0-193.6.3.el8_2.x86_64
```

----

# PXE files backup
## Simple tgz backup
```shell
sudo tar zcvf /tmp/pxehv.${HOSTNAME}.${USER:-${USERNAME}}.$(/bin/date +%Y%m%d%H%M%S).tgz /etc/named* /var/named/ /etc/dhcp/ /var/www/html/
```

## Full 7zip backup
```shell
yum install http://129.102.1.37/pub/fedora/epel/8/Everything/x86_64/Packages/p/p7zip-16.02-16.el8.x86_64.rpm
cd / ; sudo 7za a -p -mhe=on \
 -xr\!var/www/html/boot/debian10.live.filesystem.squashfs \
 -xr\!var/www/html/boot/VMware-VMvisor-Installer-6.5.0.update01-5969303.x86_64.iso \
 /tmp/pxehv.${HOSTNAME}.${USER:-${USERNAME}}.$(/bin/date +%Y%m%d%H%M%S).7z \
 etc/named* \
 var/named/ \
 etc/dhcp/ \
 var/www/html/ \
 etc/yum.repos.d/ \
 etc/sysconfig/network-scripts/ \
 etc/sysconfig/selinux \
 etc/sysconfig/dhcpd \
 etc/sysconfig/rsyslog \ 
 etc/ssh/sshd_config \
 etc/hosts \
 etc/fstab \
 etc/profile.d/perso-*.sh \
 boot/efi/EFI/centos/custom.cfg \
 boot/efi/EFI/centos/grub.cfg \
 boot/efi/EFI/centos/grubenv \
```

----

# SYSLINUX/PXELINUX: Generate FR keymap
- https://bugzilla.syslinux.org/show_bug.cgi?id=68
```shell
/var/www/html/keytab-lilo /usr/share/keymaps/i386/qwerty/us.kmap.gz /usr/share/keymaps/i386/azerty/fr.kmap.gz > /tmp/fr.ktl
/var/www/html/keytab-lilo /usr/lib/kbd/keymaps/xkb/us.map.gz /usr/lib/kbd/keymaps/legacy/i386/azerty/fr.map.gz > /tmp/fr.ktl
keytab-lilo -p 60=46 -p 92=60 -p 124=62 /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/share/kbd/keymaps/i386/azerty/fr-pc.map.gz > /boot/syslinux/fr-pc.ktl
```
