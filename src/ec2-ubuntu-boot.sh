#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Prepare the logs file
touch ${CODE_SERVER_LOGS}/boot.log

echo "[$(date -u)] Booting up..." >> ${CODE_SERVER_LOGS}/boot.log

# Update DNS entry
${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare-upsert.sh

# Start the processes
sudo systemctl start code-server-ide
(cd ${CWD} && docker-compose -f ${CWD}/docker-compose.yml up -d)
