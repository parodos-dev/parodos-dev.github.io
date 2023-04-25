---
layout: documentation
title: Parodos concepts
---

The concepts chapter provides an overview of all aspects of Parodos. See the
getting started guides section if you are looking for an entry point
introduction to Parodos.

# Parodos services:

## Workflow-service

Provides the APIs to run Workflows defined using the Parodos model. It also
persists Workflow definitions (and tracks changes of definitions), persists
execution state and provides scheduling for long-running WorkFlowTasks.

## Notification-service

Simple API for posting read-only messages related to downstream processes. The
Parodos Backstage plugins provide a UI to display these messages. This service
might be useful for those team members who might not have access to other
commonly used communication systems (like Slack). It also provides a means of
providing the users with updates in the same interface where the workflow is
being executed

## Backstage

[Backstage](https://backstage.io/) is a  open-source IDP (Internall developer
platform) which is used by Parodos to install a frontend plugin to be able to
consume Parodos API from there. Even that it's a must have, Backstage is not a
dependency in the project, and users are free to create a custom frontend.


# Parodos components


## Parodos Model Api

This is the model used by all services. It also contains some abstract
definition of WorkflowTask for specific use cases (ie: Assessment, checking a
downstream approval). At present all Workflows and WorkflowTasks are define as
Spring Framework beans.

# Workflow engine

The current library for executing WorkFlow(s) in Parodos service.Parodos sits
on top of existing tools and process in an enterprise environment. As a result,
it's assumed there will be existing workflow tool and business rules engine.
However, within Parodos itself there is a need to execute tasks asynchronously
while collecting their results.

There are existing Workflow engines in Java but many are very complex (BPMN
implementations), and as previously it's assumed where Parodos is running there
will most likely be such engines/frameworks. As a result Parodos's current
implementation for internally executing Workflows is
https://github.com/j-easy/easy-flows.

Inside the workflow engine, there are multiple concepts that are key to
understand the code:


### WorkFlowTask

An executable task. Used in Infrastructure Assessment, events related to
requesting infrastructure and the abstraction that sits above Pipelines

### Workflow

A collection of Work that is executed in specific fashion. There are multiple
implementations of Workflow included in the project. It also admits to get
sub-workflows to it.

### WorkContext

Resource passed into Work (can contain arguments for execution or the results
of the work)

### WorkReport

Returned from Work after its execution, useful in determining if the Work
execution was successful

### WorkFlow Task Checker

Some Workflows inside the enterprises needs some kind of "Check" that something
happens, this is normally a human interaction. The checker is a abstraction on
a task which empower Workflows administrator to validate that something happens
by a human.


### WorkFlow Escalation

When a checker is needed, normally needs this human interaction. Some many
issues may occur, like the human which needs to sign the paper is away. To fix
this issue Parodos introduces WorkFlow escalations. Where the user Workflow
adminsitration can escalate the WorkFlow if the checker is not fullfilled by
the time defined.


# Pattern Detection Library

A java library that can be used in AssessmentTasks to identify
application/configuration patterns that can be associated with specific
workflows (ie: Batch applications might have a different pipeline and
environments than a .NET based MVC application).

# Workflow examples

A standalone project that can be added to the workflow-service's classpath to
provide some samples of what WorkFlows could look like. This is basically a
'Hello Wold' for the workflow-service
