# Load the environment variables
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"
set -o allexport
source "${CWD}/.env"
set +o allexport

sudo systemctl status code-server
(cd ${VSCODE_CWD} && humble logs -f)
