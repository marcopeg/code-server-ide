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

echo "[$(date -u)] Export environment variable at boot time..." >> ${CODE_SERVER_LOG}
echo $'\n\n# CODE SERVER IDE' >> /etc/bash.bashrc
echo "set -o allexport" >> /etc/bash.bashrc
echo "source ${CODE_SERVER_CWD}/.env" >> /etc/bash.bashrc
echo "set +o allexport" >> /etc/bash.bashrc