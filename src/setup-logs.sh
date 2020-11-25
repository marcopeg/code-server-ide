# Setup logs
source "$(dirname "$0")/profile.sh"

touch ${CODE_SERVER_LOG}
echo "[$(date -u)] Warming up..." >> ${CODE_SERVER_LOG}
