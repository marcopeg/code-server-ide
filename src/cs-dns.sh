#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/.env"
set +o allexport

# Prepare the logs file
touch ${CODE_SERVER_LOGS}/cs.log

echo "[$(date -u)] Update CloudFlare DNS entry" >> ${CODE_SERVER_LOGS}/cs.log
${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare.sh
