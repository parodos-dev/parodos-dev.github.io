---
layout: documentation
title: Parodos concepts
---

The concepts chapter provides an overview of all aspects of Parodos. See the
getting started guides section if you are looking for an entry point
introduction to Parodos.

# Components overview

Parodos is a collection of services which can run in any platform, the
following components are needed:

## Workflow-service

Is the service that register all the workflows and schedule the
workflow-executions, escalations and retries in the platform.

## Notification-service

## Backstage

[Backstage](https://backstage.io/) is a  open-source IDP (Internall developer
platform) which is used by Parodos to install a frontend plugin to be able to
consume Parodos API from there. Even that it's a must have, Backstage is not a
dependency in the project, and users are free to create a custom frontend.
