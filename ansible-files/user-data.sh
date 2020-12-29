#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt update -y
apt install -y ansible

git config --global http.postBuffer 1048576000
git clone -b dev/24 https://github.com/marcopeg/code-server-ide.git /home/ubuntu/code-server-ide

(cd /home/ubuntu/code-server-ide/ansible-files && ansible-playbook ./code-server-ide.yml)
