ARG DEBIAN_RELEASE=bookworm-slim
FROM docker.io/library/debian:${DEBIAN_RELEASE}
LABEL org.opencontainers.image.source https://github.com/jontheniceguy/vaultwarden-sync

ARG APP_RELEASE=2025.1.0

RUN export DEBIAN_FRONTEND=noninteractive && \
    NOTE="# ###########################################################" \
    NOTE="# Install System Upgrades" \
    NOTE="# ###########################################################" \
    apt-get update && \
    apt-get upgrade -y -q -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" && \
    NOTE="# ###########################################################" \
    NOTE="# Install dependencies" \
    NOTE="# ###########################################################" \
    apt-get install -y -q lsb-release curl unzip jq tini python3 gettext libsecret-1-0 && \
    NOTE="# ###########################################################" \
    NOTE="# Tidy up after yourself" \
    NOTE="# ###########################################################" \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Define the user
RUN addgroup --gid 1000 bwsync && \
    useradd -m -d /home/bwsync -s /bin/bash -g bwsync -u 1000 bwsync && \
    mkdir -p "/home/bwsync/.config/Bitwarden Directory Connector" && \
    chown -R bwsync:bwsync /home/bwsync

# Get the latest release version from GitHub API
COPY --chmod=0755 install-bwdc-from-github.sh /usr/local/bin/
RUN bash -x /usr/local/bin/install-bwdc-from-github.sh ${APP_RELEASE}

COPY --chmod=0755 init-sync.sh /init-sync.sh
COPY --chmod=0755 healthcheck.py /healthcheck.py
COPY --chmod=0755 run-sync.sh /run-sync.sh

ENV HEALTHCHECK_PORT=9999

EXPOSE $HEALTHCHECK_PORT

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/init-sync.sh"]
