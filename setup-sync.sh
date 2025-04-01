#!/bin/sh
export HOME="/home/bwsync"

if ! [ -e "$HOME/.config/Bitwarden Directory Connector/data.json" ]
then
    # Static value from Container
    SYNCVERSION="$(cat /app/config/version)"
    export SYNCVERSION

    envsubst < /etc/bitwarden-sync/data.json > "$HOME/.config/Bitwarden Directory Connector/data.json"

    # shellcheck disable=SC1091
    . /etc/bitwarden-sync/auth.env

    if [ -n "$BW_SERVER" ]
    then
        /app/bwdc config server "$BW_SERVER"
    fi

    /app/bwdc logout
    /app/bwdc login
    touch /tmp/ready-to-go
fi

tail -f /dev/termination-log 2>/dev/null