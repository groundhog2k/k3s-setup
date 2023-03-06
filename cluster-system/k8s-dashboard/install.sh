#!/bin/bash
echo ">>>>> Installing Kubernetes dashboard"
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/ --force-update
helm upgrade k8s-dashboard kubernetes-dashboard/kubernetes-dashboard -n cluster-system -f k8s-dashboard-values.yaml --wait --wait-for-jobs -i
### Fix permissions for kubernetes-dashboard user to have full access
sleep 5
kubectl delete clusterrolebinding kubernetes-dashboard -n cluster-system --ignore-not-found=true
kubectl create clusterrolebinding kubernetes-dashboard -n cluster-system --clusterrole=cluster-admin --serviceaccount=cluster-system:kubernetes-dashboard
if grep -q k8sdash /etc/hosts; then
  echo "k8sdash already in hosts file"
else
  echo "Adding k8sdash to hosts file"
  echo "127.0.0.1 k8sdash" | sudo tee -a /etc/hosts
fi
echo "<<<<< Kubernetes dashboard ready."
