#!/bin/bash
# Bootstrap a K3s based Kubernetes setup with metrics, ingress, cert-manager and K8s dashboard
## 1. Bootstrap K3s
cd k3s
./prepare-k3s.sh

## 2. Prepare cluster services
cd ../cluster-system
./cluster-setup.sh

## 3. Prepare Nginx as local reverse proxy between localhost and WSL - Windows+WSL only
if grep -qi microsoft /proc/version; then
  echo "WSL detected - Installing nginx as reverse proxy"
  cd ../nginx
  ./prepare-nginx.sh
  cd ..
else
  echo "Native Linux - No need to install nginx"
fi
echo "*** Finished! Enjoy your local K8s environment. ***"
