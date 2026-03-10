#!/bin/sh
set -eu

IMAGE="${1:-ghcr.io/daedaluz/argo-templates/gh}"
TAG="${2:-latest}"

GIT_SHA=$(git rev-parse HEAD)
GIT_SHORT=$(git rev-parse --short HEAD)
GIT_TAG=$(git describe --tags --exact-match 2>/dev/null || true)
REPO_URL=$(git remote get-url origin 2>/dev/null || true)

LABELS="--label org.opencontainers.image.revision=${GIT_SHA}"
LABELS="${LABELS} --label org.opencontainers.image.source=${REPO_URL}"
if [ -n "${GIT_TAG}" ]; then
  LABELS="${LABELS} --label org.opencontainers.image.version=${GIT_TAG}"
fi

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag "${IMAGE}:${TAG}" \
  ${LABELS} \
  --push \
  .
