# vscode-server-ide
Utilities to transform any Ubuntu machine into a VSCode cloud IDE where
you can run any `docker-compose` projects, with custom DNS.

## Features

- Edit with VSCode (install it as native shortcut in Chrome!)
- Run `docker-compose` projects
- Self configure DNS entry
- Automatic reverse proxy with SSL for any container

## IDE Basic Auth

VSCode web interface is protected by _basic auth_ with an `.htpasswd`
file stored in  `~/vscode-ide/data/.htpasswd`.

In order to make changes to the list of available users, `cd ~/vscode-ide/data`.

```bash
# Add New User / Change password
htpasswd .htpasswd {username} 
```

**NOTE:** After changing the password it is necessary to reload Traefik:

```bash
# reboot the IDE
(cd ~/vscode-ide && docker-compose down && docker-compose up -d)

# reboot the machine
sudo reboot
```

## Setup GitHub

The system generates an `id_rsa` file at setup time, that file is then loaded
into the ssh-agent at boot time. Add it's public key to GitHub for a smooth experience.

```
cat ~/.ssh/id_rsa.pub
```

Also, you need to add GitHub to the `.ssh/known_hosts`:

```
ssh -T git@github.com
```


## CloudFlare DNS

In order to automatically setup a DNS entry for your development
machine you need 2 pieces of information:

- API Key
- ZoneID

### API Key

```
My Profile > API Tokens > Create token
```

From the top-right menu, navigate to `My Profile`, then to `API Tokens`.

You need to create a new token using the `Edit zone DNS` template.

### ZoneID

Enter CloudFlare admin, navigate to the domain's Overview panel and
scroll down the page until you spot `Zone ID` on the right-hand panel.

Copy that value.

## Troubleshooting

### Cmd + z

This key binding does not work by default on OSX (it mapped to `Cmd + y`).

As a temporary solution:

- open `File > Preferences > Settings`
- search `keyboard.dispatch`
- change to: `keyCode`

Some details are available here:  
https://github.com/cdr/code-server/issues/1477
