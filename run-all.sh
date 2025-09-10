#!/bin/bash
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    if [ -n "${PID_FILE:-}" ] && [ -e "${PID_FILE:-}" ]
    then
        echo "====================================================="
        echo "                  Stopping Stunnel                   "
        echo "====================================================="
        kill "$(cat "$PID_FILE")"
        rm -f "$PID_FILE"
        echo "---"
    fi
}

echo "====================================================="
echo "        Setting up Bitwarden Sync application        "
echo "====================================================="

# Create the data file
SOURCE_FILE="$(/usr/bin/bwdc data-file 2>/dev/null)"
export SOURCE_FILE

# Create a subshell to protect the credentials
bash -c '
    source /etc/bitwarden-sync/auth.env

    if [ -n "$BW_SERVER" ]
    then
        echo "====================================================="
        echo "               Configuring Server Name               "
        echo "====================================================="
        /usr/bin/bwdc config server "$BW_SERVER"
    fi

    echo "====================================================="
    echo "                      Logging In                     "
    echo "====================================================="
    /usr/bin/bwdc logout
    until /usr/bin/bwdc login | grep "logged in"
    do
        sleep 5
    done

    echo "====================================================="
    echo "               Applying Other Settings               "
    echo "====================================================="
    /usr/bin/configure-bwdc.sh "$SOURCE_FILE"
'

echo "====================================================="
echo "                   Setup completed                   "
echo "====================================================="

if [ -e "/home/bwsync/.config/stunnel.conf" ]
then
    echo "====================================================="
    echo "                  Starting Stunnel                   "
    echo "====================================================="
    PID_FILE=/tmp/stunnel.pid
    stunnel4 "/home/bwsync/.config/stunnel.conf" &
fi

echo "====================================================="
echo "                     Running Sync                    "
echo "====================================================="

/usr/bin/bwdc sync
