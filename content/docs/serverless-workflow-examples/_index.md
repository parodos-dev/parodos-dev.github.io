---
title: "Serverless Workflow Examples"
date: 2024-03-03
weight: 4
---

Documentation of example workflows from https://github.com/parodos-dev/serverless-workflow-examples

# How to add a new document
Documents can include markdown content from all the related *`parodos-dev`* repositories. 
To create a document entry from a markdown file use this:

```bash
./generate-doc-for-repo.sh \
    https://github.com/parodos-dev/serverless-workflow-examples/blob/main/README.md > content/docs/workflow-examples/newdoc.md
```
