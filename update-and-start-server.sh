#!/bin/bash

# Requires start-server.sh and update-server.sh

# Request root privileges if not already attained.
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Run both scripts.
echo "Updating, recompiling and starting server"
./update-server.sh
./start-server.sh

