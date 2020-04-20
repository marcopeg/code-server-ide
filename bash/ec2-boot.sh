#!/bin/bash

# Setup your IDE:
export VSCODE_CWD=/home/ubuntu/vscode-ide
export VSCODE_PASSWORD=admin
export VSCODE_DNS=t3.marcopeg.com

# Clone the repo and run the install script:
git clone https://github.com/marcopeg/vscode-server-ide.git ${VSCODE_CWD}
${VSCODE_CWD}/bash/ec2-setup.sh
