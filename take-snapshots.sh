#!/bin/bash

: ${SNAPSHOT:="base"}

for i in "$@"; do
    name=${PREFIX:?oops}-vm-${i}
    echo virsh snapshot-create-as $name --name ${SNAPSHOT}-${name} --description "${SNAPSHOT}" 
done
