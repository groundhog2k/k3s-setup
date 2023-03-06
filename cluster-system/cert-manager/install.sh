#!/bin/bash
echo ">>>>> Installing Jetstack cert-manager"
helm repo add jetstack https://charts.jetstack.io --force-update
if [ ! -f certs/tls.crt ] || [ ! -f certs/tls.key ]; then
  echo "Generating new self-signed root certificate"
  openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
    -subj "/C=DE/ST=Berlin/L=Berlin/CN=LocalDeveloperRootCA" \
    -keyout certs/tls.key -out certs/tls.crt
fi
kubectl apply -k certs -n cluster-system
helm upgrade cert-manager jetstack/cert-manager -n cluster-system -f cert-manager-values.yaml --wait --wait-for-jobs -i
kubectl apply -f local-issuer.yaml -n cluster-system
echo "<<<<< Jetstack cert-manager ready."
