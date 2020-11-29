#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### NVM
### https://github.com/nvm-sh/nvm#installing-and-updating
###
### It adds the aliases to the system bashrc as the home one is not
### yet available for the user.
###

export NVM_VERSION=$(curl --silent https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq .name -r)
export NVM_DIR=/home/ubuntu/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo $'\n\n# NVM' >> /etc/bash.bashrc
echo $'export NVM_DIR="/home/ubuntu/.nvm"' >> /etc/bash.bashrc
echo $'[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /etc/bash.bashrc
echo $'[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /etc/bash.bashrc
source /etc/bash.bashrc  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
nvm -v  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
nvm install --lts >> ${CODE_SERVER_LOGS}/setup.log 2>&1
node -v >> ${CODE_SERVER_LOGS}/setup.log 2>&1
npm -v >> ${CODE_SERVER_LOGS}/setup.log 2>&1
