#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Setup htaccess ACL
###

# Generate the password into an htpasswd file for the ide
htpasswd -b -c ${CODE_SERVER_CWD}/data/.htpasswd ${SIMPLE_AUTH_USERNAME} ${SIMPLE_AUTH_PASSWORD}
echo "[$(date -u)] VSCode ACL is store in: ${CODE_SERVER_CWD}/data/.htpasswd" >> ${CODE_SERVER_LOG}
echo "[$(date -u)] Simple Auth Username: ${SIMPLE_AUTH_USERNAME}" >> ${CODE_SERVER_LOG}
echo "[$(date -u)] Simple Auth Password: ${SIMPLE_AUTH_PASSWORD}" >> ${CODE_SERVER_LOG}
