## Secret generator

NOTE: follow the ff generator for the secrets as there is an error when CALENDSO_ENCRYPTION_KEY is generated as documented

```sh
NEXTAUTH_SECRET=$(openssl rand -base64 32)
CALENDSO_ENCRYPTION_KEY=$(openssl rand -base64 24)
```

## Docker build

Requires:
- docker
- build machine (via colima in apple silicon) with 120GB storage, 12GB RAM, 8 CPU cores

Ensure the ff envs:
```sh
POSTGRES_USER=caladmin
POSTGRES_PASSWORD=secret
POSTGRES_DB=calcom
POSTGRES_HOST=localhost:5432
POSTGRES_DIRECT_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}/${POSTGRES_DB}
NEXT_PUBLIC_WEBAPP_URL=http://localhost:3000
NEXTAUTH_URL=${NEXT_PUBLIC_WEBAPP_URL}/api/auth
NEXTAUTH_SECRET=secret
CALENDSO_ENCRYPTION_KEY=secret
DATABASE_HOST=${POSTGRES_HOST}
DATABASE_URL=${POSTGRES_DIRECT_URL}
DATABASE_DIRECT_URL=${DATABASE_URL}
CONTAINER_IMAGE=ghcr.io/mycurelabs/calcom
```
Build using

```sh
# start a database on the side (for the image build)
./start_local_db.sh

# build container image
./build_container.sh

# start built container
./start_container.sh
```
