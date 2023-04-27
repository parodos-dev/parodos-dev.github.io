---
layout: documentation
title: WorkFlows Definitions
---

A workflow is defined by a Java Bean, and it registered to the database on
startup time. A Workflow needs to implement the WorkFlow interface, so it can
be used by the workflow-service, the workflow-interface can be found
[here]({{page.parodos.git_repo}}/blob/{{ page.parodos.git_branch
}}/workflow-engine/src/main/java/com/redhat/parodos/workflows/workflow/WorkFlow.java)
.

#### Types of Work

* workflow-task:  an atomic unit of work. It should be single purposed and focus
  on a particular domain task. The main
  logic of a WorkflowFlowTask is configured in the `execute` method.
* workflow: a set of workflow-tasks or workflows. It constructs a domain area or
  a logic aggregation of tasks.

#### Processing Types of Workflow

There are two processing types of workflow:

* Parallel workflow:  works inside this workflow will run simultaneously
* Sequential workflow: works inside this workflow will be executed sequentially,
  one after the other.

#### Types of Workflow

* Infrastructure workflow: this type of workflow is to execute the tasks related
  to the business logic of the domain.
* Assessment workflow: this is the workflow to process some evaluation and
  provide some options for executing
  Infrastructure workflows.
* checker workflow: a workflow that is scheduled regularly to check the status
  of a
  workflow-task [click to see details](#workflow-checker)

A workflow example can be found in the workflow-examples directory inside the
[Git  repository]({{ page.parodos.git_repo }}). An example workflow,
workflow-task can be find in the following diagram:

{% mermaid %}

flowchart TB
direction LR
{{ page.parodos.mermaid_class }}

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

the example workflow above has three child works sequentially:

1. workflow-task `Create User`
2. Parallel workflow of two child workflows: `Openshift WorkFlow`
   and `Vault WorkFlow`. `Openshift WorkFlow` is a
   sequential workflow that consists of two
   workflow-tasks: `Add Service Account` and `Add Rbac for user`. On the other
   hand, `Vault WorkFlow` is a parallel workflow comprises `Add User to Vault`
   and `Add User to aws project`
   workflow-tasks.
3. workflow-task `Email to user`.

## Concepts and Components of Workflow

### How to compose workflows

Details of steps to write workflows can be found
in [workflow-example README](https://github.com/parodos-dev/parodos/blob/main/workflow-examples/README.md)
. A typical
workflow configuration module will have a configuration class for defining
workflow and multiple classes for defining
workflow-tasks. Parodos workflow server will detect and load the workflow/tasks
by bean registration when bootstrapping.

## Workflow Configuration

Workflows are configured in a class with the `@Configuration` annotation. It is
expected there will be at least
one `@Bean` method returning a Workflow reference. Usually one configuration
class should only contain one main workflow
and all of its child works.

```java
@Configuration
....

public class SimpleWorkFlowConfiguration {
    ....
}
```

### Register Workflow Bean

In this sample below, one workflow with its task can be seen:

```java

    @Bean
    RestAPIWorkFlowTask restCall(){
        return new RestAPIWorkFlowTask();
    }


    @Bean(name = "simpleSequentialWorkFlow" + WorkFlowConstants.INFRASTRUCTURE_WORKFLOW)
    @Infrastructure
    WorkFlow simpleSequentialWorkFlowTask(@Qualifier("restCall") RestAPIWorkFlowTask restCall,LoggingWorkFlowTask loggingTask){
        return SequentialFlow
            .Builder.aNewSequentialFlow().named("simple Sequential Infrastructure WorkFlow")
            .execute(restCall)
            .then(loggingTask)
            .build();
        }


```

For the Workflow, the second argument(loggingTask) is not defined in a @Bean
method. This is because that WorkflowTask
has the @Component annotation and can be created by Spring's bean factory using
the default constructor. In contrast,
RestAPIWorkFlowTask needs a value supplied in the constructor to be created. As
a result it is created in a method
using the @Bean annotation. It's best practise to create a unique name for this
Bean as there might be multiple version
of Bean of this type created. In that example the default name is used (method
name) to identify the Bean.

The workflow example above is annotated with `@Infrastructure`. This is the most
common type of workflows that run
executions of its tasks. It runs to complete and stops if any tasks fail. The
Other two types of workflow(`@Assessment`
and `@Checker` will be explained in sections below)

### Workflow properties

When registering a workflow, only the bean annotation is needed, but at the
moment some workflow-properties can be added. These properties are metadata
base content that may is useful for the end users to append in the workflow. To
register metadata, the following example can be used:

```java

import com.redhat.parodos.workflow.annotation.WorkFlowProperties;

....

public class SimpleWorkFlowConfiguration {
    
    ....

    @Bean(name = "simpleSequentialWorkFlow" + WorkFlowConstants.INFRASTRUCTURE_WORKFLOW)
    @WorkFlowProperties(version = "${git.commit.id}")
    WorkFlow simpleSequentialWorkFlowTask(@Qualifier("restCallTask") RestAPIWorkFlowTask restCallTask) {
        return SequentialFlow
                .Builder.aNewSequentialFlow()
                .named("simpleSequentialWorkFlow" + WorkFlowConstants.INFRASTRUCTURE_WORKFLOW)
                .execute(restCallTask)
                .then(loggingTask)
                .build();
    }
    
    ....
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

### Workflow parameters

Each Work can accept parameters, these parameters is what the end user will
use to give some information to the workflow. Workflow Administrator is the one
that define in each Workflow the parameters needed.

Each parameter can be defined inside the Java Bean, and an example can be the
following one:

example of workflow parameter:

```java

@Configuration
public class ComplexWorkFlowConfiguration {
    
    ....

    @Infrastructure(parameters = {
            @Parameter(key = "workloadId", description = "The workload id", type = WorkParameterType.TEXT,
                    optional = false),
            @Parameter(key = "projectUrl", description = "The project url", type = WorkParameterType.URL,
                    optional = true),
            @Parameter(key = "WORKFLOW_SELECT_SAMPLE", description = "Workflow select parameter sample",
                    type = WorkParameterType.SELECT, optional = true, selectOptions = {"option1", "option2"},
                    valueProviderName = "complexWorkFlowValueProvider")})
    WorkFlow complexWorkFlow(@Qualifier("subWorkFlowThree") WorkFlow subWorkFlowThree,
                             @Qualifier("subWorkFlowFour") WorkFlow subWorkFlowFour) {
        return SequentialFlow.Builder.aNewSequentialFlow().named("complexWorkFlow").execute(subWorkFlowThree)
                .then(subWorkFlowFour).build();
    }
    
    ....

}

```

So, each WorkParameter has a key name, with some description and some values.
If WorkFlow Administrator wants to add some custom validation can extend the
Parameter with the JsonSchemaOptions, that it will append the value to the
parameter at the frontend.

The list of parameters can be find
[here]({{page.parodos.git_repo}}/blob/{{page.parados.git_branch}}/parodos-model-api/src/main/java/com/redhat/parodos/workflow/parameter/WorkParameterType.java)
,
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

### Workflow options

In the configuration section, a Workflow created as an Assessment will need to
return WorkflowOption.

```java

    @Bean
    WorkFlowOption onboardingOption() {
            return new WorkFlowOption.Builder("onboardingOption",
                "onboardingWorkFlow"+WorkFlowConstants.INFRASTRUCTURE_WORKFLOW)
                .addToDetails("An example of a complex WorkFlow with Status checks")
                .displayName("Onboarding")
                .setDescription("An example of a complex WorkFlow")
                .build();
    }

    @Bean
    OnboardingAssessmentTask onboardingAssessmentTask(
    @Qualifier("onboardingOption") WorkFlowOption awesomeToolsOption) {
        return new OnboardingAssessmentTask(awesomeToolsOption);
    }

    @Bean(name = "onboardingAssessment" + WorkFlowConstants.ASSESSMENT_WORKFLOW)
    @Assessment
    WorkFlow assessmentWorkFlow(
    @Qualifier("onboardingAssessmentTask") OnboardingAssessmentTask onboardingAssessmentTask) {
        return SequentialFlow.Builder.aNewSequentialFlow().named("onboarding     Assessment WorkFlow")
            .execute(onboardingAssessmentTask)
            .build();
    }

```

The WorkflowOption references a specific `@Infrastructure` Workflow bean
definition defined in the same file as `"onboardingWorkFlow" +
WorkFlowConstants.INFRASTRUCTURE_WORKFLOW`.

## Workflow Task Configuration

### Execution implementation

The main logic of a WorkflowFlowTask is configured in the `execute` method. As
can be seen in the following example

```java

    public WorkReport execute(WorkContext workContext){
        try{
            ....
            return new DefaultWorkReport(WorkStatus.COMPLETED,workContext);
        }
        catch(Exception e){
            ....
        }
        return new DefaultWorkReport(WorkStatus.FAILED,workContext);
    }

```

The execute section does the 'work' required by the task.
It also needs to return a WorkReport indicating the
WorkStatus (ie: COMPLETED, FAILED). In the case of a Sequential Workflow,
the workflow will stop executing if the
returned WorkReport has a WorkStatus of FAILED.

### WorkflowTask Parameters

WorkflowTask Parameter has the same properties as
[Workflow Parameter](#workflow-parameters).
The only difference is that WorkflowTask Parameters are defined
in the method `getWorkFlowTaskParameters` in each Task class

example of workflow-task parameter

```java

public class LoggingWorkFlowTask extends BaseInfrastructureWorkFlowTask {
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
                        .build());
    }

}

```

### WorkTask Outputs

## WorkFlow Checker

{% mermaid %}
flowchart LR
{{page.parodos.mermaid_class}}

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
@Qualifier("namespaceApprovalWorkFlowCheckerTask") NamespaceApprovalWorkFlowCheckerTask namespaceApprovalWorkFlowCheckerTask){
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
@Qualifier("simpleTaskOneEscalator") SimpleTaskOneEscalator simpleTaskOneEscalator){
        return SequentialFlow.Builder
        .aNewSequentialFlow()
        .named("simpleTaskOneEscalatorWorkflow")
        .execute(simpleTaskOneEscalator)
        .build();
        }

```
