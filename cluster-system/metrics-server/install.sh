#!/bin/bash
echo ">>>>> Installing Metrics-server"
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/ --force-update
helm upgrade metrics-server metrics-server/metrics-server -n cluster-system --wait --wait-for-jobs -i
echo "<<<<< Metrics-server ready."
