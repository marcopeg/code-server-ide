#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### AWS CLI
### https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
###

echo "[$(date -u)] Installing AWS CLI v2..." >> ${CODE_SERVER_LOGS}/setup.log
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" >> ${CODE_SERVER_LOGS}/setup.log 2>&1
unzip awscliv2.zip >> ${CODE_SERVER_LOGS}/setup.log 2>&1
./aws/install >> ${CODE_SERVER_LOGS}/setup.log 2>&1
echo "AWS CLI $(aws --version)" >> ${CODE_SERVER_LOGS}/setup.log

# Cleanup
rm -rf ./aws
rm -f ./awscliv2.zip
