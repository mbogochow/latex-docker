#!/bin/sh
IMAGE=mbogochow/latex-ubuntu
exec docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$(pwd)":/data "$IMAGE" "$@"
