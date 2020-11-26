#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup ENV File
###

echo "[$(date -u)] Create env file..." >> ${CODE_SERVER_LOG}
touch ${CODE_SERVER_CWD}/.env
echo "# Code Server IDE Configuration" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_CWD=${CODE_SERVER_CWD}" >> ${CODE_SERVER_CWD}/.env
echo $'[OK]\n' >> ${CODE_SERVER_LOG}
