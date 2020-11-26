#!/bin/bash
source "$(dirname "$0")/profile.sh"

###
### Setup DockerCompose
###

echo "[$(date -u)] Setup boot scripts..." >> ${CODE_SERVER_LOG}
touch /var/lib/cloud/scripts/per-boot/code-server-ide.sh
echo "#!/bin/bash" >> /var/lib/cloud/scripts/per-boot/code-server-ide.sh
echo "${CODE_SERVER_CWD}/src/ec2-ubuntu-boot.sh" >> /var/lib/cloud/scripts/per-boot/code-server-ide.sh
chmod +x /var/lib/cloud/scripts/per-boot/code-server-ide.sh
echo $'[OK]\n' >> ${CODE_SERVER_LOG}
