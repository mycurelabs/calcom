#! /bin/bash

if [ -z "$POSTGRES_USER" ]; then
  POSTGRES_USER=admin
fi
if [ -z "$POSTGRES_PASSWORD" ]; then
  POSTGRES_PASSWORD=admin
fi
if [ -z "$POSTGRES_DB" ]; then
  POSTGRES_DB=calcom
fi

docker run \
  --rm \
  -it \
  --name calcom-postgres \
  -env POSTGRES_USER=${POSTGRES_USER} \
  -env POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
  -env POSTGRES_DB=${POSTGRES_DB} \
  -p 5432:5432 \
  postgres:16.3
