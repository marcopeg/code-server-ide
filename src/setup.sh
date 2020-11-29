#!/bin/bash

CWD="$(dirname "$0")"

# Setup:
source "${CWD}/setup-init.sh"
source "${CWD}/setup-apt-get.sh"
source "${CWD}/setup-env.sh"
source "${CWD}/setup-bashrc.sh"
# source "${CWD}/setup-software-code-server.sh"
# source "${CWD}/setup-software-docker.sh"
# source "${CWD}/setup-software-nvm.sh"
source "${CWD}/setup-software-aws-cli.sh"
# source "${CWD}/setup-final.sh"

# First boot:
# source "${CWD}/ec2-ubuntu-boot.sh"
