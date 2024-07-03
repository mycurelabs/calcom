#!/bin/sh
set -x

# replace placeholders with runtime values
scripts/replace-placeholder-all.sh

scripts/wait-for-it.sh ${DATABASE_HOST} -- echo "database is up"
npx prisma migrate deploy --schema /calcom/packages/prisma/schema.prisma
npx ts-node --transpile-only /calcom/packages/prisma/seed-app-store.ts
yarn start
