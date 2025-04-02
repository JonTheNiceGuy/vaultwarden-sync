#!/bin/bash
echo "Waiting for a successful login" | /usr/bin/tee /dev/termination-log

until [ -e '/tmp/ready-to-go' ]
do
    sleep 1
done

/usr/bin/bwdc sync | /usr/bin/tee /dev/termination-log