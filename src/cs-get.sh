#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/data/.env"
set +o allexport

# Prepare the logs file
touch ${CODE_SERVER_LOGS}/cs.log

# Collect main command from first argument,
# or present a graphic menu to the user
if [ -n "${1}" ]
then
    CMD=${1}
else
    PS3='What info do you need?'
    options=("Public IP" "EC2 InstanceID")
    select opt in "${options[@]}"
    do
        case $opt in
            "Public IP")
                CMD=ip
                break
                ;;
            "EC2 InstanceID")
                CMD=ec2-id
                break
                ;;
            "EC2 Host Name")
                CMD=ec2-host
                break
                ;;
            *) echo "invalid option";;
        esac
    done
fi

case ${CMD} in
    "ip")
        PUBLIC_IP=$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/public-ipv4)
        PUBLIC_IP=${PUBLIC_IP:-$(curl -s icanhazip.com)}
        echo ${PUBLIC_IP}
        ;;
    "ec2-id")
        EC2_ID=$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/instance-id)
        echo ${EC2_ID}
        ;;
    "ec2-host")
        EC2_HOST=$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/public-hostname)
        echo ${EC2_HOST}
        ;;
    *) echo "invalid option";;
esac


