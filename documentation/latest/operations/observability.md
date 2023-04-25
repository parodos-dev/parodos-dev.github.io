---
layout: documentation
title: Observability
---

All Parodos Observability metrics are part of the [Spring](https://spring.io/)
common metrics, so any Spring grafana dashboard will work out of the box. At
the same time, Parodos also provide more Observability metrics on top of that
ones, so users will be able to easily track the status of workflow executions.

The target URL for all Parodos services is: `/actuator/prometheus`

At the moment, Parodos team does not provide any Grafana dashboard at all, but
the idea is to provide more information soon. For Spring dashboard we recommend
the following ones:

- [https://grafana.com/grafana/dashboards/6756-spring-boot-statistics/](https://grafana.com/grafana/dashboards/6756-spring-boot-statistics/)
- [https://grafana.com/grafana/dashboards/4701-jvm-micrometer/](https://grafana.com/grafana/dashboards/4701-jvm-micrometer/)

Regarding Opentracing, it's not yet implemented, but is planned for the near
future.

## WorkFlow-service metrics

More than spring metrics, each service provide us different  metrics, here are
the list of metrics for the workflow-service

| Name: | workflow_executions_total                                   |
|-------|-------------------------------------------------------------|
| Labels: | IN_PROGRESS, COMPLETED, REJECTED                          |
| Description: | Each time that a workflow execution change it's state|
{: .table }

## Notification-service metrics

At the moment, notification service does not have any special metric.
