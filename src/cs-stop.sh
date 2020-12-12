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
  echo "Which service do you feel like stopping?"
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
    echo "[$(date -u)] Stopping IDE..."
    echo "[$(date -u)] Stopping IDE" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml stop code-server traefik >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml rm -f code-server traefik >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    sudo systemctl stop code-server-ide >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo "done!"
    ;;
  "netdata")
    echo "[$(date -u)] Stopping NetData..."
    echo "[$(date -u)] Stopping NetData" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml stop netdata >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml rm -f netdata >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo "done!"
    ;;
  "filebrowser")
    echo "[$(date -u)] Stopping Filebrowser..."
    echo "[$(date -u)] Stopping Filebrowser" >> ${CODE_SERVER_LOGS}/cs.log
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml stop filebrowser >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml rm -f filebrowser >> ${CODE_SERVER_LOGS}/cs.log 2>&1
    echo "done!"
    ;;
  *) echo "invalid option";;
esac

