#!/bin/bash

CODE_SERVER_SETUP_SRC_CWD="$(dirname "$0")"

# Setup:
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-init.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-apt-get.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-env.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-bashrc.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-software-code-server.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-software-docker.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-software-ctop.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-software-nvm.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-software-dotnet.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-software-aws-cli.sh"
source "${CODE_SERVER_SETUP_SRC_CWD}/setup-final.sh"

# First boot:
# source "${CODE_SERVER_SETUP_SRC_CWD}/ec2-ubuntu-boot.sh"
