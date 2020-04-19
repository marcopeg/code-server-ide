TRAEFIK_DATA=/var/lib/traefik \
TRAEFIK_DNS=proxy.t1.marcopeg.com \
TRAEFIK_EMAIL=postmaster@gopigtail.com \
TRAEFIK_BASIC_AUTH="test:\$apr1\$RnbJi4Uh\$PybxuSxXQJQBrq52RDkL2/" \
VSCODE_DNS=code.t1.marcopeg.com \
  docker-compose -f /home/ubuntu/vscode-ide/compose/docker-compose.yml \
  up
