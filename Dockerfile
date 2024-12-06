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

RUN raco pkg install --auto --clone shindig https://github.com/jaybonthius/shindig.git || true

RUN echo "BASE_URL=${BASE_URL}" && \
    make sqlite pagetree render-all build-css publish

# Show final content for debugging
RUN echo "Final content directory:" && \
    ls -la content/
