#!/bin/bash

###
### Defines all the variables that are needed to the code-server-ide project
###

# Get OS major version
# (Docker depends on this)
CODE_SERVER_OSV=$(cut -f2 <<< $(lsb_release -r))
export CODE_SERVER_OSV=${CODE_SERVER_OSV%.*}

# CWD with default based on Ubuntu home folder
export CODE_SERVER_CWD=${CODE_SERVER_CWD:-"/home/ubuntu/.code-server-ide"}
export CODE_SERVER_DATA=${CODE_SERVER_CWD}/data/code-server
export CODE_SERVER_LOGS=${CODE_SERVER_CWD}/data/logs
export CODE_SERVER_LOG=${CODE_SERVER_LOGS}/setup.log
export CODE_SERVER_TRAEFIK=${CODE_SERVER_CWD}/data/traefik
