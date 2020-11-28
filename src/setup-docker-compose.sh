#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Setup DockerCompose
###

echo "[$(date -u)] Pulling images..." >> ${CODE_SERVER_LOGS}/setup.log
docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml pull >> ${CODE_SERVER_LOGS}/setup.log 2>&1
