FROM openclaw:stable

# -----------------------------------------------------------------------------
# OpenClaw Extended
# -----------------------------------------------------------------------------
LABEL org.opencontainers.image.title="OpenClaw Extended" \
      org.opencontainers.image.description="OpenClaw stable with curl and Chromium" \
      org.opencontainers.image.version="1.0.0"

ARG USER_ID=1000
ARG GROUP_ID=1000

USER root

# Map container user/group to host user/group so bind mounts work seamlessly
RUN if [ "${USER_ID}" != "1000" ] || [ "${GROUP_ID}" != "1000" ]; then \
        groupmod -g ${GROUP_ID} node && usermod -u ${USER_ID} -g ${GROUP_ID} node; \
    fi

ENV DEBIAN_FRONTEND=noninteractive \
    CHROME_BIN=/usr/bin/chromium \
    CHROME_PATH=/usr/bin/chromium \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

# Install curl and Chromium (ARM64 & AMD64 compatible)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && chromium --version

# Simple wrapper script so the node user can call `openclaw` from anywhere
# Remove any existing symlink first so we don't overwrite /app/openclaw.mjs
# RUN rm -f /usr/local/bin/openclaw \
#     && printf '%s\n' '#!/bin/sh' 'cd /app || exit 1' 'exec node openclaw.mjs "$@"' > /usr/local/bin/openclaw \
#     && chmod +x /usr/local/bin/openclaw

USER node
