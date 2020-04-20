#!/bin/bash

# Setup your IDE:
export VSCODE_DNS="t4.marcopeg.com"
export VSCODE_PASSWORD="admin"
export VSCODE_CWD="/home/ubuntu/vscode-ide"

# Clone the repo and run the install script:
git clone https://github.com/marcopeg/vscode-server-ide.git ${VSCODE_CWD}
${VSCODE_CWD}/bash/ec2-setup.sh
