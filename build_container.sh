#! /bin/bash

# require the following environment variables
# - CONTAINER_IMAGE
# - DATABASE_URL

if [ -z "$CONTAINER_IMAGE" ]; then
  echo "CONTAINER_IMAGE is required"
  exit 1
fi
if [ -z "$DATABASE_URL" ]; then
  echo "DATABASE_URL is required"
  exit 1
fi

# BUILD_PLATFORMS="linux/amd64,linux/arm64"
BUILD_PLATFORMS="linux/amd64"

echo "Building image: ${CONTAINER_IMAGE} for ${BUILD_PLATFORMS}..."

# enable buildx for multiplatform build
# ci ref: https://dev.to/ken_mwaura1/automate-docker-image-builds-and-push-to-github-registry-using-github-actions-4h20
# ref: https://dev.to/maxtacu/cross-platform-container-images-with-buildx-and-colima-4ibj
# tldr:
# docker-buildx create --name multiplatform-builder
# docker-buildx use multiplatform-builder
# docker-buildx inspect --bootstrap
#
# fix for the --network host issue: https://github.com/docker/buildx/issues/835#issuecomment-966496802
# tldr:
# docker-buildx create --use --name multiplatform-builder --driver-opt network=host --buildkitd-flags '--allow-insecure-entitlement network.host'
# docker-buildx use multiplatform-builder
# docker-buildx inspect --bootstrap

# docker-buildx build \
#   --platform ${BUILD_PLATFORMS} \
docker build \
  --network host \
  --build-arg DATABASE_URL=${DATABASE_URL} \
  -t ${CONTAINER_IMAGE} \
  .
