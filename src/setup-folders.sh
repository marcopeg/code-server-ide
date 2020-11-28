#!/bin/bash
source "$(dirname "$0")/setup-profile.sh"

###
### Destroys and re-create the folder structure that is needed for the
### installation of the system.
###

mkdir -p $CODE_SERVER_DATA
mkdir -p $CODE_SERVER_LOGS

