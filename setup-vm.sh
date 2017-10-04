#!/bin/bash

for i in "$@"; do
    name=${PREFIX:?oops}-vm-${i}
    virsh pool-refresh default
    virsh vol-clone --pool default ${CLOUD_IMG:-CentOS-7-x86_64-GenericCloud.qcow2} ${name}.img
    virsh vol-resize --pool default ${name}.img +50G
    virsh pool-refresh default
    virt-install -r 4096 \
		 --os-variant=linux \
		 -n $name \
		 --vcpus=2 \
		 --autostart \
		 --noautoconsole \
		 --memballoon virtio \
		 --boot hd \
		 --disk vol=default/${name}.img,format=qcow2,bus=virtio,cache=writeback,size=${DISK_SIZE:-50} \
		 --disk vol=default/${name}-ds.iso,bus=virtio \
		 --network network=${NETWORK:?nonet},model=virtio \

done
