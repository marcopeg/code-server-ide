#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/data/.env"
set +o allexport

# Prepare the logs file
touch ${CODE_SERVER_LOGS}/cs.log

# Collect main command from first argument,
# or present a graphic menu to the user
if [ -n "${1}" ]
then
    CMD=${1}
else
    PS3='What action do you want to perform?'
    options=("Create or update DNS entries" "Remove existing DNS entries")
    select opt in "${options[@]}"
    do
        case $opt in
            "Create or update DNS entries")
                CMD=upsert
                break
                ;;
            "Remove existing DNS entries")
                CMD=remove
                break
                ;;
            *) echo "invalid option";;
        esac
    done
fi

case ${CMD} in
    "upsert")
        echo "[$(date -u)] Upsert CloudFlare DNS entry" >> ${CODE_SERVER_LOGS}/cs.log
        ${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare-upsert.sh
        ;;
    "remove")
        echo "[$(date -u)] Delete CloudFlare DNS entry" >> ${CODE_SERVER_LOGS}/cs.log
        ${CODE_SERVER_CWD}/src/ec2-ubuntu-dns-cloudflare-delete.sh
        ;;
    *) echo "invalid option";;
esac


