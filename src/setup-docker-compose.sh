#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup DockerCompose
###

echo "[$(date -u)] Pulling images..." >> ${CODE_SERVER_LOG}
docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml pull
echo $'[OK]\n' >> ${CODE_SERVER_LOG}
