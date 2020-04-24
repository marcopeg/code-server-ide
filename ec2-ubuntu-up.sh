# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Start VSCode
echo $'Starting Code Sever...'
sudo systemctl start code-server

# Start Docker
echo $'Starting Docker services...'
(cd ${VSCODE_CWD} && docker-compose up -d)
(cd ${VSCODE_CWD} && docker-compose logs -f)
