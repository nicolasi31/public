**Table of Content**

[[_TOC_]]

# Usefull links
- https://github.com/cloud-hypervisor/cloud-hypervisor/releases
- https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases

# Commands
```shell
VM_NAME="vmtest01"
VM_CPU="2"
VM_RAM="2048"
VM_NETWORK="brwan"
VM_MAC="52:54:c0:a8:00:0a"
VM_IPADDR="192.168.0.10"
VM_IPMASK="255.255.255.0"

wget -O /tmp/hypervisor-fw    https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/0.2.7/hypervisor-fw
wget -O /tmp/cloud-hypervisor https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/v0.7.0/cloud-hypervisor
chmod +x /tmp/cloud-hypervisor /tmp/hypervisor-fw

/tmp/cloud-hypervisor \
--kernel /tmp/hypervisor-fw \
--disk path=/tmp/${VM_NAME}.qcow2 \
--cpus boot=${VM_CPU} \
--memory size=${VM_RAM} \
--net tap=,mac=${VM_MAC},ip=${VM_IPADDR},mask=${VM_IPMASK},num_queues=4,queue_size=256 \
--api-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock \
--rng  --console off --serial tty

/bin/rm -f /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock
/bin/rm -i ${VM_IMGDIR}${VM_NAME}.qcow2

# Lancement alternatif via API, la console est attachée à la première commande.

/tmp/cloud-hypervisor --api-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock

curl --unix-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock -i \
     -X PUT "http://localhost/api/v1/vm.create"  \
     -H "Accept: application/json"               \
     -H "Content-Type: application/json"         \
     -d '{
         "cpus":{"boot_vcpus":2,"max_vcpus":2},
         "memory":{"size":2147483648},
         "kernel":{"path":"/tmp/hypervisor-fw"},
         "disks":[{"path":"/tmp/${VM_NAME}.qcow2"}],
         "net":[{"tap":"${VM_NAME}"}],
         "rng":{"src":"/dev/urandom"},
         "serial":{"mode":"Tty"},
         "console":{"mode":"Off"}
         }'

curl --unix-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock -i -X PUT "http://localhost/api/v1/vm.boot"
curl --unix-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock -i -X GET "http://localhost/api/v1/vm.info" -H "Accept: application/json"
curl --unix-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock -i -X PUT "http://localhost/api/v1/vm.reboot"
curl --unix-socket /tmp/ch-${VM_NAME}-${VM_IPADDR}.sock -i -X PUT "http://localhost/api/v1/vm.shutdown"
```
