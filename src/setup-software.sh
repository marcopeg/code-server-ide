#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### NVM
### https://github.com/nvm-sh/nvm#installing-and-updating
###

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
source /home/ubuntu/.bashrc  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
nvm -v  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
