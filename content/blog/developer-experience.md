---
date: 2024-03-15
title: 'Serverless Workflows: an Automated Developer Experience'
---
Great job on installing the Orchestrator plugin and the SonataFlow operator! But what comes next?

If you aim to understand the full development lifecycle of serverless workflows, from zero to production, then you've come to the right place.

Thanks to the Orchestrator functions and automations, developers can now focus solely on building their applications without being burdened by unnecessary cognitive load. Let's delve into how to effectively manage the end-to-end software development lifecycle of serverless workflows,
leveraging these built-in capabilities. 

## A Reference Architecture for Automated Deployments of Serverless Workflows
The reference architecture that we're going to describe consists of the following components:
* `Orchestrator Helm chart`: the installer of RHDH Orchestrator .
* `Red Hat Developer Hub (RHDH)`: the Red Hat product for Backstage.
* `Tekton/Red Hat OpenShift Pipelines`: the Kubernetes-Native CI pipeline to build images and deployment configurations.
* `ArgoCD/Red Hat OpenShift GitOps`: the CD pipeline to deploy the workflow on the RHDH instance.
* `Quay.io`: the container registry service to store the software images.
* `SonataFlow platform`: the SonataFlow implementation of the Serverless Workflow specifications, including a Kubernetes operator and the platform services (data index, jobs service).
* `SonataFlow`: the custom resource representing the workflow.
* `GitHub workflow repo`: the source code repository of the workflow.
* `GitHub gitops repo`: the repository of the `kustomize` deployment configuration.
  * Includes the commands to boostrap the ArgoCD applications on your selected environment.

![feature branches git workflow](/content/blog/images/cicd-architecture.png)
 
Please note that all these components, with the exclusion of the `Quay.io` and the `GitHub` organizations, are either bundled with the Orchestrator plugin or managed by the software projects generated with the RHDH Software Templates.

## Software Development with Git
Let's assume your company follows the `feature branches git workflow`:
* Developers work on individual `feature` branches.
* The `develop` branch serves as the integration point where all features are merged to validate the application in the staging environment.
* Once the software receives the green light, the code is released to the `main` branch and deployed to the production environment.

![feature branches git workflow](/content/blog/images/git-workflow.png)

Don't be surprised, but the Orchestrator plugin automatically installs all the needed resources to handle these steps for you throughout the entire
software development lifecycle.

## The Software Development Lifecycle
### Creating the Software Project
RHDH offers the [software template](https://backstage.io/docs/features/software-templates/) functionality to create the foundational structure of
software projects adhering to industry best practices in software development and deployment. 

The Orchestrator plugin comes with its own templates designed to kickstart your workflow project. By selecting a template tagged with `orchestrator`, you gain access to the following benefits, all at no cost:

* A fully operational software project to develop your serverless workflow, in a newly generated Git repository under the organization of your choice.
* A ready-to-use configuration repository with a [kustomize](https://kustomize.io/) configuration to deploy the workflow on the designated RHDH instance.
* (*) Automated CI tool deployment to build workflows on the selected cluster.
* (*) Automated CD automation deployment to deploy applications implementing your workflow.

(*): optional but highly recommended!

Sounds great, isn't it?

### Developing the Serverless Workflow
This topic will be soon expanded in a dedicated post. However, we'd like to at least provide a list of a few amazing tools that you can use in this stage:
* VSCode editor and the [VS Code extension for Serverless Workflow editor](https://sonataflow.org/serverlessworkflow/latest/tooling/serverless-workflow-editor/swf-editor-vscode-extension.html)
* [Quarkus](https://sonataflow.org/serverlessworkflow/latest/getting-started/create-your-first-workflow-service.html)
* [Swagger](https://sonataflow.org/serverlessworkflow/latest/getting-started/create-your-first-workflow-service.html)
* [SonataFlow extension in Quarkus Dev UI](https://sonataflow.org/serverlessworkflow/latest/testing-and-troubleshooting/quarkus-dev-ui-extension/quarkus-dev-ui-overview.html)

Using these toolkits and platforms, you can develop and test(*) your applicationn either on your local machine or as a containerized image, 
before moving to the next step.

(*): both unit and integration tests are supported
### Testing the Staging Environment
And here comes the magic of automation.

Whenever a feature is merged in the staging branch, the CI/CD pipelines are triggered to build the container image, update the deployment configuration
and deploy them to the staging instance of RHDH. You don't have to do anything for this – the installed automation tools will handle the process for you.

That was a brief section, wasn't it? This way, you can save reading time and focus on validating the workflow application in the staging environment.

### Ready for Production
Get ready for another quick section.

Once the software has been validated and released, the CI/CD pipelines are triggered again to build and deploy the application in the production environment. Easy-peasy, and once again, making efficient use of the developer's time.

## Wrapping Up
What are you waiting for then? Design your first workflow and let the Orchestrator handle the tedious tasks for you. 

Get customer-ready in just a minute with the power of the Automated Developer Experience for RHDH Orchestrator!
