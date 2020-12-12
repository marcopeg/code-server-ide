#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/.env"
set +o allexport

# Get the target port from CLI or ask:
TARGET_PORT=${1}
if [ -z "${TARGET_PORT}" ] ; then
  echo "On which port is the process?"
  read TARGET_PORT
fi

# Execute the command
echo "[$(date -u)] Killing process on port ${TARGET_PORT}" >> ${CODE_SERVER_LOGS}/cs.log
sudo kill -9 `sudo lsof -t -i:${TARGET_PORT}`
