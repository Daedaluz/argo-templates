#!/bin/sh
set -eu

IMAGE="${1:-ghcr.io/daedaluz/argo-templates/gh}"
TAG="${2:-latest}"

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag "${IMAGE}:${TAG}" \
  --push \
  .
