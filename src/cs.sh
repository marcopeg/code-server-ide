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
    options=("Start IDE" "Stop IDE" "Restart IDE" "Get CodeServer Status" "Read logs" "Change password" "Update DNS entries on CloudFlare" "Update Code Server IDE" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Start IDE")
                CMD=start
                break
                ;;
            "Stop IDE")
                CMD=stop
                break
                ;;
            "Restart IDE")
                CMD=restart
                break
                ;;
            "Get CodeServer Status")
                CMD=status
                break
                ;;
            "Read logs")
                CMD=logs
                break
                ;;
            "Change password")
                CMD=pwd
                break
                ;;
            "Update DNS entries on CloudFlare")
                CMD=dns
                break
                ;;
            "Update Code Server IDE")
                CMD=update
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
    "start")
        echo "[$(date -u)] Starting IDE" >> ${CODE_SERVER_LOGS}/cs.log
        sudo systemctl start code-server-ide
        docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d
        ;;
    "stop")
        echo "[$(date -u)] Stopping IDE" >> ${CODE_SERVER_LOGS}/cs.log
        docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml down
        sudo systemctl stop code-server-ide
        ;;
    "restart")
        echo "[$(date -u)] Stopping IDE" >> ${CODE_SERVER_LOGS}/cs.log
        docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml down
        sudo systemctl stop code-server-ide
        echo "[$(date -u)] Starting IDE" >> ${CODE_SERVER_LOGS}/cs.log
        sudo systemctl start code-server-ide
        docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d
        ;;
    "status")
        sudo systemctl status code-server-ide
        ;;
    "logs")
        ${CODE_SERVER_CWD}/src/cs-logs.sh ${@:2}
        ;;
    "dns")
        ${CODE_SERVER_CWD}/src/cs-dns.sh ${@:2}
        ;;
    "update")
        echo "[$(date -u)] Updating IDE" >> ${CODE_SERVER_LOGS}/cs.log
        (cd ${CODE_SERVER_CWD} && git pull)
        ;;
    "cancel")
        echo "Goobye."
        exit
        ;;
    *) echo "invalid option";;
esac
