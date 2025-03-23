NS = mbogochow
REPO = latex
IMAGE = $(NS)/$(REPO)

DOCKER_CMD = $(if $(shell command -v docker 2>/dev/null), docker, podman)

# Default UID/GID to current user if not specified
LATEX_UID ?= $(shell id -u)
LATEX_GID ?= $(shell id -g)

BUILD_ARGS = --build-arg LATEX_UID=$(LATEX_UID) --build-arg LATEX_GID=$(LATEX_GID)

.PHONY: build build_ubuntu build_basic build_full

build: build_ubuntu build_basic build_full

build_ubuntu: Dockerfile.ubuntu
	@$(DOCKER_CMD) build $(BUILD_ARGS) -f Dockerfile.ubuntu -t $(IMAGE):ubuntu .

build_basic: Dockerfile.basic
	@$(DOCKER_CMD) build $(BUILD_ARGS) -f Dockerfile.basic -t $(IMAGE):ctanbasic .

build_full: build_basic Dockerfile.full
	@$(DOCKER_CMD) build $(BUILD_ARGS) -f Dockerfile.full -t $(IMAGE):ctanfull .

default: build
