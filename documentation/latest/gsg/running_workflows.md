---
layout: documentation
title: Run workloads
---

Now that the devices are running, we need to run some container workloads on
them. The first thing to do is to make sure that devices are online:

```shell
---> kubectl get edgedevices
NAME        AGE
camera-ny   33m
--->
```

To run a workload, we need to create a EdgeWorkload config, that looks like
this:

```yaml
apiVersion: management.project-flotta.io/v1alpha1
kind: EdgeWorkload
metadata:
  name: workload
spec:
  deviceSelector:
    matchLabels:
      app: camera
  type: pod
  pod:
    spec:
      containers:
        - name: workload
          image: quay.io/project-flotta/nginx:1.21.6
```


This workload will look for devices that has the label `app=camera`, so we need
to tag our device (camera-ny) with the application tag:

```shell
kubectl label edgedevice camera-ny app=camera
```

The result of the edgedevice will be like this:

```shell
---> kubectl get edgedevice camera-ny -o json | jq .metadata.labels
{
  "app": "camera",
  "device.cpu-architecture": "x86_64",
  "device.cpu-model": "intelrcoretmi7-8650ucpu1.90ghz",
  "device.hostname": "localhost.localdomain",
  "device.system-manufacturer": "lenovo",
  "device.system-product": "20l8s2n80p",
  "device.system-serial": "pc14lwfg"
}
--->
```


After that, we need to apply our workload:

```shell
---> kubectl apply -f /tmp/deploy.yaml
edgeworkload.management.project-flotta.io/workload created
```

When the device get the next hearbeat, it'll retrieve the config, and from there
will deploy it. Edge administratior can review workload status in the device
status:


```shell
---> kubectl get edgedevice camera-ny -o json | jq .status.workloads
[
  {
    "lastTransitionTime": "2022-05-04T15:32:07Z",
    "name": "workload",
    "phase": "Running"
  }
]
```
