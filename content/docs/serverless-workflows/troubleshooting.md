---
title: Troubleshooting
date: "2024-07-25"
weight: 101
---


# Troubleshooting Guide

This document provides solutions to common problems encountered with serverless workflows.

## Table of Contents

1. [Workflow Errors](#workflow-errors)
2. [Configuration Problems](#configuration-problems)
3. [Performance Issues](#performance-issues)
4. [Error Messages](#error-messages)
5. [Network Problems](#network-problems)
6. [Common Scenarios](#common-scenarios)
7. [Contact Support](#contact-support)

---

## Workflow Errors

### Problem: Workflow execution fails

**Solution:**

1. Examine the container log of the workflow
    ```console
        oc logs my-workflow-xy73lj
    ```

### Problem: Workflow is not listed by the orchestrator plugin

**Solution:**

1. Examine the container status and logs
    ```console
        oc get pods my-workflow-xy73lj
        oc logs my-workflow-xy73lj
    ```

2. Most probably the Data index service was unready when the workflow started.
   Typically this is what the log shows:
    ```console
        2024-07-24 21:10:20,837 ERROR [org.kie.kog.eve.pro.ReactiveMessagingEventPublisher] (main) Error while creating event to topic kogito-processdefinitions-events for event ProcessDefinitionDataEvent {specVersion=1.0, id='586e5273-33b9-4e90-8df6-76b972575b57', source=http://mtaanalysis.default/MTAAnalysis, type='ProcessDefinitionEvent', time=2024-07-24T21:10:20.658694165Z, subject='null', dataContentType='application/json', dataSchema=null, data=org.kie.kogito.event.process.ProcessDefinitionEventBody@7de147e9, kogitoProcessInstanceId='null', kogitoRootProcessInstanceId='null', kogitoProcessId='MTAAnalysis', kogitoRootProcessId='null', kogitoAddons='null', kogitoIdentity='null', extensionAttributes={kogitoprocid=MTAAnalysis}}: java.util.concurrent.CompletionException: io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: sonataflow-platform-data-index-service.default/10.96.15.153:80
    ```

3. Check if you use a cluster-wide platform:
    ```console
       $ oc get sonataflowclusterplatforms.sonataflow.org
       cluster-platform
    ```
    If you have, like in the example output, then use the namespace `sonataflow-infra` when you look for the sonataflow services

    Make sure the Data Index is ready, and restart the workflow - notice the `sonataflow-infra` namespace usage:
    ```console
        $ oc get pods -l sonataflow.org/service=sonataflow-platform-data-index-service -n sonataflow-infra
        NAME                                                      READY   STATUS    RESTARTS   AGE
        sonataflow-platform-data-index-service-546f59f89f-b7548   1/1     Running   0          11kh
        
        $ oc rollout restart deployment my-workflow
    ```

### Problem: Workflow is failing to reach an HTTPS endpoint because it can't verify it

- REST actions performed by the workflow can fail the SSL certificate check if the target endpoint is signed with 
a CA which is not available to the workflow. The error in the workflow pod log usually looks like this:

    ```console
        sun.security.provider.certpath.SunCertPathBuilderException - unable to find valid certification path to requested target
    ```

**Solution:**

1. If this happens then we need to load the additional CA cert into the running
   workflow container. To do so, please follow this guile from the SonataFlow guides site:
   https://sonataflow.org/serverlessworkflow/main/cloud/operator/add-custom-ca-to-a-workflow-pod.html


## Configuration Problems
TBD
## Performance Issues
TBD
## Error Messages
TBD
## Network Problems
TBD
## Common Scenarios


