#!/bin/bash
echo ">>>>> Installing Ingress-nginx"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx/ --force-update
helm upgrade ingress-nginx ingress-nginx/ingress-nginx -n cluster-system -f ingress-nginx-values.yaml --wait --wait-for-jobs -i
echo "<<<<< Ingress-nginx ready."