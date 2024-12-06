FROM nicheceviche/shindig-package:latest

ARG BASE_URL=""
ARG PRETTY_URL="false"

# Switch back to root for installation
USER root

WORKDIR /app

COPY package.json pnpm-lock.yaml postcss.config.js ./

RUN pnpm install --frozen-lockfile --prod

COPY pollen.rkt ./
COPY content/ ./content/
COPY Makefile ./
COPY scripts/ ./scripts/

ENV BASE_URL=${BASE_URL}
ENV PRETTY_URL=${PRETTY_URL}

RUN echo "BASE_URL=${BASE_URL}" && \
    echo "PRETTY_URL=${PRETTY_URL}" && \
    make sqlite pagetree render-all build-css publish

# Show final content for debugging
RUN echo "Final content directory:" && \
    ls -la content/