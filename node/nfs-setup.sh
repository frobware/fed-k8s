#!/bin/bash

cat <<EOF | sudo tee -a /etc/auto.data
src -rw,soft,intr 192.168.1.64:/home/aim/go-projects/origin/src
EOF

cat <<EOF | sudo tee -a /etc/auto.master
/data /etc/auto.data
EOF

sudo ${DNF:-dnf} install -y nfs-utils autofs

sudo systemctl enable autofs
sudo systemctl restart autofs
