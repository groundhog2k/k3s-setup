# k3s-setup

## What is it good for?

This project will make it very easy to automatically setup a K3s based Kubernetes environment on your local development machine.

It supports native Linux and also a WSL2 based setup.
There is no more need to use Docker for Desktop on Windows which makes it ideal for Corporate environments.

## How to start? (TL;DR)

### Requirements

* Make sure your Linux or WSL2 environment has access to the Internet (directly or via properly configured HTTP/HTTPS proxy)
* Make sure you have `sudo` permissions

### Really..I want to start it now

```bash
git clone https://github.com/groundhog2k/k3s-setup.git
cd k3s-setup
./k3s-setup.sh
```

Install the self-signed root certificate that was generated in `./cluster-system/cert-manager/certs/tls.crt` into your local browser or computer truststore for root certificates.

When setup is finished and all services are running open https://k8sdash in your browser and enjoy Kubernetes.

**Important - For Windows only:**

Edit the hosts file (typically in [`C:\Windows\system32\drivers\etc\hosts`](C:/Windows/system32/drivers/etc/hosts)) and add a mapping line for the hostname k8sdash:

```text
127.0.0.1 k8sdash
```

To configure the correct KUBECONFIG in Linux/WSL2 do:

```bash
export KUBECONFIG=~/.kube/k3s.yaml
```

## What will it do?

### For Linux

For Linux it will simply install K3s and prepare a few more services like, metrics server, Jetstack certificate manager, Ingress nginx and Kubernetes dashboard.

### Inside WSL2

In WSL2 it will spin up K3s inside the WSL environment, deploy the same services like on the Linux environment and expose the Ingress nginx HTTPS port (443) to the host machine using Nginx as a reverse proxy.

---

## Give me more details

The script `k3s-setup.sh` builds the bracket around a few other scripts.
It will call the following sub-scripts:

1. `k3s/prepare-k3s.sh`

    K3s is using the crictl tool and containerd as runtime. `crictl` has a default [search order](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md) for container runtimes which is not optimal.
    At first it will copy the `crictl.yaml` to `/etc` to point the default search to containerd.

    In a second step it downloads and spins up K3s WITHOUT helm controller, treafik and metrics-server to create a really clean K8s environment (similar to vanilla Kubernetes).

2. `cluster-system/cluster-setup.sh`

   This sub-script creates a namespace `cluster-system`. All following custom cluster-wide components will be deployed to this namespace via helm charts.

   1. `cluster-system/metrics-server/install.sh`

      Installs the Kubernetes metrics-server from the [original helm chart](https://github.com/kubernetes-sigs/metrics-server).

   2. `cluster-system/cert-manager/install.sh`

      The script generates a self-signed root certificate (if not already existend in the [`certs`](https://github.com/groundhog2k/k3s-setup/tree/main/cluster-system/cert-manager/certs) folder) and deploys this together with the [Jetstack cert-manager](https://github.com/cert-manager/cert-manager).

   3. `cluster-system/ingress-nginx/install.sh`

      Deploys the [Ingress-nginx](https://github.com/kubernetes/ingress-nginx) service as Kubernetes Ingress Controller.

   4. `cluster-system/k8s-dashboard/install.sh`

      This scripts deploys the [Kubernetes dashboard](https://github.com/kubernetes/dashboard) management UI from the original helm chart.

      Together with the Ingress component from previous step the UI should appear for the local URI https://k8sdash

      **Important:**

      **Install the self-signed root certificate into your local browser or computer truststore for root certificates.**

3. `nginx/prepare-nginx`

   This script will only be executed when the setup was started in context of WSL2 (Windows).
   It installs an nginx in WSL2 as Linux daemon and configures it to forward all incoming TCP traffic on Port 443 to the Ingress controller endpoint.

   **Attention:**

   **Be aware that this will overwrite a possible existing `/etc/nginx.conf` in your WSL2.**
