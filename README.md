# project-flotta.io webpage


## Build

```
make build
```

## Check links

```
make check-link
```

## Run site locally

```
make run
```

The site is available at http://localhost:4000/

## Contrib

Template based on `github.com/themefisher/kross-jekyll` project.


## Documentation version update

On documentation version change, the following changes need to be done:

- [] cp _data/documentation/latest.yaml _data/documentation/$VERSION.yaml
- [] cp -rfv /documentation/latest /documentation/$VERSION
- [] edit /documentation/$VERSION/gsg/*.md and change the following:
  - git clone commands to the right version.
  - make deploy with the right container version
- [] edit /documentation/$VERSION/operations/api.html and change the swagger URL

