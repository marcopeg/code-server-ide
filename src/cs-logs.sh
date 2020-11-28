#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/.env"
set +o allexport

# Collect main command from first argument,
# or present a graphic menu to the user
if [ -n "${1}" ]
then
    CMD=${1}
else
    PS3='What logs do you like to read?'
    options=("Docker" "NGiNX" "Traefik" "IDE Setup logs" "IDE Boot logs" "CloudFlare DNS Updates" "CLI Invocation logs")
    select opt in "${options[@]}"
    do
        case $opt in
            "Docker")
                CMD=docker
                break
                ;;
            "NGiNX")
                CMD=nginx
                break
                ;;
            "Traefik")
                CMD=traefik
                break
                ;;
            "IDE Setup logs")
                CMD=setup
                break
                ;;
            "IDE Boot logs")
                CMD=boot
                break
                ;;
            "CloudFlare DNS Updates")
                CMD=cloudflare
                break
                ;;
            "CLI Invocation logs")
                CMD=cs
                break
                ;;
            *) echo "invalid option";;
        esac
    done
fi

case ${CMD} in
    "docker")
        (cd ${CODE_SERVER_CWD} && humble logs -f ${@:2})
        ;;
    "nginx")
        (cd ${CODE_SERVER_CWD} && humble logs -f nginx ${@:2})
        ;;
    "traefik")
        (cd ${CODE_SERVER_CWD} && humble logs -f traefik ${@:2})
        ;;
    "setup")
        tail ${@:2} ${CODE_SERVER_LOGS}/${CMD}.log
        ;;
    "boot")
        tail ${@:2} ${CODE_SERVER_LOGS}/${CMD}.log
        ;;
    "cs")
        tail ${@:2} ${CODE_SERVER_LOGS}/${CMD}.log
        ;;
    "cloudflare")
        tail ${@:2} ${CODE_SERVER_LOGS}/${CMD}.log
        ;;
    *) echo "invalid option";;
esac

