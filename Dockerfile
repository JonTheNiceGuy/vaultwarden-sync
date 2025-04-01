ARG DEBIAN_REGISTRY=docker.io
ARG DEBIAN_REPO=library/debian
ARG DEBIAN_RELEASE=bookworm-slim
FROM ${DEBIAN_REGISTRY}/${DEBIAN_REPO}:${DEBIAN_RELEASE}

LABEL maintainer = "Jon Spriggs <vaultwardensync@jon.sprig.gs>"

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
    apt-get install -y -q lsb-release curl unzip jq python3 gettext libsecret-1-0 && \
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

COPY --chmod=0755 setup-sync.sh /setup-sync.sh

HEALTHCHECK --interval=300s --timeout=300s --start-period=5s --retries=3 CMD [ "/bin/sh", "-c", \
    "until [ -e '/tmp/ready-to-go'] ; do sleep 1 ; done ; /app/bwdc sync | /usr/bin/tee /dev/termination-log" \
]

CMD ["/bin/sh", "-c", "/setup-sync.sh"]
