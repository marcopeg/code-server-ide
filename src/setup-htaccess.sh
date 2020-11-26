#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup htaccess ACL
###

# Generate random access credentials
CODE_SERVER_USERNAME=${CODE_SERVER_USERNAME:-admin}
CODE_SERVER_PASSWORD=${CODE_SERVER_USERNAME:-$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)}

# Generate the password into an htpasswd file for the ide
htpasswd -b -c ${CODE_SERVER_CWD}/data/.htpasswd ${CODE_SERVER_USERNAME} ${CODE_SERVER_PASSWORD}
echo "[$(date -u)] VSCode ACL is store in: ${CODE_SERVER_CWD}/data/.htpasswd" >> ${CODE_SERVER_LOG}
echo "[$(date -u)] Username: ${CODE_SERVER_USERNAME}" >> ${CODE_SERVER_LOG}
echo "[$(date -u)] Password: ${CODE_SERVER_PASSWORD}" >> ${CODE_SERVER_LOG}
