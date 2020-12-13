#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/.env"
set +o allexport

function up() {
  if [ -z ${PROXY_PORT+x} ] ; then
    echo "Which port do you want to proxy?"
    read PROXY_PORT
  fi
  
  echo "Running a proxy on port ${PROXY_PORT}" >> ${CODE_SERVER_LOGS}/cs.log
  docker run -d \
    --name csi-p${PROXY_PORT} \
    --network host \
    --restart on-failure \
    -e NGINX_PORT=5${PROXY_PORT} \
    -e NGINX_UPSTREAM_PORT=${PROXY_PORT} \
    -l traefik.enable=true \
    -l traefik.http.services.csi-p${PROXY_PORT}.loadbalancer.server.port=5${PROXY_PORT} \
    -l traefik.http.routers.csi-p${PROXY_PORT}--80.entrypoints=http80 \
    -l traefik.http.routers.csi-p${PROXY_PORT}--80.rule=Host\(\`p${PROXY_PORT}.${CODE_SERVER_DNS}\`\) \
    -l traefik.http.routers.csi-p${PROXY_PORT}--80.middlewares=csi-redirect \
    -l traefik.http.routers.csi-p${PROXY_PORT}--443.tls=true \
    -l traefik.http.routers.csi-p${PROXY_PORT}--443.entrypoints=http443 \
    -l traefik.http.routers.csi-p${PROXY_PORT}--443.tls.certresolver=letsencrypt \
    -l traefik.http.routers.csi-p${PROXY_PORT}--443.rule=Host\(\`p${PROXY_PORT}.${CODE_SERVER_DNS}\`\) \
    marcopeg/nginx-proxy:0.0.2 >> ${CODE_SERVER_LOGS}/cs.log 2>&1

  echo "New proxy to port ${PROXY_PORT} available at:"
  echo "https://p${PROXY_PORT}.${CODE_SERVER_DNS}"
  exit 0
}

function down() {
  if [ -z ${PROXY_PORT+x} ] ; then
    echo "Which proxy do you want to remove (type the proxy port)?"
    read PROXY_PORT
  fi

  echo "Removing proxy on port ${PROXY_PORT}" >> ${CODE_SERVER_LOGS}/cs.log
  docker stop csi-p${PROXY_PORT} >> ${CODE_SERVER_LOGS}/cs.log 2>&1
  docker rm csi-p${PROXY_PORT} >> ${CODE_SERVER_LOGS}/cs.log 2>&1

  echo "Proxy to port ${PROXY_PORT} successfully removed"
  exit 0
}

# Collect command line arguments:
while [ "$#" -ne 0 ] ; do
  case "$1" in
    up|down)
      CMD="$1"
      shift
      ;;
    -p|--port)
      PROXY_PORT="${2}"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Present the main menu:
if [ -z ${CMD+x} ]
then
  PS3='Please pick a choice:'
  options=("Start a new proxy" "Kill and existing proxy")
  select opt in "${options[@]}"
  do
    case $opt in
      "Start a new proxy")
        CMD=up
        break
        ;;
      "Kill and existing proxy")
        CMD=down
        break
        ;;
      *) echo "invalid option";;
    esac
  done
fi

case ${CMD} in
    "up")
        up ${@:2}
        ;;
    "down")
        down ${@:2}
        ;;
    *) echo "invalid option";;
esac

