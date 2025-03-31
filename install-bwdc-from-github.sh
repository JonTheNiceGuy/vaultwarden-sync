#!/bin/bash

APP_RELEASE="${1:-}"
if [ -z "$APP_RELEASE" ]
then
    echo "You must supply a release string."
    exit 1
fi

if [ "$APP_RELEASE" == "latest" ]
then
    LATEST_VERSION="$(curl -s https://api.github.com/repos/bitwarden/directory-connector/releases/latest | jq -r '.tag_name' | sed 's/v//')"
else
    LATEST_VERSION="$APP_RELEASE"
fi

echo "Latest version: $LATEST_VERSION"

mkdir -p /app/config
echo "$LATEST_VERSION" > /app/config/version

curl -L -o /tmp/bwdc.zip "https://github.com/bitwarden/directory-connector/releases/download/v${LATEST_VERSION}/bwdc-linux-${LATEST_VERSION}.zip"
SHA256SUM="$(sha256sum /tmp/bwdc.zip | cut -d\  -f1)"
echo "sha256sum of bwdc is $SHA256SUM"

curl -L -o /tmp/bwdc.sha256 "https://github.com/bitwarden/directory-connector/releases/download/v${LATEST_VERSION}/bwdc-linux-sha256-${LATEST_VERSION}.txt"

if ! [ "$SHA256SUM" == "$(cat /tmp/bwdc.sha256)" ]
then
    echo "Download failure."
    exit 1
fi

unzip /tmp/bwdc.zip -d /app

echo "Download Success!"
