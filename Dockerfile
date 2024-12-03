FROM nicheceviche/shindig-dev:latest

ARG BASE_URL=""

# Switch back to root for installation
USER root

WORKDIR /app

COPY package.json pnpm-lock.yaml postcss.config.js ./

RUN pnpm install --frozen-lockfile --prod

COPY pollen.rkt ./
COPY content/ ./content/
COPY Makefile ./
COPY scripts/ ./scripts/

RUN racket scripts/make-db.rkt
RUN raco pkg install --auto --clone shindig https://github.com/jaybonthius/shindig.git || true

RUN echo "BASE_URL=${BASE_URL}" && \
    make render-all && \
    make build-css && \
    make publish

# Show final content for debugging
RUN echo "Final content directory:" && \
    ls -la content/
