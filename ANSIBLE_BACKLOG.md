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

### Docker + Docker Compose + humble

[[ tested ]]

### CTOP (Docker process manager)

[[ tested ]]

### NVM + Install latest LTS

[[ fails ]]

### Install DotNet framwework

[[ fails ]]

### Install Code Server stuff

(see bash script)

### Install AWS cli

(see bash script)

### Install Java stuff (optional)

### Install Python stuff (optional)

## HOW DID I TESTED IT

**NOTE:** it is very critical NOT to use root user during the installation

### Using "ubuntu" user:

1. I created a new t2.small
2. ssh into it
3. git clone -b dev/24 https://github.com/marcopeg/code-server-ide.git
4. cd ./code-server-ide/ansible-files
5. sudo ./run.sh

### Using "user-data" at boot time

1. create new ec2
2. choose instance type (t2.small)
3. paste content of "user-data.sh" to the user data
4. proceed to creation

## TASKS

- docker-compose install needs to elevate perimssion to sudo
- humble: would be possible to ensure a "git pull" in case the repo is already in place?

## QUESTIONS

- is it possible to use "latest" with docker?
- is it possible to use "latest" with docker-compose?
- is it possible to load variables from a `.env` file?
  it would be great to have always docker=latest installed by default, 
  but maybe someone would prefer a specific version
  a `.env` file would be gitignored, giving the user freedom of configuration
- the NVM install seems quite complex, any way to simplify it?
  