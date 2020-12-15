#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Setup ENV File
###


if grep -q "CODE SERVER IDE" "/etc/bash.bashrc";
then
  echo "[$(date -u)] .bashrc file already exists, you may need to adjust its contents manually." >> ${CODE_SERVER_LOGS}/setup.log
else
  echo "[$(date -u)] Setup bashrc file..." >> ${CODE_SERVER_LOGS}/setup.log
  # Add header to the bashrc file
  echo $'\n\n# CODE SERVER IDE' >> /etc/bash.bashrc

  # Export environment variables
  echo "set -o allexport" >> /etc/bash.bashrc
  echo "source ${CODE_SERVER_CWD}/data/.env" >> /etc/bash.bashrc
  echo "set +o allexport" >> /etc/bash.bashrc

  # Load ssh agent
  echo "eval \"\$(ssh-agent -s)\"" >> /etc/bash.bashrc
  echo "ssh-add /home/ubuntu/.ssh/id_rsa" >> /etc/bash.bashrc

  # Add aliase to the main CLI utility
  echo "alias cs='${CODE_SERVER_CWD}/src/cs.sh'" >> /etc/bash.bashrc
fi

# Reload the bashrc so to activate the alias:
source /etc/bash.bashrc
