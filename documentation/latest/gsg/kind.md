---
layout: documentation
title: Run Parodos on Kind or OpenShift
---


## How it works

The following diagram represents how the communication and the services that
are part of the deployment of the Parodos services on top of Kind or OpenShift.

{% mermaid %}
flowchart TB

  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;
  subgraph kind["Kind / OpenShift#nbsp;#nbsp;#nbsp;"]
    direction TB
    ing(Ingress) --> back(Backstage)

    back --> workflow(workflow-service)

    back --> notification(notification-service)
  end

  User --->  ing

  class ing,back,workflow,notification k8s;
  class kind cluster;
{% endmermaid %}

## Installation

### Requirements

- Kind 0.11 or newer
- Kubectl or OC client

### Create the cluster

#### Kind cluster

To create a Kind cluster, simply run the following command in your terminal:

```bash
$ --> kind create cluster
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.21.1) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
⢎⠁ Starting control-plane 🕹️
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Have a nice day! 👋
```

#### OpenShift cluster

To set up an OpenShift cluster, you have two options: deploying a
production-grade cluster or creating a local development cluster using
CodeReady Containers.

##### Production OpenShift Cluster

For a production-grade OpenShift cluster deployment, follow the steps
provided in the official OpenShift documentation.
The [official documentation](https://docs.openshift.com/container-platform/4.13/installing/index.html)
provides detailed instructions to guide you through the installation process,
ensuring you have a fully functional and robust OpenShift cluster.

##### Local OpenShift Cluster

If you prefer a local development environment for OpenShift, you can use
[CodeReady Containers](https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.29/html/getting_started_guide/index),
which allows you to run a single-node OpenShift cluster on your local machine.

Follow the [official documentation](https://docs.openshift.com/container-platform/4.13/installing/index.html)
to deploy an Openshift cluster or create a local OpenShift cluster via
[CodeReady Containers](https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.29/html/getting_started_guide/index)

```bash
$ --> crc setup
INFO Using bundle path /home/user/.crc/cache/crc_libvirt_4.13.3_amd64.crcbundle
INFO Checking if running as non-root
INFO Checking if running inside WSL2
INFO Checking if crc-admin-helper executable is cached
INFO Checking if running on a supported CPU architecture
INFO Checking if crc executable symlink exists
INFO Checking minimum RAM requirements
INFO Checking if Virtualization is enabled
INFO Checking if KVM is enabled
INFO Checking if libvirt is installed
INFO Checking if user is part of libvirt group
INFO Checking if active user/process is currently part of the libvirt group
INFO Checking if libvirt daemon is running
INFO Checking if a supported libvirt version is installed
INFO Checking if crc-driver-libvirt is installed
INFO Checking crc daemon systemd service
INFO Checking crc daemon systemd socket units
INFO Checking if systemd-networkd is running
INFO Checking if NetworkManager is installed
INFO Checking if NetworkManager service is running
INFO Checking if dnsmasq configurations file exist for NetworkManager
INFO Checking if the systemd-resolved service is running
INFO Checking if /etc/NetworkManager/dispatcher.d/99-crc.sh exists
INFO Checking if libvirt 'crc' network is available
INFO Checking if libvirt 'crc' network is active
INFO Checking if CRC bundle is extracted in '$HOME/.crc'
INFO Checking if /home/user/.crc/cache/crc_libvirt_4.13.3_amd64.crcbundle exists
INFO Getting bundle for the CRC executable
INFO Downloading bundle: /home/user/.crc/cache/crc_libvirt_4.13.3_amd64.crcbundle...
3.92 GiB / 3.92 GiB [----------------------------------------------------------------] 100.00% 7.13 MiB/s
INFO Uncompressing /home/user/.crc/cache/crc_libvirt_4.13.3_amd64.crcbundle
crc.qcow2:  14.24 GiB / 14.24 GiB [-------------------------------------------------------------] 100.00%
oc:  136.05 MiB / 136.05 MiB [------------------------------------------------------------------] 100.00%
Your system is correctly setup for using CRC. Use 'crc start' to start the instance

$ --> crc start
INFO Checking if running as non-root
INFO Checking if running inside WSL2
INFO Checking if crc-admin-helper executable is cached
INFO Checking if running on a supported CPU architecture
INFO Checking if crc executable symlink exists
INFO Checking minimum RAM requirements
INFO Checking if Virtualization is enabled
INFO Checking if KVM is enabled
INFO Checking if libvirt is installed
INFO Checking if user is part of libvirt group
INFO Checking if active user/process is currently part of the libvirt group
INFO Checking if libvirt daemon is running
INFO Checking if a supported libvirt version is installed
INFO Checking if crc-driver-libvirt is installed
INFO Checking crc daemon systemd socket units
INFO Checking if systemd-networkd is running
INFO Checking if NetworkManager is installed
INFO Checking if NetworkManager service is running
INFO Checking if dnsmasq configurations file exist for NetworkManager
INFO Checking if the systemd-resolved service is running
INFO Checking if /etc/NetworkManager/dispatcher.d/99-crc.sh exists
INFO Checking if libvirt 'crc' network is available
INFO Checking if libvirt 'crc' network is active
INFO Loading bundle: crc_libvirt_4.13.3_amd64...
INFO Creating CRC VM for OpenShift 4.13.3...
INFO Generating new SSH key pair...
INFO Generating new password for the kubeadmin user
INFO Starting CRC VM for openshift 4.13.3...
INFO CRC instance is running with IP 192.168.130.11
INFO CRC VM is running
INFO Updating authorized keys...
INFO Configuring shared directories
INFO Check internal and public DNS query...
INFO Check DNS query from host...
INFO Verifying validity of the kubelet certificates...
INFO Starting kubelet service
INFO Waiting for kube-apiserver availability... [takes around 2min]
INFO Adding user's pull secret to the cluster...
INFO Updating SSH key to machine config resource...
INFO Waiting until the user's pull secret is written to the instance disk...
INFO Changing the password for the kubeadmin user
INFO Updating cluster ID...
INFO Enabling cluster monitoring operator...
INFO Updating root CA cert to admin-kubeconfig-client-ca configmap...
INFO Starting openshift instance... [waiting for the cluster to stabilize]
INFO 8 operators are progressing: dns, image-registry, ingress, kube-storage-version-migrator, network, ...
INFO 8 operators are progressing: dns, image-registry, ingress, kube-storage-version-migrator, network, ...
INFO 5 operators are progressing: image-registry, ingress, network, openshift-controller-manager, service-ca
INFO 4 operators are progressing: image-registry, network, openshift-controller-manager, service-ca
INFO 4 operators are progressing: image-registry, network, openshift-controller-manager, service-ca
INFO 4 operators are progressing: image-registry, network, openshift-controller-manager, service-ca
INFO 4 operators are progressing: image-registry, network, openshift-controller-manager, service-ca
INFO 4 operators are progressing: image-registry, network, openshift-controller-manager, service-ca
INFO 4 operators are progressing: image-registry, network, openshift-controller-manager, service-ca
INFO 3 operators are progressing: image-registry, openshift-controller-manager, service-ca
INFO 4 operators are progressing: authentication, image-registry, openshift-controller-manager, service-ca
INFO 2 operators are progressing: image-registry, openshift-controller-manager
INFO Operator monitoring is progressing
INFO Operator monitoring is progressing
INFO Operator monitoring is progressing
INFO All operators are available. Ensuring stability...
INFO Operator console is progressing
INFO All operators are available. Ensuring stability...
INFO Operators are stable (2/3)...
INFO Operators are stable (3/3)...
INFO Adding crc-admin and crc-developer contexts to kubeconfig...
Started the OpenShift cluster.

The server is accessible via web console at:
  https://console-openshift-console.apps-crc.testing

Log in as administrator:
  Username: kubeadmin
  Password: rsNxa-a5k3z-fNU5r-FgK5y

Log in as user:
  Username: developer
  Password: developer

Use the 'oc' command line interface:
  $ eval $(crc oc-env)
  $ oc login -u developer https://api.crc.testing:6443
```

After running the `crc start`` command, the OpenShift cluster will be up and running.
The next step is to proceed with the login process, which is explained in the
command output.

### Cloning parodos repo

For installation, at the moment, only kustomize deployments are supported.

```bash
git clone {{ page.parodos.git_repo }} -b {{ page.parodos.git_branch }}
```

### Installing Parodos and Backstage

```bash
kubectl kustomize hack/manifests/backstage | kubectl apply -f -
```

This will install all deployments for Parodos services and Backstage with
Parodos plugin. For AuthN a fake Openldap server will be created and a simple
non-production ready Postgres database will be used.

The following deployments are in place:

```bash
$ --> kubectl get deployment
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
backstage              1/1     1            1           42m
notification-service   1/1     1            1           42m
postgres               1/1     1            1           42m
workflow-service       1/1     1            1           42m
```

### Backstage port-forwarding

Currently, as there is no domain available, testing without domains requires
port forwarding to the localhost.
However, we are actively working on finding a more permanent solution in the
near future, possibly leveraging the `gateway-api`.

```bash
kubectl port-forward --namespace=default svc/backstage 7007:7007
```

Now, start adding workflows using `http://localhost:7007/parodos/`

## Next steps

- [Starting running Workflows](./running_workflows.md)
- [Troubleshooting guide](./../operations/troubleshooting.md)
