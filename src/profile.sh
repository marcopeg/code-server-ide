#!/bin/bash

###
### Defines all the variables that are needed to the code-server-ide project
###

# CWD with default based on Ubuntu home folder
export CODE_SERVER_CWD=${CODE_SERVER_CWD:-"/home/ubuntu/.code-server-ide"}
export CODE_SERVER_DATA=${CODE_SERVER_CWD}/data
export CODE_SERVER_LOGS=${CODE_SERVER_CWD}/data/logs
export CODE_SERVER_LOG=${CODE_SERVER_LOGS}/setup.log
