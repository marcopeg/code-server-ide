# Load the environment variables
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"
set -o allexport
source "${CWD}/.env"
set +o allexport

# Start VSCode
sudo systemctl start code-server

# Start Docker
(cd ${VSCODE_CWD} && humble up -d)
(cd ${VSCODE_CWD} && humble logs -f)
