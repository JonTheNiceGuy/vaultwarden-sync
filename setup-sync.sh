#!/bin/sh
export HOME="/home/bwsync"

if ! [ -e "$HOME/.config/Bitwarden Directory Connector/data.json" ]
then
    # Create the data file
    SOURCE_FILE="$(/usr/bin/bwdc data-file 2>/dev/null)"
    export SOURCE_FILE

    bash -c '
        source /etc/bitwarden-sync/auth.env

        if [ -n "$BW_SERVER" ]
        then
            /usr/bin/bwdc config server "$BW_SERVER"
        fi

        /usr/bin/bwdc logout
        until /usr/bin/bwdc login | grep "logged in"
        do
            sleep 5
        done

        /usr/bin/configure-bwdc.sh "$SOURCE_FILE"
    '
    touch /tmp/ready-to-go
fi

tail -f /dev/termination-log 2>/dev/null