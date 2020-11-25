#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Final steps and cleanup
###

chown ubuntu -R ${CODE_SERVER_CWD}
