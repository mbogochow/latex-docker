#!/bin/bash
DEFAULT_IMAGE=mbogochow/latex:ubuntu
IMAGE="$DEFAULT_IMAGE"

usage() {
    echo "Usage: $0 [-i image] command [args...]"
    exit 1
}

while getopts "i:h" opt; do
    case $opt in
        i) IMAGE="$OPTARG" ;;
        h) usage ;;
        ?) usage ;;
    esac
done
shift $((OPTIND-1))

[ $# -eq 0 ] && usage

exec docker run --rm -i --user="$(id -u):$(id -g)" --net=none -v "$(pwd)":/data "$IMAGE" "$@"
