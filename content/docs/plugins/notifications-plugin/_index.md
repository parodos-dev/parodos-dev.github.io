---
title: "Notifications Plugin"
---

Documentation section of notifications plugin. This plugin is part of Backstage Core.

# Frontend
The frontend UI is implemented as a side bar item.  
The following screenshots show how to use the notifications UI.  
Whenever a new notification is detected the frontend pops an alert to the user.  

## The Frontend UI

### Notifications page
![Frontend UI](./sidebar-button-plus-alert.png)

### Notifications list
![Notifications list](./list-view.png)

# Backend
The backend plugin provides the backend application for reading and writing notifications.

## REST endpoints and OpenAPI
The plugin does not yet provide an OpenAPI spec. However, we created our own spec for posting notifications. It can be found [here](https://github.com/parodos-dev/serverless-workflows/blob/main/shared/specs/notifications-openapi.yaml). [Documentation of the OpenAPI spec](https://github.com/parodos-dev/serverless-workflows/blob/main/shared/specs/notifications-openapi.adoc). 
The readme file provides an [example](https://github.com/backstage/backstage/tree/master/plugins/notifications-backend#sending-notifications-by-external-services) for posting a notification.

# Forward to Email
It is possible to forward notification content to email address. In order to do that you must add the [Email Processor Module](https://github.com/backstage/backstage/tree/master/plugins/notifications-backend-module-email) to your backstage backend. The email title is taken from the notification title and the email body is taken from the notification's description and link.

## Configuration
An example configuration, as well as a link to all configuration options, can be found in the module's [readme](https://github.com/backstage/backstage/tree/master/plugins/notifications-backend-module-email).

## Ignoring unwanted notifications
The configuration of the module explains how to configure filters. Filters are used to ignore notifications that should not be forwarded to email. The supported filters include minimum/maximum severity and list of excluded topics.

## User notifications
Each user notification has a list of recipients. The recipient is an entity in backstage catalog. The notification will be sent to the email addresses of the recipients.

## Broadcast notifications
In broadcast notifications we do not have recipients. The module's configuration supports a few options for broadcast notifications:
 - Ignoring broadcast notifications
 - Sending to predefined address list
 - Sending to all users