#!/bin/bash
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

/usr/bin/bwdc sync | /usr/bin/tee -a /dev/termination-log