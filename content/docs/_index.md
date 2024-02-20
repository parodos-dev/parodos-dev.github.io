---
title: "Documentation"
date: 2024-02-20 
---

# How to add a document?
Documents can include markdown content from all the related *`parodos-dev`* repositories. 
To create a document entry from a markdown file use this:

```bash
./generate-doc-for-repo.sh \
    https://github.com/parodos-dev/$REPO/blob/$BRANCH//README.md > content/docs/newdoc.md
```
