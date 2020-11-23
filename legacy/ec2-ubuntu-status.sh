# Calculate the CWD
CWD="`dirname \"$0\"`"
CWD="`( cd \"$CWD\" && pwd )`"

# Load the environment variables
set -o allexport
source "${CWD}/.env"
set +o allexport

echo $'\n\nCode Sever:\n=================================='
sudo systemctl status code-server
echo $'\n\nDocker:\n=================================='
(cd ${VSCODE_CWD} && humble logs -f)
