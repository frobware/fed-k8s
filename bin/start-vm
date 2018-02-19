#!/bin/bash

for i in "$@"; do
    name=${PREFIX:?oops}-vm-${i}
    virsh start $name
done
