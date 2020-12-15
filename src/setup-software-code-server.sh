#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Installs the CodeServer as documented in:
### https://github.com/cdr/code-server/blob/v3.7.2/doc/install.md
###

# Install Code Server
CODE_SERVER_VERSION=$(curl --silent https://api.github.com/repos/cdr/code-server/releases/latest | jq .name -r)
echo "[$(date -u)] Installing CodeServer ${CODE_SERVER_VERSION} package..." >> ${CODE_SERVER_LOGS}/setup.log
curl -fOL https://github.com/cdr/code-server/releases/download/${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION:1}_amd64.deb >> ${CODE_SERVER_LOGS}/setup.log 2>&1
dpkg -i code-server_${CODE_SERVER_VERSION:1}_amd64.deb >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Replace the Service File
echo "[$(date -u)] Install CodeServer service file..." >> ${CODE_SERVER_LOGS}/setup.log
rm -f /lib/systemd/system/code-server-ide.service
tee -a /lib/systemd/system/code-server-ide.service > /dev/null <<EOT
[Unit]
Description=code-server-ide
After=network.target

[Service]
Type=simple
User=ubuntu
Environment=SHELL=/bin/bash
Environment=CODE_SERVER_CWD=${CODE_SERVER_CWD}
ExecStart=/usr/bin/code-server --auth=none --bind-addr 127.0.0.1:40001 --user-data-dir ${CODE_SERVER_CWD}/data/code-server-user --extensions-dir ${CODE_SERVER_CWD}/data/code-server-extensions
Restart=always

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload

echo "[$(date -u)] CodeServer files are stored in: ${CODE_SERVER_CWD}/code-server-(user/extensions)" >> ${CODE_SERVER_LOGS}/setup.log
