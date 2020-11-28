#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Final steps and cleanup
###

chown ubuntu -R ${CODE_SERVER_CWD} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
chown -R ubuntu:ubuntu /home/ubuntu/.ssh >> ${CODE_SERVER_LOGS}/setup.log 2>&1

