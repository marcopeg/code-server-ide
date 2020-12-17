#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Install Ansible
apt update -y 
apt install -y ansible

# Install Dependent Roles
ansible-galaxy install nickjj.docker

# Run playbooks
ansible-playbook ${CWD}/ansible/utilities.yml
ansible-playbook ${CWD}/ansible/docker.yml
ansible-playbook ${CWD}/ansible/dotnet.yml
