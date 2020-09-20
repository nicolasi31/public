**Kernel compilation**

[[_TOC_]]

# Howto build a monolithic kernel for microvm

```shell

KERNVERS="5.8"
# get last kernel and uncompress
cd /usr/src/
wget -O /usr/src/linux-${KERNVERS}.tar.xz https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNVERS}.tar.xz
tar Jxvf linux-${KERNVERS}.tar.xz

# delete linux symlink from previous compil if needed
rm -f linux

# create linux symlink
ln -sf linux-${KERNVERS} linux

cd linux

# get kernel monolithic config (from firecracker team, but works for Qemu and Cloud-Hypervisor)
wget -O .config https://github.com/firecracker-microvm/firecracker/blob/master/resources/microvm-kernel-x86_64.config

# update config, don't forget to activate VIRTIO devices if needed
make menuconfig

# compil kernel
make -j32
```

> path to compiled kernel : /usr/src/linux/arch/x86/boot/bzImage

# special steps for firecracker, since it doesn't know how to handle bz compressed kernel
```shell
cd ~
rm -rf _bzImage.extracted/
binwalk --extract /usr/src/linux/arch/x86/boot/bzImage
```

> path to uncompressed kernel : ~/_bzImage.extracted/38E9

