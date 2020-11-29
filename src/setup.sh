#!/bin/bash

CWD="$(dirname "$0")"

# Setup:
source "${CWD}/setup-init.sh"
source "${CWD}/setup-apt-get.sh"
source "${CWD}/setup-env.sh"
source "${CWD}/setup-bashrc.sh"
source "${CWD}/setup-software.sh"
# source "${CWD}/setup-code-server.sh"
# source "${CWD}/setup-docker.sh"
# source "${CWD}/setup-docker-compose.sh"
# source "${CWD}/setup-final.sh"

# First boot:
# source "${CWD}/ec2-ubuntu-boot.sh"
