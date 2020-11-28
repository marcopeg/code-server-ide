#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Install Docker, Docker Compose, and HumbleCLI
### (on Ubuntu)
###

#
# Docker Engine
#
DOCKER_CMD=$(which docker)
if [ -z "${DOCKER_CMD}" ]
then

  if [ "${CODE_SERVER_OSV}" -eq "20" ]
  then
      echo "[$(date -u)] Install Docker for Ubuntu 20.x..." >> ${CODE_SERVER_LOGS}/setup.log
      apt install -y docker.io >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      systemctl enable --now docker >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      usermod -aG docker ubuntu >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  fi

  if [ "${CODE_SERVER_OSV}" -lt "20" ]
  then
      echo "[$(date -u)] Install Docker for Ubuntu (16/18/19).x..." >> ${CODE_SERVER_LOGS}/setup.log
      apt update -y >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      apt update -y >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      apt -y install docker-ce docker-ce-cli containerd.io >> ${CODE_SERVER_LOGS}/setup.log 2>&1
      # apt-cache policy docker-ce
      # apt install docker-ce
      usermod -aG docker ubuntu >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  fi  
  echo "[$(date -u)] $(docker -v) installed" >> ${CODE_SERVER_LOGS}/setup.log
else
  echo "[$(date -u)] Found $(docker -v) already installed" >> ${CODE_SERVER_LOGS}/setup.log
fi


#
# Cocker Compose
#
DOCKER_COMPOSE_CMD=$(which docker-compose)
if [ -z "${DOCKER_COMPOSE_CMD}" ]
then
  echo "[$(date -u)] Installing Docker Compose..." >> ${CODE_SERVER_LOGS}/setup.log
  DOCKER_COMPOSE_VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
  echo "[$(date -u)] Version: ${DOCKER_COMPOSE_VERSION}" >> ${CODE_SERVER_LOGS}/setup.log
  curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  chmod +x /usr/local/bin/docker-compose >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  echo "[$(date -u)] $(docker-compose -v) installed" >> ${CODE_SERVER_LOGS}/setup.log
else
  echo "[$(date -u)] Found $(docker-compose -v) already installed" >> ${CODE_SERVER_LOGS}/setup.log
fi

#
# Humble CLI
#
HUMBLE_CMD=$(which humble)
if [ -z "${HUMBLE_CMD}" ]
then
  echo "[$(date -u)] Install HumbleCLI..." >> ${CODE_SERVER_LOGS}/setup.log
  git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  echo "[$(date -u)] HumbleCLI was installed" >> ${CODE_SERVER_LOGS}/setup.log >> ${CODE_SERVER_LOGS}/setup.log 2>&1
else
  echo "[$(date -u)] Found HumbleCLI already installed" >> ${CODE_SERVER_LOGS}/setup.log
fi
