#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Installs the CodeServer as documented in:
### https://github.com/cdr/code-server/blob/v3.7.2/doc/install.md
###

# Install Code Server
CODE_SERVER_VERSION=$(curl --silent https://api.github.com/repos/cdr/code-server/releases/latest | jq .name -r)
echo "[$(date -u)] Installing CodeServer ${CODE_SERVER_VERSION} package..." >> ${CODE_SERVER_LOG}
curl -fOL https://github.com/cdr/code-server/releases/download/${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION:1}_amd64.deb
dpkg -i code-server_${CODE_SERVER_VERSION:1}_amd64.deb


# Replace the Service File
echo "[$(date -u)] Install CodeServer service file..." >> ${CODE_SERVER_LOG}
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
ExecStart=/usr/bin/code-server --host 0.0.0.0 --auth none
Restart=always

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
echo "[$(date -u)] CodeServer files are stored in: ${CODE_SERVER_DATA}" >> ${CODE_SERVER_LOG}
echo $'[OK]\n' >> ${CODE_SERVER_LOG}