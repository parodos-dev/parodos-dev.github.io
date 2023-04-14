---
layout: documentation
title: Developer guide
---


# Operator


## CI Jobs

- *Kind*: E2E test running on each PR, can be found on
  `.github/workflows/kind.yaml`
- *Go/build*: Builds current code and checks that unit-test are working
- *Go/Lint*: Check that code is correctly linted
- *Go/YamlLint*: Checks that Yaml files are correctly linted
- *Go/SecurityScanner*: Checks that the current code is statically checked by
  [gosec](https://github.com/securego/gosec)
- *Go/Test Coverage*: Reports the unit test code coverage, fails if went down.

## Logging

Log configuration can be found [here](../operations/configuration.md)

[logr](https://github.com/go-logr/logr) is a logging API for Go. It provides a simple interface for logging under which there is an actual logger that implements the `logr` interface.

[Zap](https://github.com/uber-go/zap) is a log library that implements `logr` interface.

[SDK-generated operators](https://sdk.operatorframework.io/docs/building-operators/golang/references/logging/) use the logr interface to log. Operator SDK by default uses a [zap-based logger](https://pkg.go.dev/sigs.k8s.io/controller-runtime#section-readme) that is ready for production use. The default verbosity is set to `info` level.

_logr_ defines logger's verbosity levels numerically. To write log lines that are more verbose, `logr.Logger` has a [V()](https://pkg.go.dev/github.com/go-logr/logr#hdr-Verbosity) method. The higher the V-level of a log line, the less critical it is considered.
Level `V(0)` is the default, and `logger.V(0).Info()` has the same meaning as `logger.Info()`.

Levels in _logr_ correspond to [custom debug levels](https://pkg.go.dev/go.uber.org/zap/zapcore#Level) in _Zap_. Any given level in logr is represented by its inverse in zap (zapLevel = -1*logrLevel).
Thus, in _Zap_, higher levels are more important.

For example: _logr_ V(2) is equivalent to log level -2 in Zap, while _logr_ V(1) is equivalent to debug level -1 in _Zap_.

**To summarize:**

|Zap logging priority  | Zap enum     | logr                              |
|---------------------:| ------------ | --------------------------------- |
| -1                   | debug        | `.V(1).Info(...)`                 |
|  0                   | info         | `.V(0).Info(...)` or `.Info(...)` |
|  1                   | warn         | N.A.                              |
|  2                   | error        | `.Error(...)`                     |
|  3                   | dpanic       | N.A.                              |
|  4                   | panic        | N.A.                              |
|  5                   | fatal        | N.A.                              |

## E2E tests

### Prerequisites

 - k8s cluster or Openshift Cluster
 - Make sure that your `oc` or `kubectl` is configured properly to communicate with your cluster
 - Not needed for all test, OpenShift Cluster Storage or at least NooBaa.

### Running the tests

1.  Create container image of flotta operator.

```bash
# Build the flotta operator
$ make build

# Make sure you have configured k8s provider docker
# For example for minikube by running: eval $(minikube -p minikube docker-env)
# Then run the build of the container
$ IMG=flotta-operator:latest HTTP_IMG=flotta-edge-api:latest make docker-build

# Deploy the operator on k8s
$ IMG=flotta-operator:latest HTTP_IMG=flotta-edge-api:latest make deploy

# Wait until the operator is ready
$ kubectl wait --timeout=120s --for=condition=Ready pods -l app=flotta-controller-manager -n flotta
```

2.  Expose the flotta API

```bash
$ kubectl port-forward deploy/flotta-edge-api -n flotta --address 0.0.0.0 8043:8043 &
```

3.  Run the tests

```bash
$ make integration-test
```

### Troubleshooting

**kubectl wait timeouts:**

If timeout, debug the deployment logs by running:

```shell 
kubectl logs deploy/flotta-controller-manager -n flotta
```

**Waiting for edge device timeouts in integration tests**:

Debug the edge device container by executing shell inside the container:

```shell
docker exec -it edgedevice1 journalctl -u yggdrasild.service
```

**Error: "No such image: quay.io/project-flotta/edgedevice:latest"**

This error happens when KinD does not have the image stored in the control plane. To solve it, use

```shell
docker pull quay.io/project-flotta/edgedevice:latest
kind load docker-image quay.io/project-flotta/edgedevice:latest
```

command to upload the missing image.

**How can I see the running containers in the device?**

To list the podman managed pods running in a device, run this command in the target device:

```shell
docker exec -it edgedevice1 machinectl shell -q flotta@.host /usr/bin/podman pod ps
```

or

```shell
machinectl shell -q flotta@.host /usr/bin/podman pod ps
```

if you're running it inside the container.

**How can I see the logs produced by the flotta user in the device?**

When running podman in rootless mode, the logs from the agent and podman are captured for the flotta user running in the device. Run the following command to see the journalctl logs:

```shell
machinectl shell -q flotta@.host /usr/bin/journalctl --user
```

# Device Worker

## CI jobs
- *Go/build*: Builds current code and checks that unittest are working
- *Go/Lint*: Checks that code is correctly linted
- *Go/SecurityScanner*: Checks that the current code is statically checked by
  [gosec](https://github.com/securego/gosec)

# Developer CLI

### Prerequisites
- Install the flotta operator as mentioned [here](https://project-flotta.io/documentation/latest/dev/installation.html).
- Clone the flotta-dev-cli repository and build the project:

```shell
$ git clone https://github.com/project-flotta/flotta-dev-cli.git
$ cd flotta-dev-cli
$ make build
```

### Running the CLI
- Use the developer CLI to easily create edge devices and deploy predefine workloads on them:

```shell
$ ./bin/flotta add device -n device1
device 'device1' was added
$ ./bin/flotta add workload -d device1
workload 'nginx1-21-6-rrxkqkiz' was added to device 'device1'
```

- For more information, please refer to the flotta-dev-cli [guide](https://project-flotta.io/flotta/2022/07/20/developer-cli.html).
