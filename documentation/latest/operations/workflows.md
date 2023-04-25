---
layout: documentation
title: WorkFlows Definitions
---

A workflow is defined by a Java Bean, and it registered to the database on
startup time. A Workflow needs to implement the WorkFlow interface, so it can
be used by the workflow-service, the workflow-interface can be found
[here]({{page.parodos.git_repo}}/blob/{{ page.parodos.git_branch
}}/workflow-engine/src/main/java/com/redhat/parodos/workflows/workflow/WorkFlow.java).

A workflow example can be found in the workflow-examples directory inside the
[Git  repository]({{ page.parodos.git_repo }}). An example workflow,
workflow-task can be find in the following diagram:

{% mermaid %}

flowchart TB
  direction LR

  classDef dot fill:#fff,stroke:#000,stroke-width:1px;
  classDef task fill:#326ce5,stroke:#fff,stroke-width:4px,color:#fff;

  User(Create User)
  class User task;

  subgraph "Openshift"[Openshift WorkFlow]
    Oinit(( )):::myCircleNode;

    direction LR
    addSA(Add Service Account)
    addRBACPolicies(Add Rbac for user)
    class addSA,addRBACPolicies task;
    Oinit -->addSA;
    addSA --> addRBACPolicies;
    addRBACPolicies -->Ofinish;
    Ofinish(( )):::myCircleNode;
  end

   subgraph "Vault"[Vault WorkFlow]
    Vinit(( )):::myCircleNode;

    addUser(Add User to Vault)
    addToAws(Add User to aws project)
    class addUser,addToAws task;
    Vfinish(( )):::myCircleNode;

    Vinit -->addUser;
    Vinit -->addToAws;
    addUser -->Vfinish;
    addToAws -->Vfinish;
   end

  User -->  Openshift
  User --> Vault

  checker(( )):::myCircleNode;

  Ofinish --> checker
  Vfinish --> checker
  checker --> Send(Email to user)

{% endmermaid %}

## Workflow properties

When registering a workflow, only the bean annotation is needed, but at the
moment some workflow-properties can be added. These properties are metadata
base content that may is useful for the end users to append in the workflow. To
register metadata, the following example can be used:

```java

import com.redhat.parodos.workflow.annotation.WorkFlowProperties;

....
....

public class SimpleWorkFlowConfiguration {

    @Bean(name = "simpleSequentialWorkFlow" + WorkFlowConstants.INFRASTRUCTURE_WORKFLOW)
    @WorkFlowProperties(version = "${git.commit.id}")
    WorkFlow simpleSequentialWorkFlowTask(@Qualifier("restCallTask") RestAPIWorkFlowTask restCallTask,
        return SequentialFlow
                .Builder.aNewSequentialFlow()
                .named("simpleSequentialWorkFlow" + WorkFlowConstants.INFRASTRUCTURE_WORKFLOW)
                .execute(restCallTask)
                .then(loggingTask)
                .build();
    }

```

In this case, we're using
[maven-git-plugin](https://dzone.com/articles/maven-git-commit-id-plugin) to
inject the git commit id inside the WorkFlow configuration, the properties can
be retrieved on the workflow definition API endpoint, as an example:

```bash
$ --> curl $AUTH \
    "http://localhost:8080/api/v1/workflowdefinitions/b1ef2356-37bb-45e9-99cd-1e97a13a1ac9" | \
    jq .properties -r
{
  "version": "\"a673364e13c4dfe8e1d357991ff284d2419ca41c\","
}
```

At the moment, the list of properties are the following:

| Property Nane   | Kind   | Default Value  | Comment                                   |
|-----------------|--------|----------------|-------------------------------------------|
| version         | String | ""             | A way to append a version to the workFlow |
{: .table }

## WorkflowTask Definition

### WorkTask parameters

Each WorkTask can accept parameters, these parameters is what the end user will
use to give some information to the workflow. Workflow Administrator is the one
that define in each Workflow the parameters needed.

Each parameter can be defined inside the Java Bean, and an example can be the
following one:

```java
public class LoggingWorkFlowTask extends BaseInfrastructureWorkFlowTask {
    ....
    ....
    @Override
    public WorkReport execute(WorkContext workContext) {
        ...
    }

    @Override
    public List<WorkParameter> getWorkFlowTaskParameters() {
        return List.of(
                WorkParameter.builder().key("api-server").description("The api server").type(WorkParameterType.URL)
                        .optional(false).build(),
                WorkParameter.builder()
                        .key("user-id")
                        .description("The user id")
                        .type(WorkParameterType.TEXT)
                        .optional(false)
                        .jsonSchemaOptions(Map.of("minLength", "1", "maxLength", "64"))
                        .build())
    }

}
```

So, each WorkParameter has a key name, with some description and some values.
If WorkFlow Administrator wants to add some custom validation can extend the
Parameter with the JsonSchemaOptions, that it will append the value to the
parameter at the frontend.

The list of parameters can be find
[here]({{page.parodos.git_repo}}/blob/{{page.parados.git_branch}}/parodos-model-api/src/main/java/com/redhat/parodos/workflow/parameter/WorkParameterType.java),
and the parameters are the following:

|Parameter Name | Type |  JsonSchem options |
|---------------|------|--------------------|
|PASSWORD       | text          | { "type": "string", "format": "password" } |
|TEXT           | text          | { "type": "string" } |
|EMAIL          | text          | { "type": "string", "format": "email" } |
|DATE           | text          | { "type": "string", "format": "date" } |
|NUMBER         | text          | { "type": "number" } |
|URL            | text          | { "type": "string", "format": "url" } |
|SELECT         | select        | { "type": "string", "enum": [] } |
|MULTI_SELECT   | multi-select  | { "type": "array", "items": { "type": "string", "enum": [] } } |
{: .table }

### WorkTask Outputs

## WorkFlow Checker

{% mermaid %}
flowchart LR
    classDef task fill:#2374f7,stroke:#000,stroke-width:2px,color:#fff
    classDef checker fill:#fc822b,stroke:#000,stroke-width:2px,color:#fff

    jiraTicket[[Create ticket for OCP access]]:::task
    SendEmail[[Send email to the approval]]:::task

    approved{Is ticket approved}:::task
    needEscalated{Needs to escalate}:::checker
    ManagerApproval[[Manager to approve the ticket]]:::task

    SendNotification[[Send notification to user]]:::task

    jiraTicket -->SendEmail;
    SendEmail -->approved;
    approved -->|No|needEscalated;
    approved --->|Yes|SendNotification

    needEscalated -->|Yes|ManagerApproval;
    ManagerApproval -->approved
{% endmermaid %}

In the diagram above, we can see that some task needs the human's input. For
this case, Parodos implement a checker solution where it can be used to
escalate a workflow to a specific person if somethind does not happens in a
time constraint.

Folowing that diagram, each blue node is a task, and we can see that the orange
box is checker that can be implemented like the workflow adminsitrator. A
checker can be defined like this:

```java
    @Bean(name = "namespaceApprovalWorkFlowChecker")
    @Checker(cronExpression = "*/5 * * * * ?")
    WorkFlow namespaceApprovalWorkFlowChecker(
            @Qualifier("namespaceApprovalWorkFlowCheckerTask") NamespaceApprovalWorkFlowCheckerTask namespaceApprovalWorkFlowCheckerTask) {
        return SequentialFlow.Builder.aNewSequentialFlow().named("namespaceApprovalWorkFlowChecker")
                .execute(namespaceApprovalWorkFlowCheckerTask).build();
    }
```

So, in this case, the checker will execute each five minutes to check if the
work need to be escalate to a higher level. To define an escalation, it's as
simple to use the `@escalation` annotation.

Here you can see an example:

```java
    @Bean
    @Escalation
    public WorkFlow simpleTaskOneEscalatorWorkflow(
            @Qualifier("simpleTaskOneEscalator") SimpleTaskOneEscalator simpleTaskOneEscalator) {
        // @formatter:off
        return SequentialFlow.Builder
                .aNewSequentialFlow()
                .named("simpleTaskOneEscalatorWorkflow")
                .execute(simpleTaskOneEscalator)
                .build();
        // @formatter:on

    }
```
