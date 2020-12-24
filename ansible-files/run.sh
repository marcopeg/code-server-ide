#!/bin/bash

sudo apt update -y
sudo apt install -y ansible

# rm -rf /home/ubuntu/.ansible
# cp -r /home/ubuntu/code-server-ide/ansible-files/ansible/ /home/ubuntu/.ansible

ansible-playbook code-server-ide.yml
