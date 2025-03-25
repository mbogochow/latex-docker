NS = mbogochow
REPO = latex
IMAGE = $(NS)/$(REPO)

DOCKER_CMD = $(if $(shell command -v docker 2>/dev/null), docker, podman)

# Default UID/GID to current user if not specified
LATEX_UID ?= $(shell id -u)
LATEX_GID ?= $(shell id -g)

BUILD_ARGS = --build-arg LATEX_UID=$(LATEX_UID) --build-arg LATEX_GID=$(LATEX_GID)

.PHONY: build ubuntu minimal basic small medium full scientific

build: ubuntu minimal basic small medium full scientific

minimal: Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target minimal -t $(IMAGE):minimal .

small: Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target small -t $(IMAGE):small .

basic: Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target basic -t $(IMAGE):basic .

medium: Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target medium -t $(IMAGE):medium .

full: Dockerfile
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target full -t $(IMAGE):full .

ubuntu: Dockerfile.ubuntu
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target texlive-full -f Dockerfile.ubuntu -t $(IMAGE):ubuntu .

scientific: Dockerfile.ubuntu
	@$(DOCKER_CMD) build $(BUILD_ARGS) --target scientific -f Dockerfile.ubuntu -t $(IMAGE):scientific .

default: build
