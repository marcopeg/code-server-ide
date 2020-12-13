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

# Generate the password into an .htpasswd file for the ide:
echo "[$(date -u)] Writing Simple Auth .htpasswd..." >> ${CODE_SERVER_LOGS}/setup.log
touch ${CODE_SERVER_CWD}/data/.htpasswd
htpasswd -b -c ${CODE_SERVER_CWD}/data/.htpasswd ${SIMPLE_AUTH_USERNAME} ${SIMPLE_AUTH_PASSWORD} >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Generate default auth/passwd
echo "[$(date -u)] Writing Auth/passwd default password..." >> ${CODE_SERVER_LOGS}/setup.log
touch ${CODE_SERVER_DATA}/passwd >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo "admin" > ${CODE_SERVER_DATA}/passwd

echo "[$(date -u)] Setup completed" >> ${CODE_SERVER_LOGS}/setup.log
