#Ansible playbooks
Current Ansible playbooks working well with Ubuntu 20.04 and most of playbooks with other Ubuntu versions: 14.04,16.04,18.04
It working with remove or local server using ssh keys file.

```bash
# Generate ssh key file and upload it to server
ssh-keygen
ssh-copy user@127.0.0.1
sudo apt update -y

# Install ansible (one time only)
apt-get install software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt install -y ansible

# Run the install script
ansible-playbook -i "server_ip", code-server-ide.yml
```
