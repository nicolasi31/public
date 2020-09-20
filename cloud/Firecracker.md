**Table of Content**

[[_TOC_]]

# Usefull links
- https://github.com/firecracker-microvm/firecracker/releases

# Commands
```shell
VM_NAME="vmtest01"
VM_NETWORK="brwan"

wget -O /tmp/firecracker https://github.com/firecracker-microvm/firecracker/releases/download/v0.21.1/firecracker-v0.21.1-x86_64
chmod +x /tmp/firecracker

wget -O /tmp/fc-${VM_NAME}.json https://gitlab.com/nicolasi31/public/-/raw/master/cloud/templates/firecracker-${VM_NAME}.json

sudo ip tuntap add fc${VM_NAME} mode tap
sudo ip link set dev fc${VM_NAME} mtu 1400 up
sudo ip link set dev fc${VM_NAME} master ${VM_NETWORK}

/tmp/firecracker --id ${VM_NAME} --api-sock /tmp/fc-${VM_NAME}.sock --config-file /tmp/fc-${VM_NAME}.json

curl --unix-socket /tmp/fc-${VM_NAME}.sock -i -X PUT \
 "http://localhost/actions" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"action_type\": \"SendCtrlAltDel\" }"

sudo ip link del dev ${VM_NAME}
/bin/rm -f /tmp/fc-${VM_NAME}.sock
```
