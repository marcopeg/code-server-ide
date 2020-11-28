#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Setup Traefik
###

mkdir -p ${CODE_SERVER_TRAEFIK}
echo "[$(date -u)] Traefik files are stored in: ${CODE_SERVER_TRAEFIK}" >> ${CODE_SERVER_LOG}
