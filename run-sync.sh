#!/bin/sh
export HOME="/home/bwsync"

if ! [ -e "$HOME/.config/Bitwarden Directory Connector/data.json" ]
then
    # Static value from Container
    SYNCVERSION="$(cat /app/config/version)"
    export SYNCVERSION

    # Local data store
    SYNCTIME="$(cat /app/config/local/SYNCTIME || echo 0)"
    export SYNCTIME
    SYNCHASH="$(cat /app/config/local/SYNCHASH || echo "")"
    export SYNCHASH
    ACCESSTOKEN="$(cat /app/config/local/ACCESSTOKEN || echo "")"
    export ACCESSTOKEN

    envsubst < /etc/bitwarden-sync/data.json > "$HOME/.config/Bitwarden Directory Connector/data.json"

    if [ -z "$ACCESSTOKEN" ]
    then
        /app/bwdc logout
        /app/bwdc login \
            "$(jq -r '.authenticatedAccounts[0] as $id | .[$id].profile.apiKeyClientId' "$HOME/.config/Bitwarden Directory Connector/data.json")" \
            "$(jq -r '.authenticatedAccounts[0] as $id | .[$id].keys.apiKeyClientSecret' "$HOME/.config/Bitwarden Directory Connector/data.json")"
    fi
fi

while true
do
    /app/bwdc sync

    jq -r '.authenticatedAccounts[0] as $id | .accountActivity[$id]' "$HOME/.config/Bitwarden Directory Connector/data.json" > /app/config/local/SYNCTIME
    jq -r '.authenticatedAccounts[0] as $id | .[$id].tokens.accessToken' "$HOME/.config/Bitwarden Directory Connector/data.json" > /app/config/local/ACCESSTOKEN
    jq -r '.authenticatedAccounts[0] as $id | .[$id].directorySettings.lastSyncHash' "$HOME/.config/Bitwarden Directory Connector/data.json" > /app/config/local/SYNCHASH

    sleep 300 # seconds = 5 minutes
done
