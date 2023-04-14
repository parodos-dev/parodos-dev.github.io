---
layout: documentation
title: System Requirements
---


There are two kinds of requirements for project Flotta, there is the operator
requirements (All needed to manage the devices) and some requirements that are
needed for the device-agent.

## Operator requirements:

| Requirement   | Min version | Optional  | Comment                                                                      |
| Kubernetes    | 1.19        | no        |                                                                              |
| Noobaa        | 5.9         | yes       | Only if [Data Synchronization](data_synchronization.md) is in use                              |
| Cert-manager  | 1.7.1       | yes       | Only if [ENABLE_WEBHOOKS](deployment_options.md#enable_webhooks) are enabled |
{: .table }

## Device requirements:

| Requirement       | Min version | Optional  |
| yggdrasil         | master      | no        |
| podman            | >=4.2       | no        |
| nftables          | 1           | no        |
| node_exporter     | 1.3.1       | no        |
| ansible           | 2.9         | no        |
{: .table }


For all the device requirements, project-flotta maintains a fedora Copr repo
that a user can use to initialize a device.

[https://copr.fedorainfracloud.org/coprs/project-flotta/flotta/](https://copr.fedorainfracloud.org/coprs/project-flotta/flotta/)

The version that are supported are:

- Fedora 36 (Both ARM and X86 architecture)
- Centos 8 and 9 (Both ARM and X86 architecture)

Debian based packages are not yet provided.
