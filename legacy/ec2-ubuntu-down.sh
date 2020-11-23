# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

# Start VSCode
echo $'Stopping Code Sever...'
sudo systemctl stop code-server

# Start Docker
echo $'Stopping Docker services...'
(cd ${VSCODE_CWD} && humble down)
