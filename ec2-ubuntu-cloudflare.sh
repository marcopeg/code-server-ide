# Calculate the CWD
# CWD="`dirname \"$0\"`"
# CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
#source /etc/bash.bashrc
set +o allexport

# Takes action only if the API KEY is set:
if [ -z "$CLOUDFLARE_API_KEY" ]
then
  echo "Cloudflare API KEY is missing, abort."
  exit 0
fi

# Fallback on the VSCODE root DNS definition
CLOUDFLARE_DNS_NAME=${CLOUDFLARE_DNS_NAME:-"${VSCODE_DNS}"}
CLOUDFLARE_DNS_NAME_WILD="*.${CLOUDFLARE_DNS_NAME}"

# Default settings
CLOUDFLARE_DNS_TTL=${CLOUDFLARE_DNS_TTL:-120}
CLOUDFLARE_DNS_PRIORITY=${CLOUDFLARE_DNS_PRIORITY:-10}

# Get public IP:
PUBLIC_IP=$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/public-ipv4)
PUBLIC_IP=${PUBLIC_IP:-$(curl -s icanhazip.com)}
echo "PublicIP: ${PUBLIC_IP}"

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
  echo "UPDATE: ${DNS_ID}"
  UPDATE_QUERY=$(
    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${DNS_ID}" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -H "Content-Type: application/json" \
      --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME}'","content":"'${PUBLIC_IP}'","ttl":'${CLOUDFLARE_DNS_TTL}',"proxied":false}'
    )
  echo $(echo $UPDATE_QUERY | jq '.success')
else
  echo "CREATE"
  CREATE_QUERY=$(
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME}'","content":"'${PUBLIC_IP}'","ttl":'${CLOUDFLARE_DNS_TTL}',"priority":'${CLOUDFLARE_DNS_PRIORITY}',"proxied":false}'
  )
  echo $(echo $CREATE_QUERY | jq '.success')
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
  echo "UPDATE: ${DNS_ID}"
  UPDATE_QUERY=$(
    curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records/${DNS_ID}" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -H "Content-Type: application/json" \
      --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME_WILD}'","content":"'${PUBLIC_IP}'","ttl":'${CLOUDFLARE_DNS_TTL}',"proxied":false}'
    )
  echo $(echo $UPDATE_QUERY | jq '.success')
else
  echo "CREATE"
  CREATE_QUERY=$(
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'${CLOUDFLARE_DNS_NAME_WILD}'","content":"'${PUBLIC_IP}'","ttl":'${CLOUDFLARE_DNS_TTL}',"priority":'${CLOUDFLARE_DNS_PRIORITY}',"proxied":false}'
  )
  echo $(echo $CREATE_QUERY | jq '.success')
fi
