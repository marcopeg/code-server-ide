#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Install basic utilities that are needed by the system
###

apt-get update -y
apt-get install jq apache2-utils -y
