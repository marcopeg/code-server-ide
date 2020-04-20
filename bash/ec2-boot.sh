#!/bin/bash

export VSCODE_CWD=/home/ubuntu/vscode-ide
export VSCODE_PASSWORD=admin

# Clone the repo and run the install script
git clone https://github.com/marcopeg/vscode-server-ide.git ${VSCODE_CWD}
${VSCODE_CWD}/bash/ec2-setup.sh
