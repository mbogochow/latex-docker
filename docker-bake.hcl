variable "REGISTRY" {
  default = "ghcr.io"
}

variable "NAMESPACE" {
  default = "mbogochow"
}

variable "IMAGE" {
  default = "latex"
}

variable "LATEX_UID" {
  default = "1000"
}

variable "LATEX_GID" {
  default = "1000"
}

# Common settings that will be reused across targets
target "common" {
  args = {
    LATEX_UID = "${LATEX_UID}"
    LATEX_GID = "${LATEX_GID}"
  }
}

# Alpine-based targets
target "minimal" {
  inherits = ["common"]
  dockerfile = "Dockerfile"
  target = "minimal"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:minimal"]
}

target "small" {
  inherits = ["common"]
  dockerfile = "Dockerfile"
  target = "small"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:small"]
}

target "basic" {
  inherits = ["common"]
  dockerfile = "Dockerfile"
  target = "basic"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:basic"]
}

target "medium" {
  inherits = ["common"]
  dockerfile = "Dockerfile"
  target = "medium"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:medium"]
}

target "full" {
  inherits = ["common"]
  dockerfile = "Dockerfile"
  target = "full"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:full"]
}

# Ubuntu-based targets
target "ubuntu" {
  inherits = ["common"]
  dockerfile = "Dockerfile.ubuntu"
  target = "texlive-full"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:ubuntu"]
}

target "scientific" {
  inherits = ["common"]
  dockerfile = "Dockerfile.ubuntu"
  target = "scientific"
  tags = ["${REGISTRY}/${NAMESPACE}/${IMAGE}:scientific"]
}

# Default group includes all targets
group "default" {
  targets = ["minimal", "small", "basic", "medium", "full", "ubuntu", "scientific"]
}

# Group for Alpine-based images
group "alpine" {
  targets = ["minimal", "small", "basic", "medium", "full"]
}

# Group for Ubuntu-based images
group "ubuntu-based" {
  targets = ["ubuntu", "scientific"]
}