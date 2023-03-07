#!/bin/bash
echo ">>>>> Bootstrapping K3s"
## Copy crictl configuration - K3s uses crictl (containerd) for container management
sudo cp crictl.yaml /etc
## 1. Setup K3s without additional controllers (we will do it all by ourselves)
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --disable traefik,metrics-server --disable-helm-controller --write-kubeconfig-mode 644 sh" sh -
## 2. Switch to k3s kubeconfig context
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube && chmod 600 ~/.kube/k3s.yaml && export KUBECONFIG=~/.kube/k3s.yaml
echo  "<<<<< K3s ready."
