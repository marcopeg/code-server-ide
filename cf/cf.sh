#!/bin/bash
set -euo pipefail
CWD="$(dirname "$0")"

function help() {
  echo "HELP"
  exit 0
}

# CMD="-"
STACK_PARAMS=""

# Show help if no params were given
CHKP=${1:-} ; [ -z ${CHKP} ] && help

while [ "$#" -ne 0 ] ; do
  case "$1" in
    up|down|apply)
      CMD="$1"
      shift
      ;;
    -h|--help)
      help
      shift
      ;;
    --ec2-key)
      STACK_PARAMS="${STACK_PARAMS} ParameterKey=EC2KeyPairName,ParameterValue=${2}"
      shift 2
      ;;
    *)
      help
      shift
      ;;
  esac
done

# Check for a command to be placed
[ -z ${CMD+x} ] && help

echo ${CMD}
echo ${STACK_PARAMS}
