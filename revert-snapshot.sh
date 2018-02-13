#!/bin/bash

: ${SNAPSHOT:?"you-did-not-set-a-SNAPSHOT"}

for i in "$@"; do
    name=${PREFIX:?oops}-vm-${i}
    echo virsh snapshot-revert $name ${SNAPSHOT}
done
