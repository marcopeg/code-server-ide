#!/bin/bash
apt-get update -y
apt-get install jq apache2-utils -y

VSCODE_ROOT=/home/ubuntu/vscode-ide


# Generate random access credentials
#VSCODE_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)
VSCODE_USERNAME=foo
VSCODE_PASSWORD=bar

# Generate the install log
touch ${VSCODE_ROOT}/install.log
echo "USERNAME: ${VSCODE_USERNAME}" >> ${VSCODE_ROOT}/install.log
echo "PASSWORD: ${VSCODE_PASSWORD}" >> ${VSCODE_ROOT}/install.log
echo "CWD: $(pwd)" >> ${VSCODE_ROOT}/install.log


#
# Install Docker
#
echo "Install Docker..." >> ${VSCODE_ROOT}/install.log
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-cache policy docker-ce
apt-get install -y docker-ce
usermod -aG docker ubuntu
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log



#
# Docker Compose (latest version)
#
echo "Install Docker Compose..." >> ${VSCODE_ROOT}/install.log
DOCKER_COMPOSE_VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log



#
# Humble CLI (need to fix the -y compatibility)
#
echo "Install HumbleCLI..." >> ${VSCODE_ROOT}/install.log
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log



#
# Code Server
#
echo "Install Code Server..." >> ${VSCODE_ROOT}/install.log
VSCODE_VERSION=$(curl --silent https://api.github.com/repos/cdr/code-server/releases/latest | jq .name -r)
VSCODE_SRC=${VSCODE_ROOT}/code-server
VSCODE_DATA=/var/lib/code-server

# Ensure the directory for the source files exists
mkdir -p ${VSCODE_SRC}

# Download & Extract
if [ ! -d "${VSCODE_SRC}/code-server-${VSCODE_VERSION}-linux-x86_64" ]; then
  echo "> download sources" >> ${VSCODE_ROOT}/install.log
  wget https://github.com/cdr/code-server/releases/download/${VSCODE_VERSION}/code-server-${VSCODE_VERSION}-linux-x86_64.tar.gz -P ${VSCODE_SRC}
  tar -xzvf ${VSCODE_SRC}/code-server-${VSCODE_VERSION}-linux-x86_64.tar.gz --directory ${VSCODE_SRC}
fi

# Install command from the downloaded version
# cd code-server-${VSCODE_VERSION}-linux-x86_64
echo "> copy files" >> ${VSCODE_ROOT}/install.log
rm -f /usr/bin/code-server
rm -rf /usr/lib/code-server
cp -R ${VSCODE_SRC}/code-server-${VSCODE_VERSION}-linux-x86_64 /usr/lib/code-server
ln -s /usr/lib/code-server/code-server /usr/bin/code-server

# Prepare the data folder
if [ ! -f "${VSCODE_DATA}" ]; then
  mkdir -p ${VSCODE_DATA}
  chown ubuntu ${VSCODE_DATA}
fi

# Replace the service file
echo "> install service" >> ${VSCODE_ROOT}/install.log
rm -f /lib/systemd/system/code-server.service
tee -a /lib/systemd/system/code-server.service > /dev/null <<EOT
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=${VSCODE_PASSWORD}
ExecStart=/usr/bin/code-server --host 0.0.0.0 --user-data-dir ${VSCODE_DATA} --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log


#
# Traefik & IDE Compose setup
#
echo "Setup traefik data..." >> ${VSCODE_ROOT}/install.log
TRAEFIK_DATA=/var/lib/traefik

# Ensure the directory for the source files exists
mkdir -p ${TRAEFIK_DATA}

# Generate the password into an htpasswd file for the ide
htpasswd -b -c ${VSCODE_ROOT}/.htpasswd ${VSCODE_USERNAME} ${VSCODE_PASSWORD}
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log


#
# Create .env file
#
echo "Create env file..." >> ${VSCODE_ROOT}/install.log
touch ${VSCODE_ROOT}/.env
echo "TRAEFIK_DATA=${TRAEFIK_DATA}" >> ${VSCODE_ROOT}/.env
echo "TRAEFIK_EMAIL=postmaster@gopigtail.com"  >> ${VSCODE_ROOT}/.env
echo "TRAEFIK_DNS=proxy.t1.marcopeg.com" >> ${VSCODE_ROOT}/.env
echo "VSCODE_DNS=code.t1.marcopeg.com" >> ${VSCODE_ROOT}/.env
echo "VSCODE_ROOT=${VSCODE_ROOT}" >> ${VSCODE_ROOT}/.env
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log

echo "Pulling images..." >> ${VSCODE_ROOT}/install.log
docker-compose -f ${VSCODE_ROOT}/docker-compose.yml pull
echo $'[OK]\n\n' >> ${VSCODE_ROOT}/install.log

echo "IDE Setup completed" >> ${VSCODE_ROOT}/install.log
