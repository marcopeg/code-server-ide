#!/bin/bash

sudo apt update -y
sudo apt install -y ansible

ansible-playbook ./code-server-ide.yml
