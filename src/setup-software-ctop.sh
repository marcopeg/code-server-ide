#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Install CTOP
### https://github.com/bcicen/ctop
### (on Ubuntu)
###

echo "deb http://packages.azlux.fr/debian/ buster main" | tee /etc/apt/sources.list.d/azlux.list >> ${CODE_SERVER_LOGS}/setup.log 2>&1
wget -qO - https://azlux.fr/repo.gpg.key | apt-key add - >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt update >> ${CODE_SERVER_LOGS}/setup.log 2>&1
apt install docker-ctop >> ${CODE_SERVER_LOGS}/setup.log 2>&1