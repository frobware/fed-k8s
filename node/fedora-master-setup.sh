#!/bin/bash

# A lot of this is to enable cluster-loader.py

sudo dnf install -y			\
    openssh-server				\
    NetworkManager				\
    httpd-tools					\
    java-1.8.0-openjdk-headless			\
    nfs-utils					\
    direnv					\
    git						\
    python-boto3				\
    python-yaml					\
    python-rbd					\
    python-flask				\
    bash-completion				\
    bind-utils

cat <<'EOF' >> $HOME/.bashrc
type -p direnv &>/dev/null && eval "$(direnv hook bash)"
type -p oc &>/dev/null && source <(oc completion bash)
type -p kubectl &>/dev/null && source <(kubectl completion bash)
export PATH=/data/src/github.com/openshift/origin/_output/local/bin/linux/amd64:$PATH
EOF
