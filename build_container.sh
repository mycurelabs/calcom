#! /bin/bash

if [ -z "$CONTAINER_IMAGE" ]; then
  CONTAINER_IMAGE=ghcr.io/mycurelabs/calcom
fi
if [ -z "$POSTGRES_USER" ]; then
  POSTGRES_USER=admin
fi
if [ -z "$POSTGRES_PASSWORD" ]; then
  POSTGRES_PASSWORD=admin
fi
if [ -z "$POSTGRES_DB" ]; then
  POSTGRES_DB=calcom
fi
if [ -z "$DATABASE_HOST" ]; then
  DATABASE_HOST=localhost:5432
fi
if [ -z "$DATABASE_URL" ]; then
  DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${DATABASE_HOST}/${POSTGRES_DB}
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
