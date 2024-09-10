---
title: "Installation"
date: 2024-03-03
weight: 3
---

The deployment of the orchestrator involves multiple independent components, each with its unique installation process. Presently, our supported method is through a specialized Helm chart designed for deploying the orchestrator on either OpenShift or Kubernetes environments. This installation process is modular, allowing optional installation of components if they are already present.

The *Orchestrator* deployment encompasses the installation of the engine for serving serverless workflows and Backstage, integrated with orchestrator plugins for workflow invocation, monitoring, and control.

In addition to the *Orchestrator* deployment, we offer several *workflows* (linked below) that can be deployed using their respective installation methods.