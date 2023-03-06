#!/bin/bash
export KUBECONFIG=~/.kube/k3s.yaml
## 1. Create internal namespace
kubectl apply -f namespace.yaml

## 2. Install metrics-server
cd metrics-server
./install.sh

## 3. Install jetstack cert-manager, local rootca and cert issuer
cd ../cert-manager
./install.sh

## 4. Install ingress-nginx
cd ../ingress-nginx
./install.sh

## 5. Install kubernetes dashboard
cd ../k8s-dashboard
./install.sh
