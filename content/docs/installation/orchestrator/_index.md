---
title: "Orchestrator"
date: 2024-03-03
---

Installing the *Orchestartor* is facilitated through a Helm chart that is reponsible for installing all of the *Orchestrator* components.
The *Orchestrator* is based on the [SonataFlow](https://sonataflow.org/serverlessworkflow/latest/index.html) and the [Serverless Workflow](https://serverlessworkflow.io/) technologies to design and manage the workflows.
The *Orchestrator* plugins are deployed on [Janus IDP Backstage](https://github.com/janus-idp/backstage-showcase) instance, serves as the frontend.
To utilize *Backstage* capabilities, the *Orchestartor* imports software templates designed to ease the development of new workflows and offers an opiniated method for managing their lifecycles by including CI/CD resources as part of the template.

There are two options to install the Orchestrator deployment helm chart:

