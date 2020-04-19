VSCODE_VERSION=$(curl --silent https://api.github.com/repos/cdr/code-server/releases/latest | jq .name -r)
VSCODE_SRC=/home/ubuntu/vscode-ide/code-server
VSCODE_DATA=/var/lib/code-server

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
sudo rm -f /usr/bin/code-server
sudo rm -rf /usr/lib/code-server
sudo cp -R ${VSCODE_SRC}/code-server-${VSCODE_VERSION}-linux-x86_64 /usr/lib/code-server
sudo ln -s /usr/lib/code-server/code-server /usr/bin/code-server

# Prepare the data folder
if [ ! -f "${VSCODE_DATA}" ]; then
  sudo mkdir -p ${VSCODE_DATA}
  sudo chown ubuntu ${VSCODE_DATA}
fi


###
### Replace the service file
###
sudo rm -f /lib/systemd/system/code-server.service
sudo tee -a /lib/systemd/system/code-server.service > /dev/null <<EOT
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=foobar
ExecStart=/usr/bin/code-server --host 0.0.0.0 --user-data-dir ${VSCODE_DATA} --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOT
sudo systemctl daemon-reload
sudo systemctl start code-server

