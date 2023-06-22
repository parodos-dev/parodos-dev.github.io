---
layout: documentation
title: Prebuilt WorkFlow tasks
---

Tasks such as REST requests and Kubernetes operations are common to
many workflows and applications.
We provide a collection of ready to use workflow tasks. A.k.a prebuilt tasks.
Example for usage can be found in the
[Parodos examples module](https://github.com/parodos-dev/parodos/tree/f2bb45ff0813b31dc76a8b80176efb567952c1eb/workflow-examples/src/test/java/com/redhat/parodos/examples).

## Create Azure VM - AzureCreateVirtualMachineTask

A task for creating a VM in Azure. It allows specifying a username and SSH key
for accessing the VM. The VM is created with UBUNTU image.
An example is available
[here](https://github.com/parodos-dev/parodos/tree/f13756c822d481c13f791c473097efc695fdbbd6/workflow-examples/src/main/java/com/redhat/parodos/examples/azure)

## Deploy OpenShift application - DeployApplicationTask

A task for applying manifests to an OpenShift cluster.
User provides a folder with manifests (YAML files) and the task applies them
one by one. The user supplies a kubeconfig string for authentication and
connection details.

## Git tasks

We have a collection of Git operation tasks:

- GitPushTask
- GitArchiveTask
- GitCloneTask
- GitCommitTask
- GitPushTask

User can, optionally, provide Git credentials.

## JDBC CRUD operation - JdbcWorkFlowTask

The task uses JDBC for interacting with a database.
The operations that the task executes are divided into three types.
The type depends on the command/statement that user provides.

- query. E.g. SQL select
- update. E.g. SQL delete, insert, update
- execute. E.g. SQL drop table, create table

The user provides the JDBC connection URL. In the URL various
parameters can be included.
Username, password, TLS etc. Each JDBC driver has its own specific parameters.

## Jira issue operation - JiraTask

You can create, update or retrieve a Jira issue.
Only basic fields are supported. E.g. description and comments.
In order to connect to the Jira server you will need to supply the
URL and a bearer token.

## Kubeapi CRUD operation - KubeapiWorkFlowTask

User can create, delete, update and retrieve a Kubernetes resource.
The user supplies a kubeconfig string for authentication and connection details.
The resource is provided and retrieved in JSON format.
You can find an [example](#kubeapi-example-for-tekton-resources)
for Tekton resources at the end.

## MTA tasks (Migration Toolkit for Applications)

Here's a list of available tasks:

- Create/Get application
- Submit/Get analysis

User connects and authenticates with a server URL and bearer token.

## Notification service message - NotificationWorkFlowTask

A task for sending a notification message to the notification service.

## REST operations - RestWorkFlowTask

A general purpose task for CRUD REST operations.
User has control over the HTTP method and content of the request.
For authentication, we support basic HTTP username and password authentication.
In order to use TLS simply use the `https://` scheme in the URL.
The HTTP client in the implementation uses the OS's configured CAs.

## Kubeapi example for Tekton resources

Let's look at a simple example.
A pipeline with two tasks. Each one outputs a different line. We also need a PipelineRun.
We will create the pipeline, the tasks and the PipelineRun.
These are the JSON representations of the Kubernetes resources:

```json
{
  "apiVersion": "tekton.dev/v1",
  "kind": "Task",
  "metadata": {
    "name": "task-1",
    "namespace": "tekton-example"
  },
  "spec": {
    "steps": [
      {
        "image": "busybox",
        "name": "echo",
        "script": "#!/bin/sh\\necho \\\"Hi I am task #1\\\""
      }
    ]
  }
}

{
  "apiVersion": "tekton.dev/v1",
  "kind": "Task",
  "metadata": {
    "name": "task-2",
    "namespace": "tekton-example"
  },
  "spec": {
    "steps": [
      {
        "image": "busybox",
        "name": "echo",
        "script": "#!/bin/sh\\necho \\\"Hi I am task #2\\\""
      }
    ]
  }
}

{
  "apiVersion": "tekton.dev/v1",
  "kind": "Pipeline",
  "metadata": {
    "name": "pipeline-1",
    "namespace": "tekton-example"
  },
  "spec": {
    "tasks": [
      {
        "name": "task-1",
        "taskRef": {
          "kind": "Task",
          "name": "task-1"
        }
      },
      {
        "name": "task-2",
        "runAfter": [
          "task-1"
        ],
        "taskRef": {
          "kind": "Task",
          "name": "task-2"
        }
      }
    ]
  }
}

{
  "apiVersion": "tekton.dev/v1",
  "kind": "PipelineRun",
  "metadata": {
    "name": "pipeline-1","namespace": "tekton-example"
  },
  "spec": {
    "pipelineRef": {
    "name": "pipeline-1"
    }
  }
}
```

You will need a separate execution (request) for each resource.
Each execution will look like this:

```json
{
  "projectId": "project-1",
  "workFlowName": "kubeapiWorkFlow",
  "works": [
    {
      "workName": "kubeapiTask",
      "arguments": [
        {
          "key": "",
          "value": ""
        }
      ]
    }
  ]
}
```

These are the arguments for each resource:

```json
[
{ "key":"kubeconfig-json", "value": "kubeconfigJson" },
{ "key":"api-group", "value": "tekton.dev" },
{ "key":"api-version", "value": "v1" },
{ "key":"kind-plural-name", "value": "tasks" },
{ "key":"operation", "value": "create" },
{ "key":"resource-json", "value": "task1Json" }
],

[
{ "key":"kubeconfig-json", "value": "kubeconfigJson" },
{ "key":"api-group", "value": "tekton.dev" },
{ "key":"api-version", "value": "v1" },
{ "key":"kind-plural-name", "value": "tasks" },
{ "key":"operation", "value": "create" },
{ "key":"resource-json", "value": "task2Json" }
],

[
{ "key":"kubeconfig-json", "value": "kubeconfigJson" },
{ "key":"api-group", "value": "tekton.dev" },
{ "key":"api-version", "value": "v1" },
{ "key":"kind-plural-name", "value": "pipelines" },
{ "key":"operation", "value": "create" },
{ "key":"resource-json", "value": "pipelineJson" }
],

[
{ "key":"kubeconfig-json", "value": "kubeconfigJson" },
{ "key":"api-group", "value": "tekton.dev" },
{ "key":"api-version", "value": "v1" },
{ "key":"kind-plural-name", "value": "pipelineruns" },
{ "key":"operation", "value": "create" },
{ "key":"resource-json", "value": "pipelineRunJson" }
]
```
