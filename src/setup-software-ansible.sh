#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Run Ansible definition
###

# Install Ansible
apt update -y 
apt install -y ansible

# Install Dependent Roles
ansible-galaxy install nickjj.docker
ansible-galaxy install gantsign.ctop

# Run playbooks
ansible-playbook ${CODE_SERVER_CWD}/ansible/utilities.yml
ansible-playbook ${CODE_SERVER_CWD}/ansible/docker.yml
ansible-playbook ${CODE_SERVER_CWD}/ansible/humble.yml
ansible-playbook ${CODE_SERVER_CWD}/ansible/dotnet.yml
ansible-playbook ${CODE_SERVER_CWD}/ansible/ctop.yml
ansible-playbook ${CODE_SERVER_CWD}/ansible/nvm.yml
