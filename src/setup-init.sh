#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

mkdir -p $CODE_SERVER_DATA
mkdir -p $CODE_SERVER_LOGS
mkdir -p ${CODE_SERVER_TRAEFIK}

touch ${CODE_SERVER_LOGS}/setup.log
echo "[$(date -u)] Code Server IDE Setup: Welcome my dude!" >> ${CODE_SERVER_LOGS}/setup.log
echo "[$(date -u)] Simple Auth Username: ${SIMPLE_AUTH_USERNAME}" >> ${CODE_SERVER_LOGS}/setup.log
echo "[$(date -u)] Simple Auth Password: ${SIMPLE_AUTH_PASSWORD}" >> ${CODE_SERVER_LOGS}/setup.log

# Generate the password into an .htpasswd file for the ide:
echo "[$(date -u)] Writing Simple Auth .htpasswd..." >> ${CODE_SERVER_LOGS}/setup.log
htpasswd -b -c ${CODE_SERVER_CWD}/data/.htpasswd ${SIMPLE_AUTH_USERNAME} ${SIMPLE_AUTH_PASSWORD} >> ${CODE_SERVER_LOGS}/setup.log 2>&1

# Generate the RSA key:
if [ ! -f "${CODE_SERVER_SSH}/id_rsa.pub" ]
then
  echo "[$(date -u)] Generating an id_rsa..." >> ${CODE_SERVER_LOGS}/setup.log
  mkdir -p ${CODE_SERVER_SSH} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  chown ubuntu -R  ${CODE_SERVER_SSH} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  ssh-keygen -f ${CODE_SERVER_SSH}/id_rsa -t rsa -N '' >> ${CODE_SERVER_LOGS}/setup.log 2>&1
else
  echo "[$(date -u)] Found pre-existing id_rsa, skipping" >> ${CODE_SERVER_LOGS}/setup.log
fi

# Adding the EC2 boot scripts
if [ -d "/var/lib/cloud/scripts/per-boot/" ]
then
  if [ -f "/var/lib/cloud/scripts/per-boot/code-server-ide.sh" ]
  then
    echo "[$(date -u)] Found pre-existing ec2-boot script, skipping" >> ${CODE_SERVER_LOGS}/setup.log
  else
    echo "[$(date -u)] Creating ec2-boot script..." >> ${CODE_SERVER_LOGS}/setup.log
    touch /var/lib/cloud/scripts/per-boot/code-server-ide.sh >> ${CODE_SERVER_LOGS}/setup.log 2>&1
    echo "#!/bin/bash" >> /var/lib/cloud/scripts/per-boot/code-server-ide.sh
    echo "${CODE_SERVER_CWD}/src/ec2-ubuntu-boot.sh" >> /var/lib/cloud/scripts/per-boot/code-server-ide.sh
    chmod +x /var/lib/cloud/scripts/per-boot/code-server-ide.sh >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  fi
fi