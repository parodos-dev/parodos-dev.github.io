---
date: 2024-09-05
title: Creating Reduced OpenAPI Documents for Integrating Systems on Serverless Workflows
---

# Creating Reduced OpenAPI Documents for Integrating Systems on Serverless Workflows
The blog post will guide developers on how to reduce openAPI documents to a manageable size. The need for this procedure has risen in account of restrictions that Quarkus imposes with accepting large YAML files as input [(see appendix)](#appendix). This restriction directs us to be mindful and plan ahead which resources services we would need in our workflow. 


In this guide, we will explain what is an OpenAPI Document, how to read and use the openAPI Specification, and eventually we will cover the steps to reduce an openAPI document in a valid manner. 

## What is an OpenAPI Document?
>A self-contained or composite resource which defines or describes an API or elements of an API. 

OpenAPI documents are a standardized way to view a system’s exposed paths, resources and webhooks, and act as an alternative to using restAPI calls for interacting with other systems.
An OpenAPI document uses and conforms to the OpenAPI Specification, and in itself is a JSON object (which may be represented either in JSON or YAML format). 

For the OpenAPI Spec Documentation, see: https://swagger.io/specification/

## How to make sense of an OpenAPI Document:
Let’s take a look at the [aap-openAPI document](https://github.com/parodos-dev/serverless-workflow-examples/blob/main/aap-db-deploy-quarkus/src/main/resources/specs/aap-openapi.yaml) for some reference: 

<div style="height: 200px; overflow-x: auto; border=10px">
<pre>
<code>
openapi: 3.0.3
info:
  title: The AAP Rest Api
  version: v2
servers:
  - url: https://your-app-platform.io/
paths:
  /api/v2/job_templates/{job_template_id}/launch/:
    post:
      description: Launch a job from a template id
      operationId: launchJob
      parameters:
        - name: job_template_id
          in: path
          required: true
          schema:
            type: integer
      requestBody:
        content:
            application/json:
              schema:
                $ref: '#/components/schemas/LaunchJobRequest'
      responses:
        "201":
          description: Created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LaunchJobResponse'
        "401":
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UnauthorizedError'
      security:
        - basicAuth: []
  /api/v2/jobs/{job_id}/:
    get:
      description: Retrieve a job from a job id
      operationId: getJob
      parameters:
        - name: job_id
          in: path
          required: true
          schema:
            type: integer
      responses:
        "200":
          description: Success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/GetJobResponse'
        "401":
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UnauthorizedError'
      security:
        - basicAuth: []
components:
  schemas:
    LaunchJobRequest:
      type: object
      properties:
        limit:
          type: string
        extra_vars:
          type: object
          properties:
            rhel_inventory_group:
              type: string
      additionalProperties: false
    LaunchJobResponse:
      type: object
      properties:
        id:
          type: integer
        failed:
          type: boolean
        status:
          type: string
      additionalProperties: false
    GetJobResponse:
      type: object
      properties:
        id:
          type: integer
        failed:
          type: boolean
        status:
          type: string
      additionalProperties: false
    UnauthorizedError:
      type: object
      properties:
        detail:
          type: string
  securitySchemes:
    basicAuth:
      type: http
      scheme: basic
</code>
</pre>
</div>

The JSON object hierarchy can be described in the following diagram:  
(Some objects have been added for completeness)
```
openapi
info
├── title
└── version
servers
security
paths
├── path_1
└── path_2
components
├── schemas
│   ├── shema_1
│   └── schema_2
├── securitySchemas
├── parameters
└── headers
```
 
The document begins by specifying the openAPI version, an info object, and specifying the servers.
```
openapi: 3.0.1
info:
 title: Kubernetes
 version: v1.29.6+aba1e8d
servers:
 - url: /
security:
 - BearerToken: []
 ```

The document will then display the system's paths, and must include at least one path.  
Under each path, the document specifies the path URI, an HTTP method, parameters (if needed), the requestBody, and defines the responses. 
Note that both the request and the responses can reference a component from a different part of the document. This will be important when we try to reduce the document to our needed purposes. 

<div style="height: 200px; overflow-x: auto;">
<pre>
<code>
paths:
/api/v2/job_templates/{job_template_id}/launch/:
post:
    description: Launch a job from a template id
    operationId: launchJob
    parameters:
    - name: job_template_id
        in: path
        required: true
        schema:
        type: integer
    requestBody:
    content:
        application/json:
            schema:
            $ref: '#/components/schemas/LaunchJobRequest'
    responses:
    "201":
        description: Created
        content:
        application/json:
            schema:
            $ref: '#/components/schemas/LaunchJobResponse'
</code>
</pre>
</div>


Lastly, The document specifies the components it uses in its paths. 
A component can be a schema for any resource, some parameter specification object, HTTP headers and more. To view more openAPI documents to get a sense of some practical examples, [see:](https://github.com/parodos-dev/serverless-workflow-examples/tree/main/aap-db-deploy-quarkus/src/main/resources/specs)
```
components:
 schemas:
   LaunchJobRequest:
     type: object
     properties:
       limit:
         type: string
```


Note the securitySchemas object, which specifies the authentication method used: 
```
securitySchemes:
   BearerToken:
     type: http
     scheme: bearer
```

## How to reduce an OpenAPI Document to workable size?
Let's say we have an outline of a serverless workflow, and a very large openAPI document that exposes many system resources, much more than we intend on using.
The procedure for reducing the openAPI document can be described as the following:

1. Open the full OpenAPI document and initialize a new document.
2. Copy any ‘openapi’, ‘info’, ‘security’, ‘servers’ objects to the new document.    
3. Identify all system resources that are needed for the workflow.
    - For each resource, locate the path object that returns the needed resource and add it to the ‘paths’ object of the new document.
    - If the added path references a component that is found later in the document (a header, schema, etc), make sure to add it to the ‘components’ object of the new document. 
4. Include the securitySchema of the original ‘components’ object. 
5. Include any webhooks the application may need.  

## Best Practices and Warnings:
**Document size:** Even though the Quarkus engine has a YAML input file size limit of 3MB, the `kn-workflow` CLI generates k8s resources (configmaps) for spec/schema files.  
K8s has a default size limit of ~1MB per resource, and by default they get applied to all as part of the helm charts created. 
Therefore, it is best practice to keep the reduced openAPI documents to under 1MB, until this practice is changed.    

<a name="appendix"></a>
### Appendix:
Quarkus uses [snakeYAML](https://bitbucket.org/snakeyaml/snakeyaml/src/master/) to process the input YAML files in a serverless workflow. A default setting of a maximum size limit has been put in place, which inhibits accepting large files. 
```
Caused by: org.yaml.snakeyaml.error.YAMLException: The incoming YAML document exceeds the limit: 3145728 code points.
[...]
[ERROR] Error parsing content
com.fasterxml.jackson.dataformat.yaml.JacksonYAMLParseException: The incoming YAML document exceeds the limit: 3145728 code points.
 at [Source: (StringReader); line: 82506, column: 15]
 ```

 For reference, a [reproducer](https://github.com/ElaiShalevRH/reproducers) was creater for this issue.  

