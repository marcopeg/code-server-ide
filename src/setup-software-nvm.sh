#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### NVM
### https://github.com/nvm-sh/nvm#installing-and-updating
###
### It adds the aliases to the system bashrc as the home one is not
### yet available for the user.
###

echo "[$(date -u)] Installing NVM..." >> ${CODE_SERVER_LOGS}/setup.log
# Configure the installation
export NVM_VERSION=$(curl --silent https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq .name -r)
export NVM_DIR=/home/ubuntu/.nvm

# Running installation script
echo "[$(date -u)] Version: ${NVM_VERSION}" >> ${CODE_SERVER_LOGS}/setup.log
mkdir -p ${NVM_DIR} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash >> ${CODE_SERVER_LOGS}/setup.log 2>&1
chown -R ubuntu:ubuntu ${NVM_DIR} >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Add the NVM bin stuff to the bash loading profile
echo $'\n\n# NVM' >> /etc/bash.bashrc
echo $'export NVM_DIR="/home/ubuntu/.nvm"' >> /etc/bash.bashrc
echo $'[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /etc/bash.bashrc
echo $'[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /etc/bash.bashrc

# Reload bash and test NVM
source ${NVM_DIR}/nvm.sh >> ${CODE_SERVER_LOGS}/setup.log 2>&1
nvm -v  >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Install latest Node LTS
echo "[$(date -u)] Installing lastest NodeJS (LTS)..." >> ${CODE_SERVER_LOGS}/setup.log
nvm install --lts >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo "NodeJS: $(node -v)" >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo "NPM: $(npm -v)" >> ${CODE_SERVER_LOGS}/setup.log 2>&1
