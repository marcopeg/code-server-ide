#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/data/.env"
set +o allexport

echo "[$(date -u)] Booting up..." >> ${CODE_SERVER_LOGS}/setup.log

# Generate default auth/passwd in case of missing file
if [ ! -f "${CODE_SERVER_CWD}/data/passwd" ]; then
  echo "[$(date -u)] Writing Auth/passwd default password..." >> ${CODE_SERVER_LOGS}/setup.log
  echo "admin" > "${CODE_SERVER_CWD}/data/passwd"
  chown ubuntu:ubuntu "${CODE_SERVER_CWD}/data/passwd"
fi

# Start CodeServer:
# If this is first run, it will generate the default password
sudo systemctl start code-server-ide

# Update DNS entry
echo "[$(date -u)] Attempt to set up the DNS entries ..." >> ${CODE_SERVER_LOGS}/setup.log
${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare-upsert.sh

# Start the Docker project:
# This phase needs the DNS in place for Letsencrypt to work properly
if [ "no" != "${CODE_SERVER_AUTO_START}" ];
then
  docker-compose -f ${CWD}/docker-compose.yml up -d auth-passwd traefik code-server
fi

# Send welcome email:
# Awaits for Code Server to generate the password
echo "[$(date -u)] Attempt to send the Welcome email ..." >> ${CODE_SERVER_LOGS}/setup.log
until [ -f /home/ubuntu/.config/code-server/config.yaml ]
do
  echo "[$(date -u)] Awaiting for code-server/config.yaml ..." >> ${CODE_SERVER_LOGS}/setup.log
  sleep 1
done
${CODE_SERVER_CWD}/src/ec2-ubuntu-sendgrid.sh


echo "[$(date -u)] Setup completed :-)" >> ${CODE_SERVER_LOGS}/setup.log