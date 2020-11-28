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

# Start CodeServer:
# If this is first run, it will generate the default password
sudo systemctl start code-server-ide

# Update DNS entry
${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare-upsert.sh

# Start the Docker project:
# This phase needs the DNS in place for Letsencrypt to work properly
(cd ${CWD} && docker-compose -f ${CWD}/docker-compose.yml up -d)

# Send email
${CODE_SERVER_CWD}/src/ec2-ubuntu-sendgrid.sh
