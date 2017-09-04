#!/bin/bash

for i in "$@"; do
    name=fedk8s-vm-${i}
    virsh pool-refresh default
    virsh vol-clone --pool default ${CLOUD_IMG:-Fedora-Cloud-Base-26-1.5.x86_64.raw} ${name}.img
    virsh vol-resize --pool default ${name}.img +10G
    virsh pool-refresh default
    virt-install -r 1024 \
		 --os-variant=linux \
		 -n $name \
		 --vcpus=1 \
		 --autostart \
		 --noautoconsole \
		 --memballoon virtio \
		 --boot hd \
		 --disk vol=default/${name}.img,format=qcow2,bus=virtio,cache=writeback,size=${DISK_SIZE:-10} \
		 --disk vol=default/${name}-ds.iso,bus=virtio \
		 --network network=fedk8s,model=virtio \

done
