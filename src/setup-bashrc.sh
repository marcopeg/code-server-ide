#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup ENV File
###

echo "[$(date -u)] Setup bashrc file..." >> ${CODE_SERVER_LOG}
echo $'\n\n# CODE SERVER IDE' >> /etc/bash.bashrc

# Export environment variables
echo "set -o allexport" >> /etc/bash.bashrc
echo "source ${CODE_SERVER_CWD}/.env" >> /etc/bash.bashrc
echo "set +o allexport" >> /etc/bash.bashrc
echo $'[OK]\n' >> ${CODE_SERVER_LOG}

# Load ssh agent
echo "eval \"\$(ssh-agent -s)\"" >> /etc/bash.bashrc
echo "ssh-add /home/ubuntu/.ssh/id_rsa" >> /etc/bash.bashrc

echo $'[OK]\n' >> ${CODE_SERVER_LOG}
