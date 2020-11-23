#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Update DNS registry
${CWD}/ec2-ubuntu-cloudflare.sh

# Start the processes
sudo systemctl start code-server
(cd ${CWD} && docker-compose up -d)
