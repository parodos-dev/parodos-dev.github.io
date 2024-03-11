---
date: "2024-03-08"
title: Orchestrator plugin OpenAPI
---

Orchestrator plugin is composed by three parts:
* [orchestrator](https://github.com/janus-idp/backstage-plugins/tree/main/plugins/orchestrator) (frontend)
* [orchestrator-common](https://github.com/janus-idp/backstage-plugins/tree/main/plugins/orchestrator-common)
* [orchestrator-backend](https://github.com/janus-idp/backstage-plugins/tree/main/plugins/orchestrator-backend)

The plugin provides OpenAPI endpoints definition to facilitate communication between the frontend and backend. This approach minimizes the data that needs to be sent to the frontend, provides flexibility and avoids dependencies on changes in the [CNCF serverless specification](https://github.com/serverlessworkflow/specification/blob/main/specification.md). It also allows for a seamless transition if there's a need to replace the backend implementation.

In addition, by leveraging on OpenAPI spec, it is possible to generate clients and create CI steps.

# OpenAPI
OpenAPI specification [file](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-common/src/openapi/openapi.yaml) is available in [orchestrator-common](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-common).

## orchestrator-common
The typescript schema is generated in [auto-generated](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-common/src/auto-generated/api/models/schema.ts) folder from openapi.yaml specification file.

## orchestrator-backend
The orchestrator backend can use the generated schema to validate the HTTP requests and responses.

> NOTE: Temporary the validation has been disabled. It will be enabled when the orchestrator frontend will switch to the use of v2 endpoints only.

### Development instruction

Checkout the backstage-plugin

`git clone git@github.com:janus-idp/backstage-plugins.git`

If you need to change the OpenAPI spec, edit the [openapi.yaml](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-common/src/openapi/openapi.yaml) according to your needs and then execute from the project root folder: 

`yarn --cwd plugins/orchestrator-common openapi`

This command updates the [auto-generated files](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-common/src/auto-generated/api/) and the [auto-generated docs](https://github.com/janus-idp/backstage-plugins/tree/main/plugins/orchestrator-common/src/auto-generated/docs).

> NOTE: Do not manually edit auto-generated files

If you add a new component in the spec, then you need to export the generated typescript object [here](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-common/src/openapi/types.ts). For example, if you define

```yaml
components:
  schemas:
    Person:
      type: object
      properties:
        name:
          type: string
        surname:
          type: string
```

then 

```typescript
export type Person = components['schemas']['Person'];
```

When defining a new endpoint, you have to define the `operationId`.
That `id` is the one that you can use to implement the endpoint logic.

For example, let's assume you add 
```yaml
paths:
  /names:
    get:
      operationId: getNames
      description: Get a list of names
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
               type: array
                items:
                  $ref: '#/components/schemas/Person'
```

Then you can implement the endpoint in [router.ts](https://github.com/janus-idp/backstage-plugins/blob/main/plugins/orchestrator-backend/src/service/router.ts) referring the operationId `getNames`: 

```typescript
api.register(
    'getNames',
    async (_c, _req, res: express.Response, next) => {
      // YOUR LOGIC HERE
      const result: Person[] = [
          {name: "John", surname: "Snow"},
          {name: "John", surname: "Black"}
      ];

      res.status(200).json(result);
    },
  );
``





