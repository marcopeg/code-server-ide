#!/bin/bash

git clone -b dev/24 https://github.com/marcopeg/code-server-ide.git

# Install Ansible
apt update -y
sudo apt install -y ansible

# Install Dependent Rolesz
ansible-galaxy install nickjj.docker

# Run playbooks
ansible-playbook ./code-server-ide/ansible/b1.yml
ansible-playbook ./code-server-ide/ansible/docker.yml

reboot
