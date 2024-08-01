---
date: 2024-03-13
title: Installing the Orchestrator on existing RHDH instance
---

When [RHDH](https://developers.redhat.com/rhdh) is already installed and in use, reinstalling it via the Helm chart is unnecessary. Instead, integrating the Orchestrator into such an environment involves a few key steps:

1. Utilize the Helm chart to install the requisite components, such as the SonataFlow operator and the OpenShift Serverless Operator, while ensuring the RHDH installation is disabled.
2. Manually update the existing RHDH ConfigMap resources with the necessary configuration for the Orchestrator plugin.
3. Import the Orchestrator software templates into the Backstage catalog.

## Prerequisites
- Ensure that a [PostgreSQL](https://www.postgresql.org/) database is available and that you have credentials to manage the tablespace (optional).
  - For your convenience, a [reference implementation](https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages/postgresql/README.md) is provided.
  - If you already have a PostgreSQL database installed, please refer to this [note](https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages/postgresql/README.md#note-the-default-settings-provided-in-postgresql-values-match-the-defaults-provided-in-the-orchestrator-values) regarding default settings.

The required configurations for Orchestrator can be found at the following links:
* [v1.0.x](https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages-stable-1.x/existing-rhdh.md) - for RHDH-1.1.x
* [v1.2.x](https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages/docs/existing-rhdh.md) - for RHDH-1.2.x **WIP**
