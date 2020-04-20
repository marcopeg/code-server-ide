#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
# set -o allexport
# source "${CWD}/.env"
# set +o allexport

# Start the processes
sudo systemctl start code-server
docker-compose -f ${CWD}/docker-compose.yml up -d

# Update DNS registry
${CWD}/ec2-ubuntu-cloudflare.sh
