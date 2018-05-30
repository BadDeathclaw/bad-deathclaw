#!/bin/bash

# Request root privileges if not already attained.
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Run script.
echo "Starting server on port 1942"
nice -n -10 DreamDaemon fallout13.dmb 1942 -private -trusted 

