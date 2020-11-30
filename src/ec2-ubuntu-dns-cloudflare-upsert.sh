#!/bin/bash

# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Takes action only if the API KEY is set:
if [ -n "$CLOUDFLARE_API_KEY" ]
then
  # Collecting settings:
  CLOUDFLARE_DNS_NAME=${CLOUDFLARE_DNS_NAME:-"${CODE_SERVER_DNS}"}
  CLOUDFLARE_DNS_NAME_WILD="*.${CLOUDFLARE_DNS_NAME}"
  CLOUDFLARE_DNS_TTL=${CLOUDFLARE_DNS_TTL:-120}
  CLOUDFLARE_DNS_PRIORITY=${CLOUDFLARE_DNS_PRIORITY:-10}

  # Setting up the target IP:
  PUBLIC_IP=$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/public-ipv4)
  PUBLIC_IP=${PUBLIC_IP:-$(curl -s icanhazip.com)}
  CLOUDFLARE_DNS_TARGET=${CLOUDFLARE_DNS_TARGET:-${PUBLIC_IP}}

  echo "[$(date -u)] Cloudflare: setup DNS for ${CLOUDFLARE_DNS_NAME} -> ${CLOUDFLARE_DNS_TARGET}" >> ${CODE_SERVER_LOGS}/setup.log

  #
  # STRAIGHT NAME
  # foo.domain.com
  #
  DNS_QUERY=$(
    curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records?name=${CLOUDFLARE_DNS_NAME}" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -H "Content-Type: application/json" \
    )

  if [ "$(echo $DNS_QUERY | jq '.result_info.total_count')" -gt 0 ]
  then
    DNS_ID=$(echo $DNS_QUERY | jq -r '.result[0].id')
    echo "[$(date -u)] Updating entry ${DNS_ID}: ${CLOUDFLARE_DNS_NAME} -> ${CLOUDFLARE_DNS_TARGET}..." >> ${CODE_SERVER_LOGS}/setup.log
    UPDATE_QUERY=$(
      curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${DNS_ID}" \
        -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME}'","content":"'${CLOUDFLARE_DNS_TARGET}'","ttl":'${CLOUDFLARE_DNS_TTL}',"proxied":false}'
      )
    echo "[$(date -u)] $(echo $UPDATE_QUERY | jq '.success')" >> ${CODE_SERVER_LOGS}/setup.log
  else
    echo "[$(date -u)] Creating entry: ${CLOUDFLARE_DNS_NAME} -> ${CLOUDFLARE_DNS_TARGET}..." >> ${CODE_SERVER_LOGS}/setup.log
    CREATE_QUERY=$(
    curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -H "Content-Type: application/json" \
      --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME}'","content":"'${CLOUDFLARE_DNS_TARGET}'","ttl":'${CLOUDFLARE_DNS_TTL}',"priority":'${CLOUDFLARE_DNS_PRIORITY}',"proxied":false}'
    )
    echo "[$(date -u)] $(echo $CREATE_QUERY | jq '.success')" >> ${CODE_SERVER_LOGS}/setup.log
  fi

  #
  # WILDCHAR
  # *.foo.domain.com
  #
  DNS_QUERY=$(
    curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records?name=${CLOUDFLARE_DNS_NAME_WILD}" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -H "Content-Type: application/json" \
    )

  if [ "$(echo $DNS_QUERY | jq '.result_info.total_count')" -gt 0 ]
  then
    DNS_ID=$(echo $DNS_QUERY | jq -r '.result[0].id')
    echo "[$(date -u)] Updating entry ${DNS_ID}: ${CLOUDFLARE_DNS_NAME_WILD} -> ${CLOUDFLARE_DNS_TARGET}..." >> ${CODE_SERVER_LOGS}/setup.log
    UPDATE_QUERY=$(
      curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${DNS_ID}" \
        -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME_WILD}'","content":"'${CLOUDFLARE_DNS_TARGET}'","ttl":'${CLOUDFLARE_DNS_TTL}',"proxied":false}'
      )
    echo "[$(date -u)] $(echo $UPDATE_QUERY | jq '.success')" >> ${CODE_SERVER_LOGS}/setup.log
  else
    echo "[$(date -u)] Creating entry: ${CLOUDFLARE_DNS_NAME_WILD} -> ${CLOUDFLARE_DNS_TARGET}..." >> ${CODE_SERVER_LOGS}/setup.log
    CREATE_QUERY=$(
    curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -H "Content-Type: application/json" \
      --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME_WILD}'","content":"'${CLOUDFLARE_DNS_TARGET}'","ttl":'${CLOUDFLARE_DNS_TTL}',"priority":'${CLOUDFLARE_DNS_PRIORITY}',"proxied":false}'
    )
    echo "[$(date -u)] $(echo $CREATE_QUERY | jq '.success')" >> ${CODE_SERVER_LOGS}/setup.log
  fi

fi




