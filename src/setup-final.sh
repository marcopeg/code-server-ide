#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Final steps and cleanup
###

# Pull Docker images for running the proxy server
echo "[$(date -u)] Pulling images..." >> ${CODE_SERVER_LOGS}/setup.log
docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml pull >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Change folder ownership to the "ubuntu" user
chown -R ubuntu:ubuntu ${CODE_SERVER_CWD} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
chown -R ubuntu:ubuntu /home/ubuntu/.ssh >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Set custom host name
hostnamectl set-hostname ${CODE_SERVER_DNS}

echo "[$(date -u)] Setup completed" >> ${CODE_SERVER_LOGS}/setup.log
