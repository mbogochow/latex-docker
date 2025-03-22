NS = mbogochow
REPO = latex
IMAGE = $(NS)/$(REPO)

DOCKER_CMD = $(if $(shell command -v docker 2>/dev/null), docker, podman)

.PHONY: build build_ubuntu build_basic build_full

build: build_ubuntu build_basic build_full

build_ubuntu: Dockerfile.ubuntu
	@$(DOCKER_CMD) build -f Dockerfile.ubuntu -t $(IMAGE):ubuntu .

build_basic: Dockerfile.basic
	@$(DOCKER_CMD) build -f Dockerfile.basic -t $(IMAGE):ctanbasic .

build_full: build_basic Dockerfile.full
	@$(DOCKER_CMD) build -f Dockerfile.full -t $(IMAGE):ctanfull .

default: build
