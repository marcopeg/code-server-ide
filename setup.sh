#!/bin/bash

# Setup your IDE:
export CODE_SERVER_CWD="/home/ubuntu/.code-server-ide"

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD}
${CODE_SERVER_CWD}/ec2/ubuntu/setup.sh
