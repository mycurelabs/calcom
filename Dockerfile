FROM node:18 as builder

WORKDIR /calcom

ARG DATABASE_URL
ARG MAX_OLD_SPACE_SIZE=4096

ENV NEXT_PUBLIC_LICENSE_CONSENT=agree \
    CALCOM_TELEMETRY_DISABLED=1 \
    NEXT_PUBLIC_WEBAPP_URL=http://PLACEHOLDER_NEXT_PUBLIC_WEBAPP_URL \
    NEXT_PUBLIC_API_V2_URL=http://PLACEHOLDER_NEXT_PUBLIC_API_V2_URL \
    DATABASE_URL=$DATABASE_URL \
    DATABASE_DIRECT_URL=$DATABASE_URL \
    NEXTAUTH_SECRET=PLACEHOLDER_NEXTAUTH_SECRET \
    CALENDSO_ENCRYPTION_KEY=PLACEHOLDER_CALENDSO_ENCRYPTION_KEY \
    NODE_OPTIONS=--max-old-space-size=${MAX_OLD_SPACE_SIZE} \
    GOOGLE_API_CREDENTIALS={} \
    EMAIL_FROM=notifications@example.com \
    EMAIL_SERVER_HOST=smtp.example.com \
    EMAIL_SERVER_PORT=587 \
    EMAIL_SERVER_USER=email_user \
    EMAIL_SERVER_PASSWORD=email_password

COPY package.json yarn.lock .yarnrc.yml playwright.config.ts turbo.json git-init.sh git-setup.sh ./
COPY .yarn ./.yarn
COPY apps/web ./apps/web
COPY apps/api/v2 ./apps/api/v2
COPY packages ./packages
COPY tests ./tests

RUN yarn config set httpTimeout 1200000
RUN npx turbo prune --scope=@calcom/web --docker
RUN yarn install
RUN ls -la node_modules
RUN yarn db-deploy
RUN yarn --cwd packages/prisma seed-app-store
RUN yarn --cwd apps/web workspace @calcom/web run build

# RUN yarn plugin import workspace-tools && \
#     yarn workspaces focus --all --production
RUN rm -rf node_modules/.cache .yarn/cache apps/web/.next/cache










FROM node:18 as builder-two

WORKDIR /calcom

ARG NEXT_PUBLIC_WEBAPP_URL=http://localhost:3000

ENV NODE_ENV=production

COPY package.json .yarnrc.yml yarn.lock turbo.json ./
COPY .yarn ./.yarn
COPY --from=builder /calcom/node_modules ./node_modules
COPY --from=builder /calcom/packages ./packages
COPY --from=builder /calcom/apps/web ./apps/web
COPY --from=builder /calcom/packages/prisma/schema.prisma ./prisma/schema.prisma
COPY scripts scripts

# replace proper urls with placeholders
RUN scripts/replace-placeholder.sh http://PLACEHOLDER_NEXT_PUBLIC_WEBAPP_URL PLACEHOLDER_NEXT_PUBLIC_WEBAPP_URL
RUN scripts/replace-placeholder.sh http://PLACEHOLDER_NEXT_PUBLIC_API_V2_URL PLACEHOLDER_NEXT_PUBLIC_API_V2_URL










FROM node:18 as runner

WORKDIR /calcom

COPY --from=builder-two /calcom ./

ENV NODE_ENV=production
ENV NEXT_PUBLIC_WEBAPP_URL=http://localhost:3000
ENV NEXT_PUBLIC_API_V2_URL=http://localhost:5555/api/v2

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=30s --retries=5 \
    CMD wget --spider http://localhost:3000 || exit 1

CMD ["/calcom/scripts/start.sh"]
