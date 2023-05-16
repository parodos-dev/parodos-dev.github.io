---
layout: documentation
title: Developer guide
---

## Integration tests

### Quick start

#### Execute integration tests locally

To execute integration tests locally, you need to first start the
`workflow-service` and `notification-service` services by running the following
commands:

```bash
./start_workflow_service.sh &
./start_notification_service.sh &
```

Once the services are up and running, you can execute the integration tests by
running the following command:

```bash
mvn verify -pl integration-tests -P integration-test
```

#### Execute integration test against Kind cluster

To execute integration test again a `Kind` cluster, you need first to create the
cluster:

`kind create cluster`

Then, you can create all the required resource executing:

```bash
make install-kubernetes-dependencies
sleep 10
make wait-kubernetes-dependencies
make build-images
make tag-images
make push-images-to-kind
kubectl kustomize hack/manifests/testing | kubectl apply -f -
kubectl wait --timeout=300s --for=condition=Ready pods --all -n default
```

Verify if all the resources has been correctly create and if they are running,
execute:

```bash
kubectl get pods -A
```

The output should be similar to:

```bash
 > kubectl get pods -A
NAMESPACE            NAME                                         READY   STATUS      RESTARTS       AGE
default              ldap-deployment-5bc598d86f-r7276             1/1     Running     0              3h5m
default              notification-service-b87d5f696-ddnwg         1/1     Running     0              3h5m
default              postgres-deployment-546b89d79c-pgz7n         1/1     Running     0              3h5m
default              workflow-service-64c57dd6b8-vft8f            1/1     Running     6 (3h1m ago)   3h5m
ingress-nginx        ingress-nginx-admission-create-c4dt7         0/1     Completed   0              3h5m
ingress-nginx        ingress-nginx-admission-patch-hb8xb          0/1     Completed   2              3h5m
ingress-nginx        ingress-nginx-controller-6bfb7f5798-cr7jk    1/1     Running     0              3h5m
kube-system          coredns-787d4945fb-2hbtb                     1/1     Running     0              3h5m
kube-system          coredns-787d4945fb-z8zqd                     1/1     Running     0              3h5m
kube-system          etcd-kind-control-plane                      1/1     Running     0              3h5m
kube-system          kindnet-cbxgn                                1/1     Running     0              3h5m
kube-system          kube-apiserver-kind-control-plane            1/1     Running     0              3h5m
kube-system          kube-controller-manager-kind-control-plane   1/1     Running     0              3h5m
kube-system          kube-proxy-mt9hm                             1/1     Running     0              3h5m
kube-system          kube-scheduler-kind-control-plane            1/1     Running     0              3h5m
local-path-storage   local-path-provisioner-75f5b54ffd-9kzhm      1/1     Running     0              3h5m
```

Finally, retrieve and export the cluster IP address:

```bash
export SERVER_IP=$(kubectl get nodes kind-control-plane -o json  |  jq -r '[.status.addresses[] | select(.type=="InternalIP")] | .[0].address')
```

You can execute the integration tests by running the following command:

```bash
SERVER_PORT=80 mvn verify -pl integration-tests -P integration-test -Dspring.profiles.active=dev
```

#### Execute a specific integration test

If you want to execute a specific integration test, e.g. `SimpleWorkFlowTest`,
you can set the `it.test` property equals to the integration test class name you
want to execute. For example:

```bash
SERVER_IP=172.19.0.2 SERVER_PORT=80 mvn -Dit.test=SimpleWorkFlowTest verify -pl integration-tests -P integration-test -Dspring.profiles.active=dev
```

Refer to
[maven-failsafe-plugin](https://maven.apache.org/surefire/maven-failsafe-plugin/examples/single-test.html)
documentation for additional examples.

#### Troubleshooting

##### 404 Not found - nginx
  
If you get this error:

```bash
[OkHttp http://172.19.0.2/...] INFO com.redhat.parodos.sdkutils.SdkUtils - onFailure Message: Not Found
HTTP response code: 404
HTTP response body: <html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

verify that the ingress ``parodos-ingress` is available in your cluster:

```bash
> kubectl get ingress
NAME              CLASS    HOSTS   ADDRESS   PORTS   AGE
parodos-ingress   <none>   *                 80      9s
```

## Details

_Parodos_ treats integration tests as unit tests and executes them independently
using the Maven _Failsafe_ plugin instead of the classic _Surefire_ plugin.

The Maven _Surefire_ and _Failsafe_ plugins are two widely used plugins for
executing tests during a Maven build. These two plugins differ in the build
lifecycle phase in which they operate. While the _Surefire_ plugin runs tests
during the test phase, the _Failsafe_ plugin executes tests during the
integration-test phase.

The _Failsafe_ plugin is designed to execute integration tests that require more
elaborate setup, such as tests that rely on a running application server or
database connection. Integration tests run in the same JVM instance as the
application, and the plugin includes a default naming convention for identifying
integration test classes. _Failsafe_ generates reports that provide insight into
the overall health of the application, as well as any integration issues that
may exist.

To facilitate running integration tests during the Maven build process,
_Parodos_ defines a Maven profile named `integration-test`. The command to
execute the integration tests is:

```bash
mvn verify -pl integration-tests -P integration-test
```

You can also specify the server IP and server port by setting the environment
variables `SERVERIP` and `SERVERPORT`. By default, the values are `localhost`
and `8080`, respectively. For instance, you can run the following command to
specify custom values for the server IP and port:

```bash
SERVER_IP=1.2.3.4 SERVER_PORT=9999 mvn verify -pl integration-tests -P integration-test
```

The `integration-test` profile uses fake `LDAP` server and `Postgres` database.\
The `local` profile has `LDAP` disabled and uses `h2` database.

## CI Jobs

Coverage and E2E tests running on each PR, are defined in
`.github/workflows/test.yaml`. Available jobs are:

- build
- coverage
- containers
- integration
