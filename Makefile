JEKYLL_VERSION ?= 4.2.2

CONTAINER_NAME ?= parodos.github.io
IMG=parodos-jekyll
DOCKER ?= docker


all: build

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Build

build-container:
	$(DOCKER) build -t $(IMG) .docker

build:  ## build the site
build: build-container
	$(DOCKER) run --rm --volume="$(PWD):/srv/jekyll:Z" $(IMG) jekyll build

check-links: ## Check that all INTERNAL links are working correctly
check-links: build
	$(DOCKER) run --rm -v $(PWD)/_site:/src klakegg/html-proofer:3.19.2 --allow-hash-href --empty-alt-ignore --disable-external

check-markdown: ## Check that all markdown is correctly formatted.
	$(DOCKER) run --rm -v $(PWD):/work tmknom/markdownlint -- ./documentation/

run: build ## run the site on localhost:4000
	$(DOCKER) run --rm --name $(CONTAINER_NAME) --volume="$(PWD):/srv/jekyll:Z" -p 4000:4000 -it $(IMG) jekyll serve --watch --drafts 

