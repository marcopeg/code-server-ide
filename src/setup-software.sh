#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### NVM
### https://github.com/nvm-sh/nvm#installing-and-updating
###

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo $'\n\n# NVM' >> /etc/bash.bashrc
echo $'export NVM_DIR="$HOME/.nvm"' >> /etc/bash.bashrc
echo $'[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> /etc/bash.bashrc
echo $'[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /etc/bash.bashrc
source /etc/bash.bashrc  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
nvm -v  >> ${CODE_SERVER_LOGS}/setup.log 2>&1
