#!/bin/bash

################################################
# SETUP YOUR IDE                               #
# -------------------------------------------- #
# Uncomment the variables that you like to set #
# Leave it commented to use the default values #
################################################

export CODE_SERVER_CWD="/home/ubuntu/code-server-ide"

## Configure Letsencrypt:
export CODE_SERVER_DNS="xx1.marcopeg.com"
export CODE_SERVER_EMAIL="marco.pegoraro+letsencrypt@gmail.com"



#############################################
# DO NOT MODIFY THE CODE BELOW THIS COMMENT #
#############################################

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD}
${CODE_SERVER_CWD}/src/setup.sh
