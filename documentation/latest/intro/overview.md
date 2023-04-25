---
layout: documentation
title: What is Parodos
---

Parodos is a Java toolkit to help enterprise's with a legacy footprint build
internal developer platforms (IDP) that enable their developers to get access
to the tools and environments required to start coding with less time, friction
and frustration.

The focus of Parodos is around Workflows (composed of WorkflowTasks) that bring
together the existing tools and processes of the enterpise in an end-to-end
experience that developers, quality assurance, production support and other
enterprise software development/delivery team members can consume (through our
Backstage plugins or by your own interfaces calling these backing services) to
get the outcomes they need with fewer tickets/meetings/frustration.

## Building Developer Platforms In Enterprise Environments

Building an IDP provides a centralized place to improve the experience for
developers trying to build and release code in large environments.

For many enterprise environments, especially regulated ones, the source of some
friction preventing a positive developer experience is that they are entangled
with long-standing processes and tools which are tied to audit, compliance and
regulation. These components are often:

- Unique to the enterprise
- Providing a necessary safeguard
- Difficult to change or remove

For more thoughts and opinions on the challenges in making changes to an
existing software culture in an enterprise environment, please review the
following blog:

[https://www.redhat.com/en/blog/modernization-why-is-it-hard](https://www.redhat.com/en/blog/modernization-why-is-it-hard)

For more information about building IDPs in regulated enterprise environments,
review the following:

[https://www.redhat.com/en/blog/considerations-when-implementing-developer-portals-regulated-enterprise-environments](https://www.redhat.com/en/blog/considerations-when-implementing-developer-portals-regulated-enterprise-environments)

Parodos is focused on building solutions based on technical stacks that are
both familiar, and have a history of success for enterprises described in the
preceding articles.

## The Focus of parodos

Although frameworks and ecosystems might exist to help build developer portals,
getting some of these approved for production use in certain enterprises,
especially if they have a large ecosystem written by disparate developers,
might be difficult.

Some enterprises may struggle with Javascript heavy approaches. That is not to
say such libraries, frameworks and platforms are not suited for the task. On
the contrary they might be just what is needed, but a chasm might exist to
fully adopt in an enterprise environment that has legacy technology and
processes.

Other enterprises might have existing IDP tools that are home-grown over years
and might need to be leveraged in the initial stages of any new IDP work.

Parodos is ancient Greek and translates to 'a side-entrance to the stage'. In
this theme, Parodos provides Java based building blocks (specifically Spring
beans) to bring together backend processes and components that might be
considered more 'legacy' as workflows (including existing IDP components) that
can be consumed in Backstage.

The most common use case for Parodos is giving developers a place where they
can provide inputs for Assessments (ie: a link to their project code and/or an
application identifying code), and based on logic determined by the enterprise
a list of Workflows are presented to them.

Examples might be:

- Upgrade to existing tool stack and environments to newer versions
- Migrate to new tooling and environments
- Onboard for the first time to tooling and environments
- Add/Remove developers to a project
- Change properties of an environment (ie: add more memory to QA)

Developers will be presented with simple Wizard based steppers that collect
information as needed and update them of any back-end approvals that are kicked
off during the workflow which might result in a pause in the workflow.

In the backend Parodos will be calling the exact tooling to create enterprises
approved blueprints for that specific use case.

All the logic of Parodos can be maintained in a seperate Java project using
Spring beans as a means of creating and configuring workflows (future versions
of Parodos will support other means of configuration).

## Who Is Parodos For?

The following describes who would benefit the most from Parodos:

1. Enterprises that are struggling logistically (or technically due to
   challenges hiring in a specific technology stack) Javascript heavy products
   in the developer portal space

2. Teams that are comfortable building and operating a custom Java based
   application

3. Environments where there are existing tools for building, deploying and
   observing application that can be integrated with

If all of these exist, your enterprise may benefit from using Parodos to build
some workflows to help developers deliver code faster.
