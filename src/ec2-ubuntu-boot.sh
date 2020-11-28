#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Update DNS entry
${CWD}/ec2-ubuntu-dns-cloudflare.sh

# Start the processes
sudo systemctl start code-server-ide
(cd ${CWD} && docker-compose -f ${CWD}/docker-compose.yml up -d)
