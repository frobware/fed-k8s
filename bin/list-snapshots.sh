#!/bin/bash

for i in "$@"; do
    name=${PREFIX:?oops}-vm-${i}
    virsh snapshot-list $name
done
