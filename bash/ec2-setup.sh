#!/bin/bash
apt-get update -y
apt-get install jq apache2-utils -y




#
# Install Docker
#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-cache policy docker-ce
apt-get install -y docker-ce
usermod -aG docker ubuntu



#
# Docker Compose (latest version)
#
DOCKER_COMPOSE_VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose



#
# Humble CLI (need to fix the -y compatibility)
#
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble



#
# Code Server
#
VSCODE_VERSION=$(curl --silent https://api.github.com/repos/cdr/code-server/releases/latest | jq .name -r)
VSCODE_SRC=/home/ubuntu/vscode-ide/code-server
VSCODE_DATA=/var/lib/code-server
VSCODE_PASSWD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)

# Save generated password to a local file
echo ${VSCODE_PASSWD} >> /home/ubuntu/vscode-ide/password-vscode

# Ensure the directory for the source files exists
mkdir -p ${VSCODE_SRC}

# Download & Extract
if [ ! -d "${VSCODE_SRC}/code-server-${VSCODE_VERSION}-linux-x86_64" ]; then
  wget https://github.com/cdr/code-server/releases/download/${VSCODE_VERSION}/code-server-${VSCODE_VERSION}-linux-x86_64.tar.gz -P ${VSCODE_SRC}
  tar -xzvf ${VSCODE_SRC}/code-server-${VSCODE_VERSION}-linux-x86_64.tar.gz --directory ${VSCODE_SRC}
fi

# Install command from the downloaded version
# cd code-server-${VSCODE_VERSION}-linux-x86_64
echo "Copy files..."
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
rm -f /lib/systemd/system/code-server.service
tee -a /lib/systemd/system/code-server.service > /dev/null <<EOT
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=${VSCODE_PASSWD}
ExecStart=/usr/bin/code-server --host 0.0.0.0 --user-data-dir ${VSCODE_DATA} --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
systemctl start code-server



#
# Traefik & IDE Compose setup
#

TRAEFIK_DATA=/var/lib/traefik
TRAEFIK_PASSWD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)

# Save generated password to a local file
echo ${TRAEFIK_PASSWD} >> /home/ubuntu/vscode-ide/password-traefik

# Ensure the directory for the source files exists
mkdir -p ${TRAEFIK_DATA}

# Generate the password into an htpasswd file for the ide
htpasswd -b -c /home/ubuntu/vscode-ide/.htpasswd vscode ${TRAEFIK_PASSWD}