#!/bin/bash

sudo dnf install -y				\
    direnv					\
    git						\
    bash-completion				\
    bind-utils

cat <<'EOF' >> $HOME/.bashrc
type -p direnv &>/dev/null && eval "$(direnv hook bash)"
type -p oc &>/dev/null && source <(oc completion bash)
type -p kubectl &>/dev/null && source <(kubectl completion bash)
export PATH=/data/src/github.com/openshift/origin/_output/local/bin/linux/amd64:$PATH
EOF
