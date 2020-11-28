#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

###
### Send Welcome Email
###

if [ -n "$SENDGRID_API_KEY" ]
then
  RECEIVER_EMAIL=${SENDGRID_EMAIL:-${CODE_SERVER_EMAIL}}

  PUBLIC_IP=$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/public-ipv4)
  PUBLIC_IP=${PUBLIC_IP:-$(curl -s icanhazip.com)}

  CODE_SERVER_PASSWORD=$(sed '3q;d' ~/.config/code-server/config.yaml)
  CODE_SERVER_PASSWORD=${CODE_SERVER_PASSWORD:10}

  SIMPLE_AUTH_USERNAME=$(grep "Simple Auth Username" ${CODE_SERVER_LOGS}/setup.log | tail -1)
  SIMPLE_AUTH_USERNAME=${SIMPLE_AUTH_USERNAME:53}

  SIMPLE_AUTH_PASSWORD=$(grep "Simple Auth Password" ${CODE_SERVER_LOGS}/setup.log | tail -1)
  SIMPLE_AUTH_PASSWORD=${SIMPLE_AUTH_PASSWORD:53}

  curl --request POST \
    --url https://api.sendgrid.com/v3/mail/send \
    --header "Authorization: Bearer $SENDGRID_API_KEY" \
    --header 'Content-Type: application/json' \
    --data '{
      "personalizations": [{
          "to": [{"email": "'"${RECEIVER_EMAIL}"'"}]
      }],
      "from": {"email": "'"${RECEIVER_EMAIL}"'"},
      "subject": "Welcome to Code Server IDE",
      "content": [{
          "type": "text/plain", 
          "value": "Server IP: '"${PUBLIC_IP}"'\nServer DNS: https://'"${CODE_SERVER_DNS}"'\nSimple Auth Username: '"${SIMPLE_AUTH_USERNAME}"'\nSimple Auth Password: '"${SIMPLE_AUTH_PASSWORD}"'\nCode Server Password: '"${CODE_SERVER_PASSWORD}"'"
      }]}'
fi