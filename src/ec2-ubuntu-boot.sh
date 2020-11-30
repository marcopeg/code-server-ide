#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

echo "[$(date -u)] Booting up..." >> ${CODE_SERVER_LOGS}/setup.log

# Start CodeServer:
# If this is first run, it will generate the default password
sudo systemctl start code-server-ide

# Update DNS entry
${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare-upsert.sh

# Start the Docker project:
# This phase needs the DNS in place for Letsencrypt to work properly
if [ "no" != "${CODE_SERVER_AUTO_START}" ];
then
  (cd ${CWD} && docker-compose -f ${CWD}/docker-compose.yml up -d)
fi

# Send welcome email:
# Awaits for Code Server to generate the password
until [ -f /home/ubuntu/.config/code-server/config.yaml ]
do
  sleep 1
done
${CODE_SERVER_CWD}/src/ec2-ubuntu-sendgrid.sh
