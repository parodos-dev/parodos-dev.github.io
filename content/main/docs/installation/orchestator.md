---
title: "Orchestrator on OpenShift"
date: 2024-03-03
---

Installing the *Orchestrator* is facilitated through a Helm chart that is responsible for installing all of the *Orchestrator* components.
The *Orchestrator* is based on the [SonataFlow](https://sonataflow.org/serverlessworkflow/latest/index.html) and the [Serverless Workflow](https://serverlessworkflow.io/) technologies to design and manage the workflows.
The *Orchestrator* plugins are deployed on [Red Hat Developer Hub
](https://developers.redhat.com/rhdh/overview) instance, serves as the frontend.
To utilize *Backstage* capabilities, the *Orchestrator* imports software templates designed to ease the development of new workflows and offers an opinionated method for managing their lifecycle by including CI/CD resources as part of the template.

{{< remoteMD "https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages/README.md?raw=true" >}}
