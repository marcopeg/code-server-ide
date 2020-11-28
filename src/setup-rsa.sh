#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Setup RSA
###

echo "[$(date -u)] Create id_rsa file..." >> ${CODE_SERVER_LOG}
mkdir -p /home/ubuntu/.ssh
chown ubuntu -R  /home/ubuntu/.ssh
ssh-keygen -f /home/ubuntu/.ssh/id_rsa -t rsa -N ''
cat /home/ubuntu/.ssh/id_rsa.pub >> ${CODE_SERVER_LOG}
echo $'[OK]\n' >> ${CODE_SERVER_LOG}

