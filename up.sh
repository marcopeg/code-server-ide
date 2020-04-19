TRAEFIK_DATA=/var/lib/traefik \
TRAEFIK_DNS=proxy.t1.marcopeg.com \
VSCODE_DNS=code.t1.marcopeg.com \
  docker-compose -f /home/ubuntu/vscode-ide/compose/docker-compose.yml \
  up
