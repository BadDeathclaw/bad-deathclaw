#!/bin/bash

# Request root privileges if not already attained.
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

# Run script.
echo "Updating and recompiling server"
git pull
DreamMaker fallout13.dme

