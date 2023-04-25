---
layout: documentation
title: Run Parodos on Kind
---


## How it works

The following diagram represents how the communication and the services that
are part of the deployment of the Parodos services on top of Kind.

{% mermaid %}
flowchart TB

  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#fff,stroke:#bbb,stroke-width:2px,color:#326ce5;

  subgraph kind
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

### Create kind cluster

    ```
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

### Cloning parodos repo

For installation, at the moment, only kustomize deployments are supported.

    ```
    git clone {{ page.parodos.git_repo }} -b {{ page.parodos.git_branch }}
    ```

### Installing Parodos and Backstage

    ```
    kubectl kustomize hack/manifests/backstage | kubectl apply -f -
    ```

This will install all deployments for Parodos services and Backstage with
Parodos plugin. For AuthN a fake Openldap server and a mock database will be
used.

The following deployments are for Parodos services:

    ```
    $ --> kubectl get deployments
    NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
    ldap-deployment        1/1     1            1           31d
    notification-service   1/1     1            1           31d
    postgres-deployment    1/1     1            1           31d
    workflow-service       1/1     1            1           31d
    ```

And the following deployments for Backstage

    ```
    $ --> kubectl get deployment -n backstage
    NAME        READY   UP-TO-DATE   AVAILABLE   AGE
    backstage   1/1     1            1           2m53s
    postgres    1/1     1            1           2m53s
    ```

### Backstage port-forwarding

Because there is no domain, to test without domains, we neeed to forward a few
ports to localhost, in the near future we'll figure it out a solution with
gateway-api.

    ```
    kubectl port-forward --namespace=backstage svc/backstage 7007:7007
    ```

Now, start adding workflows using `http://localhost:7007/parodos/`

## Next steps

- [Starting running Workflows](./running_workflows.md)
- [Troubleshooting guide](./../operations/troubleshooting.md)
