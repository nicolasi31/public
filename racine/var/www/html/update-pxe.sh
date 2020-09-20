
wget -O /var/www/html/efi64/boot/initrd.img.c8 \
 http://129.102.1.37/pub/CentOS/8/BaseOS/x86_64/os/images/pxeboot/initrd.img
wget -O /var/www/html/efi64/boot/vmlinuz.c8 \
 http://129.102.1.37/pub/CentOS/8/BaseOS/x86_64/os/images/pxeboot/vmlinuz

wget -O /var/www/html/efi64/boot/vmlinuz.d10 \
http://129.102.1.37/pub/debian/dists/stable/main/installer-amd64/current/images/netboot/gtk/debian-installer/amd64/linux
wget -O /var/www/html/efi64/boot/initrd.gz.d10 \
http://129.102.1.37/pub/debian/dists/stable/main/installer-amd64/current/images/netboot/gtk/debian-installer/amd64/initrd.gz

wget -O /var/www/html/efi64/boot/initramfs-virt.alpine \
 http://129.102.1.37/pub/alpine/latest-stable/releases/x86_64/netboot/initramfs-virt
wget -O /var/www/html/efi64/boot/vmlinuz-virt.alpine \
 http://129.102.1.37/pub/alpine/latest-stable/releases/x86_64/netboot/vmlinuz-virt

wget -O /var/www/html/ks/debian-preseed-kvm-full.cfg \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/debian-preseed-kvm-full.cfg
wget -O /var/www/html/ks/debian-preseed-hv-full.cfg \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/debian-preseed-hv-full.cfg
wget -O /var/www/html/ks/debian-preseed-hv-light.cfg \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/debian-preseed-hv-light.cfg
wget -O /var/www/html/ks/centos-preseed-hv.ks \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/centos-preseed-hv.ks
wget -O /var/www/html/ks/centos-preseed-live.ks \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/centos-preseed-live.ks
wget -O /var/www/html/ks/centos-preseed.ks \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/centos-preseed.ks
wget -O /var/www/html/ks/ubuntu-preseed-hv-full.cfg \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/ubuntu-preseed-hv-full.cfg
wget -O /var/www/html/ks/ubuntu-preseed-hv-light.cfg \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/ubuntu-preseed-hv-light.cfg
wget -O /var/www/html/ks/fedora-preseed-hv.ks \
 https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/kickstart/fedora-preseed-hv.ks



sudo tar zcvf /tmp/pxehv.${HOSTNAME}.${USER:-${USERNAME}}.$(/bin/date +%Y%m%d%H%M%S).tgz /etc/named* /var/named/ /etc/dhcp/ /var/www/html/

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




# https://bugzilla.syslinux.org/show_bug.cgi?id=68
/var/www/html/keytab-lilo /usr/share/keymaps/i386/qwerty/us.kmap.gz /usr/share/keymaps/i386/azerty/fr.kmap.gz > /tmp/fr.ktl
/var/www/html/keytab-lilo /usr/lib/kbd/keymaps/xkb/us.map.gz /usr/lib/kbd/keymaps/legacy/i386/azerty/fr.map.gz > /tmp/fr.ktl

