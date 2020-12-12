#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/.env"
set +o allexport

# Collect command line arguments:
while [ "$#" -ne 0 ] ; do
  case "$1" in
    ide|netdata)
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
  echo "Which service do you feel like restarting?"
  PS3='Pick a number:'
  options=("Code Server IDE" "NetData")
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
      *) echo "invalid option";;
    esac
  done
fi

case ${CMD} in
  "ide")
    echo "Restarting IDE..."
    echo "[$(date -u)] Restarting IDE" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml stop code-server traefik >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml rm -f code-server traefik >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    sudo systemctl start code-server-ide >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d traefik code-server >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo ""
    echo "Code Server IDE will be available shortly at:"
    echo "https://${CODE_SERVER_DNS}"
    echo ""
    echo "Traefik (reverse proxy) dashboard will be available at:"
    echo "https://${CODE_SERVER_DNS}/traefik/"
    ;;
  "netdata")
    echo "Restarting NetData..."
    echo "[$(date -u)] Restarting NetData" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml stop netdata >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml rm -f netdata >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d netdata >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo ""
    echo "NetData will be available shortly at:"
    echo "https://${CODE_SERVER_DNS}/netdata/"
    ;;
  *) echo "invalid option";;
esac

