# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

sudo systemctl start code-server
docker-compose -f ${CWD}/docker-compose.yml