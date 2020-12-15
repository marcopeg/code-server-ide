#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/data/.env"
set +o allexport

# Collect command line arguments:
while [ "$#" -ne 0 ] ; do
  case "$1" in
    ide|netdata|filebrowser)
      CMD="$1"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Present the main menu:
if [ -z ${CMD+x} ]
then
  echo "Which service do you feel like starting?"
  PS3='Pick a number:'
  options=("Code Server IDE" "NetData" "FileBrowser")
  select opt in "${options[@]}"
  do
    case $opt in
      "Code Server IDE")
        CMD=ide
        break
        ;;
      "NetData")
        CMD=netdata
        break
        ;;
      "FileBrowser")
        CMD=filebrowser
        break
        ;;
      *) echo "invalid option";;
    esac
  done
fi

case ${CMD} in
  "ide")
    echo "Starting IDE..."
    echo "[$(date -u)] Starting IDE" >> ${CODE_SERVER_LOGS}/cs.log
    sudo systemctl start code-server-ide >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d traefik auth-passwd code-server >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo ""
    echo "Code Server IDE will be available shortly at:"
    echo "https://${CODE_SERVER_DNS}"
    echo ""
    echo "Traefik (reverse proxy) dashboard will be available at:"
    echo "https://${CODE_SERVER_DNS}/traefik/"
    ;;
  "netdata")
    echo "Starting NetData..."
    echo "[$(date -u)] Starting NetData" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d netdata >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo ""
    echo "NetData will be available shortly at:"
    echo "https://${CODE_SERVER_DNS}/netdata/"
    ;;
  "filebrowser")
    echo "Starting Filebrowser..."
    echo "[$(date -u)] Starting Filebrowser" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d filebrowser >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo ""
    echo "Filebrowser will be available shortly at:"
    echo "https://${CODE_SERVER_DNS}/filebrowser/"
    ;;
  *) echo "invalid option";;
esac

