#!/bin/bash

################################################
# SETUP YOUR IDE                               #
# -------------------------------------------- #
# Uncomment the variables that you like to set #
# Leave it commented to use the default values #
################################################

#export CODE_SERVER_CWD="/home/ubuntu/.code-server-ide"



#############################################
# DO NOT MODIFY THE CODE BELOW THIS COMMENT #
#############################################
echo $'\n\n# CODE SERVER IDE:' >> /home/ubuntu/.profile
echo "export CODE_SERVER_CWD=${CODE_SERVER_CWD:-"/home/ubuntu/.code-server-ide"}" >> /home/ubuntu/.profile
source /home/ubuntu/.profile
git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD}
${CODE_SERVER_CWD}/src/boot-ubuntu.sh
