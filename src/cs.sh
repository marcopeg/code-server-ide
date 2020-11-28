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

# Collect main command from first argument,
# or present a graphic menu to the user
if [ -n "${1}" ]
then
    CMD=${1}
else
    PS3='Please enter your choice: '
    options=("Change password" "Update DNS entries on CloudFlare" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Change password")
                CMD=pwd
                break
                ;;
            "Update DNS entries on CloudFlare")
                CMD=dns
                break
                ;;
            "Cancel")
                CMD=cancel
                break
                ;;
        esac
    done
fi

case ${CMD} in
    "pwd")
        ${CODE_SERVER_CWD}/src/cs-pwd.sh ${@:2}
        ;;
    "dns")
        ${CODE_SERVER_CWD}/src/cs-dns.sh ${@:2}
        ;;
    "cancel")
        echo "Goobye."
        exit
        ;;
    *) echo "invalid option";;
esac
