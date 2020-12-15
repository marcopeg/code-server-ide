#!/bin/bash

###
### Defines all the variables that are needed to the code-server-ide project
###

# Get OS major version
# (Docker depends on this)
CODE_SERVER_OSV=$(cut -f2 <<< $(lsb_release -r))
export CODE_SERVER_OSV=${CODE_SERVER_OSV%.*}

# CWD with default based on Ubuntu home folder
export CODE_SERVER_CWD=${CODE_SERVER_CWD:-"$(cd $(dirname "$0") && cd .. && pwd)"}
export CODE_SERVER_LOGS=${CODE_SERVER_CWD}/data/logs
export CODE_SERVER_TRAEFIK=${CODE_SERVER_CWD}/data/traefik
export CODE_SERVER_SSH="/home/ubuntu/.ssh"

# Default Environment Variables
export CODE_SERVER_DNS=${CODE_SERVER_DNS}
export CODE_SERVER_EMAIL=${CODE_SERVER_EMAIL:-"code-server-ide@foobar.com"}

# Generate random access credentials for Simple Auth
export SIMPLE_AUTH_USERNAME=${SIMPLE_AUTH_USERNAME:-admin}
export SIMPLE_AUTH_PASSWORD=${SIMPLE_AUTH_PASSWORD:-$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)}
