#!/bin/bash

if [[ "$#" -eq 0 ]]; then
   cat << EOF
   This script will generate a post file in markdown format, that will 
   source its content in build-time from a remote markdown file:
   
    Example:
   ./generate-doc-for-repo.sh https://github.com/parodos-dev/serverless-workflows/blob/main/README.md

EOF
exit 1
fi


url=$1

cat << EOF
---
title: $(echo "$url" | awk -F"/" '{print $5 " " $8}')
date: "$(date --rfc-3339=date)"
---

{{< remoteMD "$url?raw=true" >}}
EOF
