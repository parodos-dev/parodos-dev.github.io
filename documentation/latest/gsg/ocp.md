---
layout: documentation
title: Run Parodos on OpenShift
---

# How it works:

The following diagram represents how the communication and the services that
are part of the deployment of the Parodos services on top of OpenShift.

{% mermaid %}
flowchart TB
  classDef plain fill:#ddd,stroke:#fff,stroke-width:4px,color:#000;
  classDef k8s fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;
  classDef cluster fill:#FFF,stroke:#bbb,stroke-width:2px,color:#326ce5,text-align:left;

  subgraph "Openshift"
    direction TB
    ing(Ingress) --> ouathB(OAuth Proxy)
    ouathB --> back(Backstage)

    back --> OauthP(Oauth Proxy)
    OauthP --> workflow-service

    back --> OauthN(Oauth Proxy)
    OauthN --> notification-service
  end

  User --->  ing


  class ing,ouathB,OauthP,OauthN,back,workflow-service,notification-service k8s;
  class Openshift cluster;

{% endmermaid %}

- All the authentication are based on Openshift Oauth proxy.

# Installation

## Requirements

- Openshift 4.13 or newer
- Kubectl or OC client

## Cloning parodos repo:

```
git clone {{ page.parodos.git_repo }} -b {{ page.parodos.git_branch }}
```

## Installing Parodos:

```
cd parodos
kubectl kustomize hack/manifests/openshift/ | kubecl apply -f -
```

This will install all Parodos microservices on top of Openshift, where the
deployment should looks like this:

```
$ --> oc get deployments
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
notification-service   1/1     1            1           2d23h
workflow-service       1/1     1            1           2d23h
$ --> oc get pods
NAME                                    READY   STATUS    RESTARTS   AGE
notification-service-6f5b444b8f-nclpq   2/2     Running   0          2d22h
workflow-service-764cd6f666-9dhwz       2/2     Running   0          2d23h
```
