#!/bin/bash

sudo ${DNF:-dnf} install -y docker

echo "INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" | sudo tee -a /etc/sysconfig/docker

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker
sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
