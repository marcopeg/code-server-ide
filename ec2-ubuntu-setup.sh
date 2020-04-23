#!/bin/bash
apt-get update -y
apt-get install jq apache2-utils -y

#
# Setup Environment Variables
#
VSCODE_CWD=${VSCODE_CWD:-"/home/ubuntu/vscode-ide"}
VSCODE_LOG=${VSCODE_CWD}.log
VSCODE_DATA=${VSCODE_CWD}/data

# Generate random access credentials
VSCODE_USERNAME=${VSCODE_USERNAME:-admin}
VSCODE_PASSWORD=${VSCODE_USERNAME:-$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)}


# Setup the CWD and assign it to the user "ubuntu"
mkdir -p ${VSCODE_DATA}
chown ubuntu -R ${VSCODE_CWD}
chown ubuntu -R ${VSCODE_DATA}

# Generate the install log file
touch ${VSCODE_LOG}
echo "CWD: ${VSCODE_CWD}" >> ${VSCODE_LOG}
echo $'\n' >> ${VSCODE_LOG}

echo "Basic Auth:" >> ${VSCODE_LOG}
echo "USERNAME: ${VSCODE_USERNAME}" >> ${VSCODE_LOG}
echo "PASSWORD: ${VSCODE_PASSWORD}" >> ${VSCODE_LOG}
echo $'\n' >> ${VSCODE_LOG}

#
# Install Docker
# (latest version)
#
echo "Install Docker..." >> ${VSCODE_LOG}
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo "> update apt-get" >> ${VSCODE_LOG}
apt-get update -y
apt-cache policy docker-ce
echo "> run install script" >> ${VSCODE_LOG}
apt-get install -y docker-ce
usermod -aG docker ubuntu
echo $'[OK]\n' >> ${VSCODE_LOG}



#
# Docker Compose
# (latest version)
#
echo "Install Docker Compose..." >> ${VSCODE_LOG}
DOCKER_COMPOSE_VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose
echo $'[OK]\n' >> ${VSCODE_LOG}



#
# Humble CLI
#
echo "Install HumbleCLI..." >> ${VSCODE_LOG}
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble
echo $'[OK]\n' >> ${VSCODE_LOG}



#
# Code Server
#
echo "Install Code Server..." >> ${VSCODE_LOG}
VSCODE_VERSION=$(curl --silent https://api.github.com/repos/cdr/code-server/releases/latest | jq .name -r)
VSCODE_INSTALL_FILES=${VSCODE_DATA}/code-server-src
VSCODE_XXX_DATA=${VSCODE_DATA}/code-server-data

# Ensure the directory for the source files exists
mkdir -p ${VSCODE_INSTALL_FILES}
chown ubuntu ${VSCODE_INSTALL_FILES}

# Download & Extract
if [ ! -d "${VSCODE_INSTALL_FILES}/code-server-${VSCODE_VERSION}-linux-x86_64" ]; then
  echo "> download sources" >> ${VSCODE_LOG}
  wget https://github.com/cdr/code-server/releases/download/${VSCODE_VERSION}/code-server-${VSCODE_VERSION}-linux-x86_64.tar.gz -P ${VSCODE_INSTALL_FILES}
  tar -xzvf ${VSCODE_INSTALL_FILES}/code-server-${VSCODE_VERSION}-linux-x86_64.tar.gz --directory ${VSCODE_INSTALL_FILES}
fi

# Install command from the downloaded version
# cd code-server-${VSCODE_VERSION}-linux-x86_64
echo "> copy files" >> ${VSCODE_LOG}
rm -f /usr/bin/code-server
rm -rf /usr/lib/code-server
cp -R ${VSCODE_INSTALL_FILES}/code-server-${VSCODE_VERSION}-linux-x86_64 /usr/lib/code-server
ln -s /usr/lib/code-server/code-server /usr/bin/code-server

# Prepare the data folder
if [ ! -f "${VSCODE_XXX_DATA}" ]; then
  mkdir -p ${VSCODE_XXX_DATA}
  chown ubuntu ${VSCODE_XXX_DATA}
fi

# Replace the service file
echo "> install service" >> ${VSCODE_LOG}
rm -f /lib/systemd/system/code-server.service
tee -a /lib/systemd/system/code-server.service > /dev/null <<EOT
[Unit]
Description=code-server
After=nginx.service

[Service]
User=ubuntu
Type=simple
Environment=SHELL=/bin/bash
ExecStart=/usr/bin/code-server --host 0.0.0.0 --user-data-dir ${VSCODE_XXX_DATA} --auth none
Restart=always

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
echo $'* VSCode files are stored in: ${VSCODE_XXX_DATA}' >> ${VSCODE_LOG}
echo $'[OK]\n' >> ${VSCODE_LOG}


#
# Traefik & IDE Compose setup
#
echo "Setup traefik data..." >> ${VSCODE_LOG}
TRAEFIK_DATA=${VSCODE_CWD}/data/traefik-data

# Ensure the directory for the source files exists
mkdir -p ${TRAEFIK_DATA}
chown ubuntu ${TRAEFIK_DATA}

# Generate the password into an htpasswd file for the ide
htpasswd -b -c ${VSCODE_CWD}/data/.htpasswd ${VSCODE_USERNAME} ${VSCODE_PASSWORD}
echo $'* Traefik files are stored in: ${TRAEFIK_DATA}' >> ${VSCODE_LOG}
echo $'[OK]\n' >> ${VSCODE_LOG}


#
# Create .env file
#
echo "Create env file..." >> ${VSCODE_LOG}
touch ${VSCODE_CWD}/.env
echo "# IDE Configuration" >> ${VSCODE_CWD}/.env
echo "VSCODE_CWD=${VSCODE_CWD}" >> ${VSCODE_CWD}/.env
echo "VSCODE_DNS=${VSCODE_DNS}" >> ${VSCODE_CWD}/.env
echo "VSCODE_EMAIL=${VSCODE_EMAIL:-"vscode@vscode.com"}" >> ${VSCODE_CWD}/.env
echo "" >> ${VSCODE_CWD}/.env
echo "# Cloudflare Integration" >> ${VSCODE_CWD}/.env
echo "CLOUDFLARE_API_KEY=${CLOUDFLARE_API_KEY}" >> ${VSCODE_CWD}/.env
echo "CLOUDFLARE_ZONE_ID=${CLOUDFLARE_ZONE_ID}" >> ${VSCODE_CWD}/.env
echo "CLOUDFLARE_DNS_NAME=*.${VSCODE_DNS}" >> ${VSCODE_CWD}/.env
echo $'[OK]\n' >> ${VSCODE_LOG}


#
# Create id_rsa
#
echo "Create id_rsa file..." >> ${VSCODE_LOG}
mkdir -p ${VSCODE_DATA}/.ssh
chown ubuntu -R  ${VSCODE_DATA}/.ssh

ssh-keygen -f ${VSCODE_DATA}/.ssh/id_rsa -t rsa -N ''
cat ${VSCODE_DATA}/.ssh/id_rsa.pub >> ${VSCODE_LOG}

#eval "$(ssh-agent -s)"
#ssh-add ${VSCODE_DATA}/.ssh/id_rsa
echo $'[OK]\n' >> ${VSCODE_LOG}

#
# Preload Images
#
echo "Pulling images..." >> ${VSCODE_LOG}
docker-compose -f ${VSCODE_CWD}/docker-compose.yml pull
echo $'[OK]\n' >> ${VSCODE_LOG}



#
# Install Boot Script
# (re-run services at boot time)
#
echo "Install boot script..." >> ${VSCODE_LOG}
touch /var/lib/cloud/scripts/per-boot/vscode-ide.sh
echo "#!/bin/bash" >> /var/lib/cloud/scripts/per-boot/vscode-ide.sh
echo "${VSCODE_CWD}/ec2-ubuntu-boot.sh" >> /var/lib/cloud/scripts/per-boot/vscode-ide.sh
chmod +x /var/lib/cloud/scripts/per-boot/vscode-ide.sh
echo $'[OK]\n' >> ${VSCODE_LOG}

echo $'IDE Setup completed :-)\n' >> ${VSCODE_LOG}
reboot
