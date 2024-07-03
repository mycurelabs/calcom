#! /bin/bash

# require the following environment variables
# - CALENDSO_ENCRYPTION_KEY

if [ -z "$CALENDSO_ENCRYPTION_KEY" ]; then
  echo "CALENDSO_ENCRYPTION_KEY is required"
  exit 1
fi
if [ -z "$NEXTAUTH_SECRET" ]; then
  NEXTAUTH_SECRET=${CALENDSO_ENCRYPTION_KEY}
fi
if [ -z "$NEXT_PUBLIC_WEBAPP_URL" ]; then
  NEXT_PUBLIC_WEBAPP_URL="http://localhost:3000"
fi
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
if [ -z "$DATABASE_DIRECT_URL" ]; then
  DATABASE_DIRECT_URL=$DATABASE_URL
fi

echo "Starting image: ${CONTAINER_IMAGE}..."

docker run \
  --rm \
  -it \
  --network host \
  -p 3000:3000 \
  -e NEXT_PUBLIC_WEBAPP_URL=${NEXT_PUBLIC_WEBAPP_URL} \
  -e NEXT_PUBLIC_LICENSE_CONSENT=${NEXT_PUBLIC_LICENSE_CONSENT} \
  -e CALCOM_TELEMETRY_DISABLED=${CALCOM_TELEMETRY_DISABLED} \
  -e NEXTAUTH_SECRET=${NEXTAUTH_SECRET} \
  -e CALENDSO_ENCRYPTION_KEY=${CALENDSO_ENCRYPTION_KEY} \
  -e DATABASE_HOST=${DATABASE_HOST} \
  -e DATABASE_URL=${DATABASE_URL} \
  -e DATABASE_DIRECT_URL=${DATABASE_DIRECT_URL} \
  ${CONTAINER_IMAGE}
