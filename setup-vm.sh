#!/bin/bash

for i in "$@"; do
    name=fedk8s-vm-${i}
    virsh pool-refresh default
    virsh vol-clone --pool default ${CLOUD_IMG:-xenial-server-cloudimg-amd64-disk1.img} ${name}.img
    virsh vol-resize --pool default ${name}.img +10G
    virsh pool-refresh default
    virt-install -r 4096 \
		 --os-variant=linux \
		 -n $name \
		 --vcpus=2 \
		 --autostart \
		 --noautoconsole \
		 --memballoon virtio \
		 --boot hd \
		 --disk vol=default/${name}.img,format=qcow2,bus=virtio,cache=writeback,size=${DISK_SIZE:-10} \
		 --disk vol=default/${name}-ds.iso,bus=virtio \
		 --network network=fedk8s,model=virtio \

done
