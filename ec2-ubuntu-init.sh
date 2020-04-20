#!/bin/bash

# Setup your IDE:
export VSCODE_DNS="t4.marcopeg.com"
export VSCODE_PASSWORD="admin"
export VSCODE_CWD="/home/ubuntu/vscode-ide"

# Setup Cloudflare for DNS update:
# (optional)
export CLOUDFLARE_API_KEY=""
export CLOUDFLARE_ZONE_ID=""

# Clone the repo and run the install script:
git clone https://github.com/marcopeg/vscode-server-ide.git ${VSCODE_CWD}
${VSCODE_CWD}/ec2-ubuntu-setup.sh
${VSCODE_CWD}/cloudflare-dns-update.sh
${VSCODE_CWD}/ec2-ubuntu-boot.sh
