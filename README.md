# Kubernetes and Origin playground

Some primitive scripts and notes for standing up VMs for both
kubernetes and Origin development.

If these happen to work for *you* OOTB I would be surprised.

# Docker

```
echo "INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'" | sudo tee -a /etc/sysconfig/docker
```
