---
layout: documentation
title: Run flotta on OpenShift
---

Flotta can run on top of any Kubernetes distributions, also, main usage in
production is on top of OpenShift cluster. 

To install OpenShift, the best way is to follow [OpenShift Assisted
installer](https://cloud.redhat.com/blog/how-to-use-the-openshift-assisted-installer).

Check OpenShift cluster status first:

```shell
$ -> oc status
In project default on server https://api.mycluster.redhat.com:6443

svc/openshift - kubernetes.default.svc.cluster.local
svc/kubernetes - 10.128.0.1:443 -> 6443

View details with 'oc describe <resource>/<name>' or list resources with 'oc get all'.
```

Flotta operator has a few tools that helps to install flotta, for that, let's
clone it:

```shell
git clone https://github.com/project-flotta/flotta-operator -b main --depth 1
cd flotta-operator
```

Now let's install Flotta on the cluster:

```shell
make deploy IMG=quay.io/project-flotta/flotta-operator:latest HTTP_IMG=quay.io/project-flotta/flotta-edge-api:latest TARGET=ocp
```

A bunch of CRDs are now created, where the definitions can be found
[here](../operations/crd.md):

```shell
$ -> oc  api-resources --api-group="management.project-flotta.io"
NAME                      SHORTNAMES   APIVERSION                              NAMESPACED   KIND
edgeconfigs                            management.project-flotta.io/v1alpha1   true         EdgeConfig
edgedevices                            management.project-flotta.io/v1alpha1   true         EdgeDevice
edgedevicesets                         management.project-flotta.io/v1alpha1   true         EdgeDeviceSet
edgedevicesignedrequest   edsr         management.project-flotta.io/v1alpha1   true         EdgeDeviceSignedRequest
edgeworkloads                          management.project-flotta.io/v1alpha1   true         EdgeWorkload
playbookexecutions                     management.project-flotta.io/v1alpha1   true         PlaybookExecution
```

At the same time, in the flotta namespace an operator and api should be running:
```
$ -> oc get pods -n flotta
NAME                                        READY     STATUS    RESTARTS   AGE
flotta-controller-manager-7f95c79f9-qfdl7   2/2       Running   0          4m28s
flotta-edge-api-6478847b4b-rjkjv            2/2       Running   0          77s
$ ->
```

Flotta is now running and ready to register edgedevices. To register a
edgedevice we need first to retrieve the install scripts using the Makefile
target `agent-install-scripts`.

```
make agent-install-scripts
```

Now, two scripts are created:
  - `hack/install-agent-dnf.sh`: To install on normal Fedora installations
  - `hack/install-agent-rpm-ostree.sh`: To install on rpm-ostree devices.

On the device, with Fedora already installed, we need to execute the following:
```
$ sudo hack/install-agent-dnf.sh -i  192.168.128.101
```

Where 192.168.128.101 is your OpenShift Ingress IP.

After a while, if you list the devices in your cluster, you can see that the
edgedevice is already registered:

```
$ -> kubectl get edgedevices
NAME        AGE
camera-ny   118s
```

From here, you should be able to deploy workloads to these devices. As explained
[here](./running_workloads.md)
