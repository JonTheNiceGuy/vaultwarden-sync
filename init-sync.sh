#!/bin/sh
set -e

/run-sync.sh &
pid1=$!

/healthcheck.py &
pid_healthcheck=$!

# Function to kill all background jobs
cleanup() {
    echo "Cleaning up..."
    kill "$pid1" "$pid_healthcheck" 2>/dev/null
    wait "$pid1" "$pid_healthcheck" 2>/dev/null
}

# Trap EXIT to ensure cleanup on script exit
trap 'cleanup' EXIT

# Monitor the processes
while true; do
    if ! kill -0 "$pid1" 2>/dev/null; then
        echo "Process $pid1 failed (/run-sync.sh)"
        exit 1
    fi
    if ! kill -0 "$pid_healthcheck" 2>/dev/null; then
        echo "Process $pid_healthcheck failed (healthcheck.py)"
        exit 2
    fi
    sleep 1
done