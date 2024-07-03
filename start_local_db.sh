#! /bin/bash

docker run \
  --rm \
  -it \
  --name calcom-postgres \
  --env-file .env.shell.local \
  -p 5432:5432 \
  postgres:16.3
