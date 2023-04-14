---
layout: documentation
---

This document describes how to troubleshoot Flotta in different deployment
modes. It focuses on a full deployment; If you are  looking for a simple way to
experiment, we highly recommend trying out the Getting Started Guides instead.

This guide assumes that you have some knowledge of all components and concepts.

## Flotta operator & API Server

### Edgedevices are not created when device is on.

This maybe is because
[AUTO_APPROVAL_PROCESS](deployment_options.md#auto_approval_process) is set to
false. When this parameter is enabled on the operator, devices can only enrol,
but a human needs to approve the device to land to a specific namespace, labels
or deviceSet.

### Devices are getting 401 responses

This can be normal, mainly because some heartbeat process is executed before the
system enrols into the cluster. To validate that your certificates are correct,
you need to check the certs used, mainly using the following `openssl` command:

```shell
$ openssl x509 -noout -in /etc/pki/consumer/cert.pem --subject
```

where subject CN should be the DEVICE_ID value.

Those 401 is possible that are heartbeats that are not yet using the right
certificate. On the operator logs, should be easy to find why the certificates
are failing if it's not in there.

### Flotta API is not getting any traffic

By default Flotta uses openshift-router, and uses an internal service, so
checking that both service and Ingress route is correct is the way to go.

The best way to check the route is with the following command:

```shell
$ kubectl get route -n flotta flotta-edge-api -o json | jq ".status"
{
  "ingress": [
    {
      "conditions": [
        {
          "lastTransitionTime": "2022-05-06T10:46:36Z",
          "status": "True",
          "type": "Admitted"
        }
      ],
      "host": "project-flotta.io",
      "routerName": "public",
      "wildcardPolicy": "None"
    }
  ]
}
```

And for the service, check that the pod is running as expected:

```shell
$ -> kubectl get pod -n flotta -l app=flotta-edge-api
NAME                                                  READY   STATUS             RESTARTS   AGE
flotta-edge-api-8649fbb9dc-bt4r9                      1/2     ImagePullBackOff   0          27m
```

As in this example, flotta edge api pod is not ready, and communication is not working as
expected.

## Device operations troubleshooting

All those guides expect that you have access to the edgedevice terminal, so all
the checks are at the device level.

### The device is failing on TLS handshakes

This can be that the initial certificates are not valid, or CA certificate is
not included in the yggdrasil config. For that, you need to make sure that the
following  entries are added into `/etc/yggdrasil/config.toml`

```toml
key-file = "/etc/pki/consumer/key.pem"
cert-file = "/etc/pki/consumer/cert.pem"
ca-root = ["/etc/pki/consumer/ca.pem"]
```

And for the register certificate, a client certificate that can only do register
action, so the CN for the certificate is "register", subject should be similar
to this:

```shell
$ -> openssl x509 -noout -in /tmp/cert.pem --subject
subject=O = flotta-operator, CN = register, serialNumber = reg-client-ca-p5rp4gwkqt
```

### Device is not deploying a workload

When a device gets a workload, it reports the workload status, so a user can see
what happens with the workloads.

```shell
$ kubectl get -n ny edgedevice camera-ny -o json | jq '.status.workloads'
[
  {
    "lastTransitionTime": "2022-05-06T13:19:24Z",
    "name": "x86-logs",
    "phase": "Running"
  },
  {
    "lastTransitionTime": "2022-05-06T13:19:24Z",
    "name": "camera-rec",
    "phase": "Running"
  }
]
```

Each workload has the folowing config in the device:

- `/etc/yggdrasil/device/workloads/$WORKLOADNAME/workload.yaml`:  The file that
  contains podman workload definition, and is  what uses device agent when it
  has difficulties reaching the API server.
- Systemd entry to manage the workload and keep it updated, `ls
  /etc/systemd/system/pod-*`

To gather information of non-running workload you can review the following:

- Yggdrasil device-worker logs:
```shell
journalctl -u yggdrasild
```
- Last config retrieved by the device-agent and applied:
```shell
cat /etc/yggdrasil/device/device-config.json
```
- The output of [podman pod](https://docs.podman.io/en/v4.0.0/markdown/podman-pod.1.html)
```shell
# podman  pod ps
POD ID        NAME        STATUS      CREATED         INFRA ID      # OF CONTAINERS
163da209abd8  camera-rec  Running     26 minutes ago  4fc3c7133c6d  2
58ce7642217b  x86-logs    Running     26 minutes ago  65e7c9dc9f77  2
```
