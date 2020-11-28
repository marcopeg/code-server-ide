#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Final steps and cleanup
###

chown ubuntu -R ${CODE_SERVER_CWD}
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

