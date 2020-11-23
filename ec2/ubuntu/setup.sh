#!/bin/bash

# Basic utilities
apt-get update -y
apt-get install jq apache2-utils -y

# Basic variables
CODE_SERVER_LOGS=${CODE_SERVER_CWD}/logs
CODE_SERVER_LOG=${CODE_SERVER_LOGS}/setup.txt

# Setup logs
mkdir -p ${CODE_SERVER_LOGS}
touch ${CODE_SERVER_LOG}
echo $(date -u) "Warming up..." >> ${CODE_SERVER_LOG}
