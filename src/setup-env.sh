#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup ENV File
###

echo "[$(date -u)] Create env file..." >> ${CODE_SERVER_LOG}
touch ${CODE_SERVER_CWD}/.env
echo "# Code Server IDE Configuration" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_CWD=${CODE_SERVER_CWD}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_DATA=${CODE_SERVER_DATA}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_LOGS=${CODE_SERVER_LOGS}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_TRAEFIK=${CODE_SERVER_TRAEFIK}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_DNS=${CODE_SERVER_DNS}" >> ${CODE_SERVER_CWD}/.env
echo "CODE_SERVER_EMAIL=${CODE_SERVER_EMAIL}" >> ${CODE_SERVER_CWD}/.env
echo "" >> ${CODE_SERVER_CWD}/.env
echo "# Cloudflare Configuration" >> ${CODE_SERVER_CWD}/.env
if [ -n "$CLOUDFLARE_ZONE_ID" ]
then
  echo "CLOUDFLARE_ZONE_ID=${CLOUDFLARE_ZONE_ID}" >> ${CODE_SERVER_CWD}/.env
fi
if [ -n "$CLOUDFLARE_API_KEY" ]
then
  echo "CLOUDFLARE_API_KEY=${CLOUDFLARE_API_KEY}" >> ${CODE_SERVER_CWD}/.env
fi
if [ -n "$CLOUDFLARE_DNS_NAME" ]
then
  echo "CLOUDFLARE_DNS_NAME=${CLOUDFLARE_DNS_NAME}" >> ${CODE_SERVER_CWD}/.env
fi
if [ -n "$CLOUDFLARE_DNS_TARGET" ]
then
  echo "CLOUDFLARE_DNS_TARGET=${CLOUDFLARE_DNS_TARGET}" >> ${CODE_SERVER_CWD}/.env
fi
if [ -n "$CLOUDFLARE_DNS_TTL" ]
then
  echo "CLOUDFLARE_DNS_TTL=${CLOUDFLARE_DNS_TTL}" >> ${CODE_SERVER_CWD}/.env
fi
if [ -n "$CLOUDFLARE_DNS_PRIORITY" ]
then
  echo "CLOUDFLARE_DNS_PRIORITY=${CLOUDFLARE_DNS_PRIORITY}" >> ${CODE_SERVER_CWD}/.env
fi

echo $'[OK]\n' >> ${CODE_SERVER_LOG}
