FROM racket/racket:8.14

ARG BASE_URL=""

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -y \
        nodejs=18.* \
        curl \
        && \
    npm install -g pnpm@9.10.0 && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/archives/* \
        /usr/share/doc \
        /usr/share/man \
        /tmp/*

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile --prod

COPY shindig/ ./shindig/
COPY pollen.rkt ./

RUN echo "BASE_URL=${BASE_URL}"

RUN raco pkg install --auto shindig/

COPY content/ ./content/
COPY sqlite/ ./sqlite/


RUN raco pollen render -r content

RUN pnpm run build:css

RUN raco pollen publish content out

RUN echo "Final content directory:" && \
    ls -la content/