#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/.env"
set +o allexport

# Prepare the logs file
touch ${CODE_SERVER_LOGS}/cs.log

if [ -n "${1}" ]
then
    USER=${1}
else
    echo "Please enter the username you want to set/change the password for:"
    read USER
fi

if [ ! -n "${USER}" ]
then
    echo "You must provide a valid username."
    echo "Abort!"
    exit
fi

echo "Changing password for user: ${USER}..."
echo ">> Please count to 20, then reload the IDE"
echo "[$(date -u)] Changing password for ${USER}" >> ${CODE_SERVER_LOGS}/cs.log
htpasswd ${CODE_SERVER_CWD}/data/.htpasswd ${USER}
docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d --force-recreate nginx
