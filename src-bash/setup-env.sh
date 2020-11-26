#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup ENV File
###

echo "[$(date -u)] Create env file..." >> ${CODE_SERVER_LOG}
touch ${CODE_SERVER_CWD}/.env
echo "# Code Server IDE Configuration" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_CWD=${CODE_SERVER_CWD}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_DATA=${CODE_SERVER_DATA}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_LOGS=${CODE_SERVER_LOGS}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_TRAEFIK=${CODE_SERVER_TRAEFIK}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_DNS=${CODE_SERVER_DNS}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_EMAIL=${CODE_SERVER_EMAIL}" >> ${CODE_SERVER_CWD}/.env
echo $'[OK]\n' >> ${CODE_SERVER_LOG}
