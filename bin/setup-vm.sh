#!/bin/bash

for i in "$@"; do
    name=${PREFIX:?oops}-vm-${i}
    virsh pool-refresh default
    virsh vol-clone --pool default ${CLOUD_IMG:-Fedora-Cloud-Base-26-1.5.x86_64.qcow2} ${name}.qcow2
    virsh vol-resize --pool default ${name}.qcow2 +50G
    virsh pool-refresh default
    virt-install -r 4096 \
		 --os-variant=${OS_VARIANT:-rhel7.4} \
		 -n $name \
		 --vcpus=2 \
		 --noautoconsole \
		 --memballoon virtio \
		 --boot hd \
		 --disk vol=default/${name}.qcow2,format=qcow2,bus=virtio,cache=writeback,size=${DISK_SIZE:-50} \
		 --disk vol=default/${name}-ds.iso,bus=virtio \
		 --network network=${NETWORK:?nonet},model=virtio \

done
