#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

# Remove the entire data folder
rm -rf ${CODE_SERVER_CWD}/data
rm -rf $CODE_SERVER_LOGS

# Remove CodeServer service file
rm -f /lib/systemd/system/code-server-ide.service
