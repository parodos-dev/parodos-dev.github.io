---
layout: documentation
title: Developer guide
---
## Spring profiles

The configuration of the `workflow-service` plays a crucial role in its
functionality and behavior. In this section, we will explore the main differences
between `dev` and `local` spring profiles and discuss their implications.

Profile `dev`:

- use a `Postgres` database.
- use a `LDAP` server.

Profile `local`:

- use a `H2` database.
- `LDAP` is disabled.

## Maven profiles

The `integration-test` Maven profile is designed to facilitate integration testing.
This profile is specifically triggered when using the `-P integration-test`
command-line option.

The `integration-test` profile is responsible for executing integration tests
and performing verification tasks using the `maven-failsafe-plugin`.

The profile includes only files that match `*IntegrationTest.java`,
`*FlowTest.java`, and `**/integration/**/*.java` patterns.

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

##### Create and set up the cluster

To execute integration test again a `Kind` cluster, you need first to create the
cluster:

`kind create cluster`

Then, you can create all the required resource executing:

```bash
make deploy-to-kind
```

Verify if all the resources has been correctly created and if they are running,
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

Retrieve and export the cluster IP address:

```bash
export SERVER_IP=$(kubectl get nodes kind-control-plane -o json  |  jq -r '[.status.addresses[] | select(.type=="InternalIP")] | .[0].address')
```

Finally, use the value of `$SERVER_IP` to configure services hosts in your
`/etc/hosts` file:

```bash
echo "$SERVER_IP workflow-service.parodos-dev" | sudo tee -a /etc/hosts
echo "$SERVER_IP notification-service.parodos-dev" | sudo tee -a /etc/hosts
```

The hostnames `workflow-service.parodos-dev` and
`notification-service.parodos-dev` are defined in [ingress.yaml](https://github.com/parodos-dev/parodos/blob/main/hack/manifests/testing/ingress.yaml).

You can execute the integration tests by running the following command:

```bash
WORKFLOW_SERVICE_HOST=workflow-service.parodos-dev \
NOTIFICATION_SERVICE_HOST=notification-service.parodos-dev \
NOTIFICATION_SERVER_PORT=8081 \
SERVER_PORT=80 \
mvn verify -pl integration-tests -P integration-test -Dspring.profiles.active=dev
```

Please note that `WORKFLOW_SERVICE_HOST` and `NOTIFICATION_SERVICE_HOST` are
the `Ingress` hosts defined in your `/etc/hosts` and in [ingress.yaml](https://github.com/parodos-dev/parodos/blob/main/hack/manifests/testing/ingress.yaml).
They ensure that the integration tests communicate with the correct services.

By combining the `integration-test` Maven profile with the `dev` Spring
profile, developers can effectively test the workflow service in a realistic
environment, validating its functionality and behavior in real-world scenarios.

##### Update the cluster

If you want to apply a local change to the already running cluster you can execute:

```bash
kubectl kustomize hack/manifests/testing | kubectl delete -f -
make build-images
make tag-images
make push-images-to-kind
kubectl kustomize hack/manifests/testing | kubectl apply -f -
```

##### Delete and recreate the cluster

If you want to have a clean cluster, you can delete completely it by executing:

```bash
kind delete cluster
```

and then recreate the cluster from scratch as described [here](#create-and-set-up-the-cluster).

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

#### How to test a workflow that is delivered by workflow-example projects

The workflow-example module contains pre-built workflow examples to simplify
the development of new workflows.

To create a new workflow example, navigate to the
`workflow-example/src/main/java/com/redhat/parodos/examples` directory and
create a new folder named `newexample`.
To define a workflow, you need to define the tasks (in the example
`LoggingWorkFlowTask`, `RestAPIWorkFlowTask`) and the workflow configuration
(`NewExampleFlowConfiguration`).

```bash
src/main/java/com/redhat/parodos/examples/newexample
├── NewExampleFlowConfiguration.java
└── task
    ├── LoggingWorkFlowTask.java
    └── RestAPIWorkFlowTask.java
```

You will need to specify the tasks (such as `LoggingWorkFlowTask` and
`RestAPIWorkFlowTask`) along with the workflow configuration
(`NewExampleFlowConfiguration`). The workflow configuration determines how the
tasks are executed.

Once you have defined a workflow within the workflow-examples package, you can
proceed to test it using integration tests.

To create a new integration tests, go to the
`integration-tests/src/test/java/com/redhat/parodos/flows` directory and create
a new file there. Let's call it `NewExampleFlowTest`. The folder structure
should look like this:

```bash
integration-tests/src/test/java/com/redhat/parodos/flows
├── common
│   └── WorkFlowTestBuilder.java
└── NewExampleFlowTest.java
```

Once your new example is ready, execute `mvn install`.
If you're executing the integration tests locally then you must restart the
services. Otherwise, if you're using a `Kind` cluster, you need to update the
resources already deployed (see [Update the cluster](#update-the-cluster) section).

The `WorkFlowTestBuilder` class is a utility class for building test scenarios
in the context of workflow definitions. It provides methods to set up projects
and retrieve workflow definitions. Through methods such as `withDefaultProject()`
and `withWorkFlowDefinition()`, users can easily define test parameters and
customize test cases. The class ensures the availability of the required
resources by employing error handling and assertion checks. Additionally,
it offers a nested `TestComponents` record that encapsulates the essential
components, simplifying access to the API client and project response.
Overall, the `WorkFlowTestBuilder` class provides a streamlined and reusable
approach for workflow testing scenarios, empowering developers to write more
concise, maintainable, and efficient test cases. This, in turn, enhances the
quality and reliability of their applications while improving efficiency and
maintainability.

In the provided code snippet, you can see an example of `NewExampleFlowTest`.

```java
import com.redhat.parodos.flows.common.WorkFlowTestBuilder.TestComponents;


@Slf4j
public class NewExampleFlowTest{

    private static final String WORKFLOW_NAME = "simpleSequentialWorkFlow" + WorkFlowConstants.INFRASTRUCTURE_WORKFLOW;


    @Test
    public void runNewExampleFlow() throws ApiException, InterruptedException {
        log.info("Running new example flow");
        //Example on how to use WorkFlowTestBuilder class
        TestComponents components = new WorkFlowTestBuilder()
            .withDefaultProject()
            .withWorkFlowDefinition(WORKFLOW_NAME, getWorkFlowDefinitionResponseConsumer())
            .build();
        // Define a WorkRequest
        WorkRequestDTO work = new WorkRequestDTO();
        work.setWorkName("restCallTask");
        work.setArguments(
            Collections.singletonList(
                new ArgumentRequestDTO()
                    .key("url")
                    .value("http://localhost:8080/actuator/health")
            )
        );

        // Define WorkFlowRequest
        WorkFlowRequestDTO workFlowRequestDTO = new WorkFlowRequestDTO();
        workFlowRequestDTO.setProjectId(components.project().getId());
        workFlowRequestDTO.setWorkFlowName(WORKFLOW_NAME);
        workFlowRequestDTO.setWorks(Collections.singletonList(work));

        log.info("******** Running The Simple Sequence Flow ********");
        WorkflowApi workflowApi = new WorkflowApi(components.apiClient());
        WorkFlowResponseDTO workFlowResponseDTO = workflowApi.execute(workFlowRequestDTO);

        // Add your logic test here
    }
}
```

`Parodos` also offers two utility classes called `WorkFlowServiceUtils` and
`NotificationServiceUtils` that simplify interaction with the `workflow-service`
and `notification-service`, respectively.
These utility classes are useful especially when writing integration tests.
For instance, you can use the `WorkFlowServiceUtils.waitWorkflowStatusAsync` method
to asynchronously wait for a workflow to reach a specific status.

Feel free to add your own logic tests within the `runNewExampleFlow` method.

#### Troubleshooting

##### 404 Not found - nginx

If you encounter a `404 Not Found` error while executing the
[mvn verify](#execute-integration-test-against-kind-cluster) command:

```bash
[OkHttp http://172.19.0.2/...] INFO com.redhat.parodos.sdkutils.WorkFlowServiceUtils - onFailure Message: Not Found
HTTP response code: 404
HTTP response body: <html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

To troubleshoot this issue, you should verify the availability of the
`parodos-notification-ingress` and `parodos-workflow-ingress` in your cluster.
You can use the command `kubectl get ingress` to check if the ingresses
are present.

```bash
> kubectl get ingress
NAME                           CLASS    HOSTS                              ADDRESS     PORTS   AGE
parodos-notification-ingress   <none>   notification-service.parodos-dev               80      5s
parodos-workflow-ingress       <none>   workflow-service.parodos-dev                   80      5s
```

If the ingress is missing, you can manually apply it using the command:

```bash
kubectl apply -f hack/manifests/testing/ingress.yaml
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

You can set the server IP and port by using specific environment variables.
For the `workflow-service`, you can set `SERVER_IP` and `SERVER_PORT`, and for
the `notification-service`, you can set `NOTIFICATION_SERVER_ADDRESS` and
`NOTIFICATION_SERVER_PORT`. The default values for the IP addresses are
`localhost`, and the default port is `8080`. If you want to customize the
values, run the following command, replacing `1.2.3.4` with the desired server
IP and `9999` with the desired port for the `workflow-service` and `5555` with
the desired port for the `notification-service`:

```bash
SERVER_IP=1.2.3.4 SERVER_PORT=9999 NOTIFICATION_SERVER_PORT=5555 mvn verify -pl integration-tests -P integration-test
```

## CI Jobs

Coverage and E2E tests running on each PR, are defined in
`.github/workflows/test.yaml`. Available jobs are:

- build
- coverage
- containers
- integration
