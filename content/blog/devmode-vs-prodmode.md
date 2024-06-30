---
date: 2024-06-30
title: Production Mode vs. Dev Mode
---

When setting up workflow orchestration, it's crucial to understand the differences between production mode and development (dev) mode, particularly in terms of infrastructure requirements. This distinction ensures that workflows are efficiently managed and executed based on their intended use case. Here, we'll explore these differences, focusing on the infrastructure required to run workflows in each mode.

# Production Mode
Production mode is tailored for environments where stability, reliability, and scalability are paramount. The Orchestrator Helm chart or Orchestrator operator is designed specifically to meet the demanding requirements of production environments. Key requirements include:

* **Long-running Workflows**: Production mode supports workflows that may take several hours or even days to complete, ensuring that these processes run smoothly without interruption.
* **Persistence of Running Workflow Instances**: Ensuring the persistence of workflow instances is critical. In production, all workflow data is stored and maintained even if the orchestrator restarts, preventing data loss.
* **Event Handling Reliability**: Reliable handling of events is essential for maintaining workflow integrity and ensuring that all triggers and actions occur as expected.
* **Scalability**: The system must be capable of scaling up to handle increasing workloads, allowing for the addition of resources as demand grows.
* **Updates Through Pipelines**: Workflows can be updated and managed through continuous integration/continuous deployment (CI/CD) pipelines, facilitating smooth and efficient updates.
* **Externalizing Credentials**: Credentials are managed outside the workflow configuration to enhance security and simplify updates.
* **Runtime Isolation**: Each workflow runs in its isolated environment, preventing any interference between workflows.
* **Authorization and Administration**: Robust mechanisms are in place for authorizing and administering workflow deployments, ensuring that only authorized personnel can make changes.

# Development (Dev) Mode
Dev mode, as the name implies, is optimized for development purposes. It allows developers to experiment with the Orchestrator plugins without the need for a full deployment process or access to a Kubernetes (K8s) or OpenShift (OCP) cluster. Characteristics of dev mode include:

* **Ephemeral Workflows**: Workflows run in an ephemeral mode, meaning that they are temporary and do not persist after the container restarts. This is suitable for development and testing.
* **No Persistence**: In dev mode, there is no persistence for running workflow instances. All instance information is lost after a container restart, making it ideal for short-running or non-critical workflows.
* **Development Focus**: Dev mode is designed for developers to gain experience and test workflows without the overhead of a full production environment.
* **Hot-deployment of Workflows**: Developers can deploy new workflows by simply placing the workflow files in a designated folder, enabling rapid iteration and testing.
* **Simpler Deployment Model**: A single container serves all workflows, simplifying the deployment process and reducing the need for extensive infrastructure setup.
* **Acceptable Data Loss**: For short-running workflows or development scenarios, the occasional loss of workflow instance tracking is acceptable.

# Summary
Understanding the infrastructure requirements for production and dev modes is essential for effective workflow orchestration. Production mode ensures reliability, scalability, and persistence, making it suitable for critical, long-running workflows. Dev mode, on the other hand, provides a lightweight, flexible environment for development and testing, where temporary workflows and occasional data loss are acceptable. By selecting the appropriate mode based on the use case, organizations can optimize their workflow management processes.