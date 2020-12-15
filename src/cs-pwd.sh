#!/bin/bash

# Calculate the CWD:
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && cd .. && pwd )`"

# Load the environment variables:
set -o allexport
source "${CWD}/data/.env"
set +o allexport

function askUsrname() {
  if [ -z ${CHANGE_USRNAME+x} ] ; then
    echo "Please enter the username you want to set/change the password for:"
    read CHANGE_USRNAME
  fi

  if [ ! -n "${CHANGE_USRNAME}" ]
  then
    echo "ERROR: You must provide a valid username!"
    exit
  fi
}

function askPasswd() {
  if [ -z ${CHANGE_PASSWD+x} ] ; then
    echo "Please enter the new password:"
    read -s CHANGE_PASSWD
    echo "Please re-enter the password (just to play safe):"
    read -s CHANGE_PASSWD_CONFIRM
    
    if [ ${CHANGE_PASSWD} != ${CHANGE_PASSWD_CONFIRM} ]
    then
      echo "ERROR: Password mismatch!"
      exit
    fi

  fi

  if [ ! -n "${CHANGE_PASSWD}" ]
  then
    echo "ERROR: You must provide a valid password!"
    exit
  fi
}

function ide() {
  askPasswd

  echo "Changing CodeServerIDE Password..."
  echo "[$(date -u)] Changing IDE Password to: ${CHANGE_PASSWD}" >> ${CODE_SERVER_LOGS}/setup.log
  echo ${CHANGE_PASSWD} > "${CODE_SERVER_CWD}/data/passwd"
  docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d --force-recreate auth-passwd >> ${CODE_SERVER_LOGS}/setup.log 2>&1
}

function basicAuth() {
  askUsrname
  askPasswd

  echo "Changing Basic Auth Password..."
  echo "[$(date -u)] Changing Basic Auth Password for '${CHANGE_USRNAME}' to: ${CHANGE_PASSWD}" >> ${CODE_SERVER_LOGS}/setup.log
  htpasswd -b ${CODE_SERVER_CWD}/data/.htpasswd ${CHANGE_USRNAME} ${CHANGE_PASSWD} >> ${CODE_SERVER_LOGS}/setup.log 2>&1
  docker-compose -f ${CODE_SERVER_CWD}/docker-compose.yml up -d --force-recreate traefik >> ${CODE_SERVER_LOGS}/cs.log 2>&1
}


# Collect command line arguments:
while [ "$#" -ne 0 ] ; do
  case "$1" in
    ide|basic-auth)
      CMD="$1"
      shift
      ;;
    -u|--user)
      CHANGE_USRNAME="${2}"
      shift 2
      ;;
    -p|--password)
      CHANGE_PASSWD="${2}"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Present the main menu:
if [ -z ${CMD+x} ]
then
  PS3='Please pick a choice:'
  options=("Change IDE password" "Change Basic Auth password")
  select opt in "${options[@]}"
  do
    case $opt in
      "Change IDE password")
        CMD=ide
        break
        ;;
      "Change Basic Auth password")
        CMD=basic-auth
        break
        ;;
      *) echo "invalid option";;
    esac
  done
fi

case ${CMD} in
    "ide")
        ide ${@:2}
        ;;
    "basic-auth")
        basicAuth ${@:2}
        ;;
    *) echo "invalid option";;
esac

