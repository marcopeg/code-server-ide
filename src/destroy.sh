#!/bin/bash

source "$(dirname "$0")/profile.sh"

# Remove the entire data folder
rm -rf $CODE_SERVER_DATA

# Remove CodeServer service file
rm -f /lib/systemd/system/code-server-ide.service
