#!/bin/bash

###
### Install Docker on Ubuntu
###

source "$(dirname "$0")/profile.sh"

# Get OS major version
# (Docker depends on this)
OSV=$(cut -f2 <<< $(lsb_release -r))
OSV=${OSV%.*}

echo ${OSV}
echo ${CODE_SERVER_LOG}

# if [ "${OSV}" -eq "20" ]
# then
#     echo "[$(date -u)] Install Docker for Ubuntu 20.x..." >> ${CODE_SERVER_LOG}
#     apt install -y docker.io
#     systemctl enable --now docker
#     usermod -aG docker ubuntu
# fi

# if [ "${OSV}" -lt "20" ]
# then
#     echo "[$(date -u)] Install Docker for Ubuntu (16/18/19).x..." >> ${CODE_SERVER_LOG}
#     apt update -y
#     apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
#     echo "> update apt-get" >> ${VSCODE_LOG}
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
#     # add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
#     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#     apt update -y
#     echo "> run install script" >> ${VSCODE_LOG}
#     apt -y install docker-ce docker-ce-cli containerd.io
#     # apt-cache policy docker-ce
#     # apt install docker-ce
#     usermod -aG docker ubuntu
# fi

# echo $'[OK]\n' >> ${CODE_SERVER_LOG}

