#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Install basic utilities that are needed by the system
###

echo "[$(date -u)] Updating apt-get..." >> ${CODE_SERVER_LOGS}/setup.log
apt-get update -y >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo "[$(date -u)] Installing basic utilities via apt-get..." >> ${CODE_SERVER_LOGS}/setup.log
apt-get install jq apache2-utils unzip -y >> ${CODE_SERVER_LOGS}/setup.log 2>&1
