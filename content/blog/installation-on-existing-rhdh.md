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

To install the required components without RHDH, utilize the `--set rhdhOperator.enabled=false` option. A comprehensive command would resemble the following:

```bash
helm upgrade -i orchestrator orchestrator/orchestrator --set rhdhOperator.enabled=false
```
This command will result in the installation of the Sonataflow Operator and OpenShift Serverless Operators. Alternatively, these operators can be installed directly from the operator catalog.

The required configurations for Orchestrator can be found at the following links, categorized by version:
* [v1.0.x](https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages-stable-1.x/existing-rhdh.md)
* [v1.2.x](https://github.com/parodos-dev/orchestrator-helm-chart/blob/gh-pages/docs/existing-rhdh.md) - **WIP**
