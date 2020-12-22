# Ansible Backlog

Sofar target Ubuntu 20.04 with a nice extendable folder structure.

## High Level Goal

### Work from SSH

As a user,
given I have a newly created `Ubuntu 20.04` machine,
and I ssh into it,
I should run the following command to install all the software:

```bash
# Install ansible (one time only)
sudo apt update -y
apt install -y ansible

# Run the install script
git clone xxx 
./xxx/setup.sh # should run ansible stuff...
```

Then to update my machine I should run:

```bash
git pull # update the ansible definition from remote
./xxx/setup.sh # should run ansible stuff...
```

At the end, if there is a new Docker version, I have it running.

### Work from EC2 User Data

As a user,
given I have access to AWS console,
I should create a new EC2 instance,
and paste this script in the "user data":

```bash
# Install ansible (one time only)
apt update -y
install -y ansible

# Run the install script
git clone xxx 
./xxx/setup.sh # should run ansible stuff...
```

Once my machine is ready, all the needed software should be available right after ssh into it.

Then to update my machine I should run:

```bash
cd xxx
git pull # update the ansible definition from remote
./xxx/setup.sh # should run ansible stuff...
```

---

## List of desired playbooks

### Docker + Docker Compose

### CTOP (Docker process manager)

### NVM + Install latest LTS

### Install DotNet framwework

### Install Code Server stuff

(see bash script)

### Install AWS cli

(see bash script)

### Install Java stuff (optional)

### Install Python stuff (optional)