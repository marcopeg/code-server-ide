TRAEFIK_DATA=/var/lib/traefik \
TRAEFIK_BASIC_AUTH=/home/ubuntu/vscode-ide/.htpasswd \
TRAEFIK_DNS=proxy.t1.marcopeg.com \
TRAEFIK_EMAIL=postmaster@gopigtail.com \
VSCODE_DNS=code.t1.marcopeg.com \
  docker-compose -f /home/ubuntu/vscode-ide/docker-compose.yml \
  up
