#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Install Docker, Docker Compose, and HumbleCLI
### (on Ubuntu)
###

#
# Docker Engine
#
if [ "${CODE_SERVER_OSV}" -eq "20" ]
then
    echo "[$(date -u)] Install Docker for Ubuntu 20.x..." >> ${CODE_SERVER_LOG}
    apt install -y docker.io
    systemctl enable --now docker
    usermod -aG docker ubuntu
fi

if [ "${CODE_SERVER_OSV}" -lt "20" ]
then
    echo "[$(date -u)] Install Docker for Ubuntu (16/18/19).x..." >> ${CODE_SERVER_LOG}
    apt update -y
    apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    echo "> update apt-get" >> ${VSCODE_LOG}
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt update -y
    echo "> run install script" >> ${VSCODE_LOG}
    apt -y install docker-ce docker-ce-cli containerd.io
    # apt-cache policy docker-ce
    # apt install docker-ce
    usermod -aG docker ubuntu
fi
echo "[$(date -u)] $(docker -v)" >> ${CODE_SERVER_LOG}
echo $'[OK]\n' >> ${CODE_SERVER_LOG}

#
# Cocker Compose
#
echo "[$(date -u)] Install Docker Compose..." >> ${CODE_SERVER_LOG}
DOCKER_COMPOSE_VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
echo "[$(date -u)] Version: ${DOCKER_COMPOSE_VERSION}" >> ${CODE_SERVER_LOG}
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose
echo $'[OK]\n' >> ${CODE_SERVER_LOG}

#
# Humble CLI
#
echo "[$(date -u)] Install HumbleCLI..." >> ${CODE_SERVER_LOG}
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble
echo $'[OK]\n' >> ${CODE_SERVER_LOG}
