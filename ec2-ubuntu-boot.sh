#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Start ssh agent
eval "$(ssh-agent -s)"
ssh-add ${CWD}/data/.ssh/id_rsa

# Update DNS registry
${CWD}/ec2-ubuntu-cloudflare.sh

# Start the processes
sudo systemctl start code-server
(cd ${CWD} && docker-compose up -d)
