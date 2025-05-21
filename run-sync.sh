#!/bin/bash
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    if [ -n "${PID_FILE:-}" ] && [ -e "${PID_FILE:-}" ]
    then
        echo "Stopping stunnel"
        kill "$(cat "$PID_FILE")"
        rm -f "$PID_FILE"
        echo "---"
    fi
}

WAITING=0

until [ -e '/tmp/ready-to-go' ]
do
    if [ "$WAITING" -eq 0 ]
    then
        echo "Waiting for a successful login" | /usr/bin/tee -a /dev/termination-log
        WAITING=1
    fi
    sleep 1
done

if [ "${LDAP_cert:-null}" != "null" ] && [ "${LDAP_key:-null}" != "null" ] && [ "${LDAP_hostname:-null}" != "null" ]
then
    echo "Starting stunnel"
    PID_FILE=/tmp/stunnel.pid
    stunnel4 "/home/bwsync/.config/stunnel.conf" &
fi

/usr/bin/bwdc sync | /usr/bin/tee -a /dev/termination-log