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
    options=("Start IDE" "Stop IDE" "Restart IDE" "Get CodeServer Status" "Read logs" "Get info about this machine" "Change password" "Update DNS entries on CloudFlare" "Update Code Server IDE" "Manage proxies" "Cancel")
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
            "Get info about this machine")
                CMD=get
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
            "Manage proxies")
                CMD=proxy
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
        ${CODE_SERVER_CWD}/src/cs-start.sh ${@:2}
        ;;
    "stop")
        ${CODE_SERVER_CWD}/src/cs-stop.sh ${@:2}
        ;;
    "restart")
        ${CODE_SERVER_CWD}/src/cs-restart.sh ${@:2}
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
    "get")
        ${CODE_SERVER_CWD}/src/cs-get.sh ${@:2}
        ;;
    "update")
        echo "[$(date -u)] Updating IDE" >> ${CODE_SERVER_LOGS}/cs.log
        (cd ${CODE_SERVER_CWD} && git pull)
        ;;
    "proxy")
        ${CODE_SERVER_CWD}/src/cs-proxy.sh ${@:2}
        ;;
    "cancel")
        echo "Goobye."
        exit
        ;;
    *) echo "invalid option";;
esac
