---
layout: documentation
---

# Operator Deployment options

Operator has different deployment modes, where some parameters can be turned
on/off based on a configMap value. To edit one of these parameters, the
following configmap should be edited. 

```shell
kubectl edit cm -n flotta flotta-manager-config
```

After any change in that config map, flotta-operator needs to be rebooted. 

### AUTO_APPROVAL_PROCESS

- **Default**: true 
- **Values**: _boolean_
- **Description**: If set to true, when a new device request to enrol, operator
automatically creates a device on the default namespace. Using this way there is
no need to have human interaction to start running workloads on any device.

### EDGEWORKLOAD_CONCURRENCY

- **Default**: 5
- **Values**: _integer_
- **Description**: Number of concurrent goroutines to create for handling
  EdgeWorkload reconcile

### ENABLE_WEBHOOKS

- **Default**: true
- **Values**: _boolean_
- **Description**: If Webhooks are enabled, an admission webhook is created and
  checked when any user submits any change to any project-flotta.io CRD.

### LEADER_ELECT
- **Default**: false
- **Values**: _boolean_
- **Description**: Enable leader election for controller manager. Enabling this
  will ensure there is only one active controller manager.

### LOG_LEVEL

- **Default**: info
- **Values**: [debug, info, warn, error, dpanic, panic, fatal]
- **Description**:  Log level for operator, by default is info and change in the
  configmap will automatically reload the config.

### MAX_CONCURRENT_RECONCILES

- **Default**: 3
- **Values**: __positive integer__
- **Description**: MaxConcurrentReconciles is the maximum number of concurrent
  Reconciles which can be run

### METRICS_ADDR

- **Default**: :8080
- **Values**: __port range__
- **Description**: Where operator will expose prometheus metrics.

### OBC_AUTO_CREATE

- **Default**: false
- **Values**: __boolean__
- **Description**: Enable OBC auto creation when EdgeDevice is registered

### PROBE_ADDR

- **Default**: :8081
- **Values**: __port range__
- **Description**: The address the probe endpoint binds to.

### WEBHOOK_PORT

- **Default**: :9443
- **Values**: __port range__
- **Description**: WebhookPort is the port that the webhook server serves at.

# Edge API Deployment options

Edge API has different deployment modes, where some parameters can be turned
on/off based on a configMap value. To edit one of these parameters, the
following configmap should be edited.

```shell
kubectl edit cm -n flotta flotta-edge-api-config
```

After any change in that config map, Flotta Edge API needs to be rebooted.

### BACKEND

- **Default**: crd
- **Values**: [crd, remote]
- **Description**:  Specifies which storage backend should the Edge API use. For `remote` see [REMOTE_BACKEND_URL](#remote_backend_url) and [REMOTE_BACKEND_TIMEOUT](#remote_backend_timeout)

### CLIENT_CERT_EXPIRATION_DAYS

- **Default**: 30
- **Values**: __positive integer__
- **Description**: Client certificate expiration time in days.

### DOMAIN

- **Default**: project-flotta.io
- **Values**: domain
- **Description**: Domain for which TLS certificate is issued.

### HTTPS_PORT

- **Default**: :8043
- **Values**: __port range__
- **Description**: Edge HTTPS API port.

### KUBECONFIG

- **Default**: __blank__
- **Values**: __path__
- **Description**: Path to a kubeconfig file to be used when Edge API runs outside of a cluster.

### LOG_LEVEL

- **Default**: info
- **Values**: [debug, info, warn, error, dpanic, panic, fatal]
- **Description**:  Log level for the edge API, by default is info.

### METRICS_ADDR

- **Default**: :8080
- **Values**: __port range__
- **Description**: Where API will expose prometheus metrics.

### PROBE_ADDR

- **Default**: :8081
- **Values**: __port range__
- **Description**: The address the probe endpoint binds to.

### REMOTE_BACKEND_URL

- **Default**: __blank__
- **Values**: __url__
- **Description**: URL of a remote Edge Configuration API.

### REMOTE_BACKEND_TIMEOUT

- **Default**: __5s__
- **Values**: __duration__
- **Description**: Timeout that should be used while making calls to a remote Edge Configuration API.

### TLS_LOCALHOST_ENABLED

- **Default**: true
- **Values**: __boolean__
- **Description**: Enables TLS certificate to work with localhost.
