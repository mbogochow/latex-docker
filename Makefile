NS = mbogochow
REPO = latex
IMAGE = $(NS)/$(REPO)

DOCKER_CMD = $(if $(shell command -v docker 2>/dev/null), docker, podman)

# Default UID/GID to current user if not specified
LATEX_UID ?= $(shell id -u)
LATEX_GID ?= $(shell id -g)

BUILD_ARGS = --build-arg LATEX_UID=$(LATEX_UID) --build-arg LATEX_GID=$(LATEX_GID)

.PHONY: build ubuntu basic full scientific

build: ubuntu basic full scientific

ubuntu: Dockerfile.ubuntu
	@$(DOCKER_CMD) build $(BUILD_ARGS) -f Dockerfile.ubuntu -t $(IMAGE)-ubuntu .

basic: Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target base -t $(IMAGE)-ctanbasic .

full: basic Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target full -t $(IMAGE)-ctanfull .

scientific: ubuntu Dockerfile.scientific
	@$(DOCKER_CMD) build $(BUILD_ARGS) -f Dockerfile.scientific -t $(IMAGE)-scientific .

default: build

