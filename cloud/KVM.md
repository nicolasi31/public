**Table of Content**

[[_TOC_]]

## Empty disk image creation ###
```shell
VM_NAME="vmtest01"
VM_IMG_DIR="/media/donnees/virtualisation/images"
VM_HDD_FORMAT="qcow2"
VM_HDD_SIZE="20G"
qemu-img create -f ${VM_HDD_FORMAT} ${VM_IMG_DIR}/${VM_NAME}.${VM_HDD_FORMAT} ${VM_HDD_SIZE}
```

## PXE installation ###
```shell
VM_NAME="vmtest01"
VM_CPU="2"
VM_RAM="2048"
VM_IMG_DIR="/media/donnees/virtualisation/images"
VM_NETWORK="default"

virt-install --connect qemu:///system --virt-type kvm --hvm \
 --name ${VM_NAME} \
 --boot uefi,network,hd,menu=off,useserial=on --machine q35 \
 --serial pty --graphics none --video none --sound none \
 --cpu mode=host-passthrough --vcpus ${VM_CPU} --ram ${VM_RAM} \
  --os-type=linux --os-variant=generic --controller usb,model="none" \
  --disk ${VM_IMG_DIR}/${VM_NAME}.qcow2,format=qcow2,bus=virtio \
  --network=network:${VM_NETWORK},model=virtio --noautoconsole \
  --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${VM_NAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0 \
  --pxe
```

## Cloud-init installation ###
```shell
VM_NAME="vmtest01"
VM_ORG_DIR="/media/donnees/virtualisation/originals"
VM_IMG_DIR="/media/donnees/virtualisation/images"
VM_DEB_ORG_IMG_URL=""
VM_CENT_ORG_IMG_URL=""
VM_ROOTPASSW="gfdgdhtrytjhyjn"
VM_CPU="2"
VM_RAM="2048"
VM_HDDSIZE="20G"
VM_NETWORK="default"
VM_IPADDR="192.168.0.100"
VM_INT="eth0"
VM_GITLAB_URL="https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/cloud-init/"
VM_DEB_ORG_IMG_URL_ROOT="http://cdimage.debian.org/cdimage/openstack/current-10"
VM_CENT_ORG_IMG_URL_ROOT="https://cloud.centos.org/centos/8/x86_64/images"

VM_DEB_ORG_IMG_URL="${VM_DEB_ORG_IMG_URL_ROOT}$(wget -q -O - ${VM_DEB_ORG_IMG_URL_ROOT} | grep -o "debian-[0-9]*-openstack-amd64.qcow2" | tac | head -n 1)"
VM_CENT_ORG_IMG_URL="${VM_CENT_ORG_IMG_URL_ROOT}$(wget -q -O - ${VM_CENT_ORG_IMG_URL_ROOT} | grep -o "CentOS-8-GenericCloud[a-zA-Z0-9_.-]*.qcow2" | tac | head -n 1)"

VM_NETMODE="dhcp"
#VM_NETMODE="${VM_NAME}-${VM_IPADDR}"

wget -q -O ${VM_ORG_DIR}/tempvm.qcow2 ${VM_DEB_ORG_IMG_URL}
# wget -q -O ${VM_ORG_DIR}/tempvm.qcow2 ${VM_CENT_ORG_IMG_URL}; }

qemu-img create -f qcow2 ${VM_IMG_DIR}/${VM_NAME}.qcow2 ${VM_HDDSIZE}

virt-resize -q --expand /dev/vda1 ${VM_ORG_DIR}/tempvm.qcow2 ${VM_IMG_DIR}/${VM_NAME}.qcow2; }
rm -f ${VM_ORG_DIR}/tempvm.qcow2

virt-customize -a ${VM_IMG_DIR}/${VM_NAME}.qcow2 \
 --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub \
 --hostname ${VM_NAME} \
 --run-command "/bin/echo -e 'kernel.domainname=${VM_DOMAIN}\nkernel.hostname=${VM_NAME}' > /etc/sysctl.d/10-${VM_NAME}.conf" \
 --run-command "/bin/echo -e 'net.ipv6.conf.${VM_INTF}.disable_ipv6=1' >> /etc/sysctl.d/10-${VM_NAME}.conf" \
 --selinux-relabel

virt-install --connect qemu:///system --virt-type kvm --hvm --import \
 --name ${VM_NAME} --metadata title="${VM_DESC}" --metadata description="${VM_TITLE}" \
 --boot menu=off,useserial=on --machine q35 \
 --serial pty --graphics spice --video virtio --sound none \
 --cpu mode=host-passthrough --vcpus ${VM_CPU} --ram ${VM_RAM} \
 --os-type=linux --os-variant=generic \
 --disk ${VM_IMG_DIR}/${VM_NAME}.qcow2,format=qcow2,bus=virtio \
 --network=network:${VM_NETWORK},model=virtio --noautoconsole \
 --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${VM_NAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0 \
 --qemu-commandline="-smbios type=1,serial=ds=nocloud-net;s=${VM_GITLAB_URL}${VM_NETMODE}/"
```

## MicroVM installation ###
```shell
VM_NAME="vmtest01"
VM_IMG_DIR="/media/donnees/virtualisation/images"
VM_KERNEL_IMG="/media/donnees/virtualisation/kernel/bzImage"
VM_ORG_IMG_CENT="/media/donnees/virtualisation/originals/CentOS-8-GenericCloud-8.2.2004-20200611.2.x86_64.qcow2"
VM_ORG_IMG_DEB="/media/donnees/virtualisation/originals/debian-10-openstack-amd64.qcow2"
VM_ORG_PART="/dev/sda1"
VM_KERNEL_OPT="console=hvc0 console=ttyS0 root=/dev/vda reboot=k panic=1 pci=off nomodules rw time ipv6.disable=1 net.ifnames=1 biosdevname=1 selinux=0 apparmor=0 ip=::::${VM_NAME}::on:::"
VM_CPU="2"
VM_RAM="4096"
VM_OS_VARIANT="centos8"
VM_IMG_EXTENSION="qcow2"
VM_HDDSIZE="20G"
VM_NET="default"
VM_MACADDRESS=",mac=52:54:00:12:34:56"
VM_DOMAIN="example.com"
VM_INTF="eth0"

qemu-img create -f qcow2 ${VM_IMG_DIR}/${VM_NAME}.${VM_IMG_EXTENSION} ${VM_HDDSIZE}

guestfish --ro -a ${VM_ORG_IMG_CENT} -m ${VM_ORG_PART} -- tar-out / - | guestfish --rw -a ${VM_IMG_DIR}/${VM_NAME}.${VM_IMG_EXTENSION} -m /dev/sda -- tar-in - /
#guestfish --ro -a ${VM_ORG_IMG_DEB} -m ${VM_ORG_PART} -- tar-out / - | guestfish --rw -a ${VM_IMG_DIR}/${VM_NAME}.${VM_IMG_EXTENSION} -m /dev/sda -- tar-in - /

virt-customize -a ${VM_IMG_DIR}/${VM_NAME}.${VM_IMG_EXTENSION} \
 --ssh-inject root:file:${HOME}/.ssh/id_rsa.pub \
 --hostname ${VM_NAME} \
 --run-command "/bin/echo -e 'kernel.domainname=${VM_DOMAIN}\nkernel.hostname=${VM_NAME}' > /etc/sysctl.d/10-${VM_NAME}.conf" \
 --run-command "/bin/echo -e 'net.ipv6.conf.${VM_INTF}.disable_ipv6=1' >> /etc/sysctl.d/10-${VM_NAME}.conf" \
 --selinux-relabel

virt-install --connect qemu:///system --virt-type kvm --hvm --import  --name ${VM_NAME} --machine microvm --arch x86_64 \
 --boot menu=off,useserial=on,kernel=${VM_KERNEL_IMG},kernel_args="${VM_KERNEL_OPT}" \
 --cpu mode=host-passthrough  --vcpus ${VM_CPU} --ram ${VM_RAM} \
 --video none --graphics none --sound none  --controller usb,model=none \
 --os-type=linux --os-variant=${VM_OS_VARIANT} \
 --disk ${VM_IMG_DIR}/${VM_NAME}.${VM_IMG_EXTENSION},format=${VM_IMG_EXTENSION},bus=virtio,driver.iommu=on,address.type=virtio-mmio \
 --network=network:${VM_NET},target=${VM_NAME},model=virtio,driver.iommu=on,address.type=virtio-mmio${VM_MACADDRESS} \
 --memballoon virtio,driver.iommu=on,address.type=virtio-mmio \
 --rng random,address.type=virtio-mmio \
 --vsock model=virtio,address.type=virtio-mmio \
 --controller type=virtio-serial,driver.iommu=on,address.type=virtio-mmio \
 --channel unix,mode=bind,path=/var/lib/libvirt/qemu/${VM_NAME}.agent,target_type=virtio,name=org.qemu.guest_agent.0,address.type=virtio-mmio \
 --noautoconsole \
 --features acpi=off,apic=off \
 --qemu-commandline="-M microvm,x-option-roms=off,pit=off,pic=off,isa-serial=off,rtc=off -nodefaults -no-user-config -no-acpi" ; \
```

# Description/Title update
```shell
VM_NAME="vmtest01"
VM_USER="vmuser"
VM_IPADDR="192.168.0.100"
VM_NETMASK="255.255.255.0"
VM_MACADDR="52:54:00:12:34:56"
VM_NET="default"
VM_DOMAIN="example.com"
VM_DNS="192.168.0.254"
VM_GW="192.168.0.254"

virsh -q desc --live --config ${VM_NAME} "Name    : ${VM_NAME}
User    : ${VM_USER}
IP      : ${VM_IPADDR}
MASK    : ${VM_NETMASK}
VMMAC   : ${VM_MACADDR}
GW      : ${VM_GW}
DNS     : ${VM_DNS}
Network : ${VM_NET}
VM UUID : $(virsh domuuid ${VM_NAME})

Console:
virsh console ${VM_NAME}

SSH:
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -l ${VM_USER} ${VM_IPADDR}"

virsh -q desc --live --config --title ${VM_NAME} \
 "${VM_NAME}$(head -c $((20 - ${#VM_NAME})) /dev/zero | tr '\0' ' ')${VM_IPADDR}/${VM_NETMASK}$(head -c $((16 - ${#VM_IPADDR})) /dev/zero | tr '\0' ' ')${VM_MACADDR}"
```

# Send the VM a Ctrl-Alt-Del signal
```shell
VM_NAME="vmtest01"
virsh send-key ${VM_NAME} --holdtime 1000 KEY_LEFTCTRL KEY_LEFTALT KEY_DELETE
```

# Take a screenshot
```shell
VM_NAME="vmtest01"
virsh screenshot ${VM_NAME} ~/${VM_NAME}-VM-screenshot.$(date +%Y%m%d%H%M%S).png
```

# Some usefull stats
```shell
read -e -p "VM name: " VM_NAME ; \
(\
/bin/echo -e "*** Domain ID ***" ; \
virsh domid ${VM_NAME} ; \
/bin/echo -e "*** Domain UUID ***" ; \
virsh domuuid ${VM_NAME} ; \
/bin/echo -e "*** Domain state ***" ; \
virsh domstate ${VM_NAME} ; \
/bin/echo -e "*** Domain control check ***" ; \
virsh domcontrol ${VM_NAME} ; \
/bin/echo -e "*** Domain IP addr via agent ***" ; \
virsh domifaddr ${VM_NAME} --source agent ; \
/bin/echo -e "*** Domain info ***" ; \
virsh dominfo ${VM_NAME} ; \
/bin/echo -e "*** Domain job info ***" ; \
virsh domjobinfo ${VM_NAME} ; \
/bin/echo -e "*** Domain memory stats ***" ; \
virsh dommemstat ${VM_NAME} ; \
/bin/echo -e "*** Domain stats ***" ; \
virsh domstats ${VM_NAME} ; \
/bin/echo -e "*** Domain HDD list ***" ; \
virsh domblklist ${VM_NAME} ; \
/bin/echo -e "*** Domain HDD stats ***" ; \
virsh domblkstat ${VM_NAME} ; \
/bin/echo -e "*** Domain HDD errors ***" ; \
virsh domblkerror ${VM_NAME} \
) | less
```

# 9p Filesystem mount
```shell
VM_9P_SHARENAME="myshare"
modprobe 9pnet_virtio
mount -t 9p -o trans=virtio,version=9p2000.L,rw ${VM_9P_SHARENAME} /media/${VM_9P_SHARENAME}
#
# automount... doesn't work...
#/media/monpartage ${VM_9P_SHARENAME} 9p trans=virtio,version=9p2000.L,noauto 0 0
```
