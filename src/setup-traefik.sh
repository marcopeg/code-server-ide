#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup Traefik
###

mkdir -p ${TRAEFIK_DATA}
echo "[$(date -u)] Traefik files are stored in: ${CODE_SERVER_TRAEFIK}" >> ${CODE_SERVER_LOG}
