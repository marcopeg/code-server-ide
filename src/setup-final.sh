#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Final steps and cleanup
###

chown -R ubuntu:ubuntu ${CODE_SERVER_CWD} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
chown -R ubuntu:ubuntu /home/ubuntu/.ssh >> ${CODE_SERVER_LOGS}/setup.log 2>&1

echo "[$(date -u)] Setup completed" >> ${CODE_SERVER_LOGS}/setup.log
