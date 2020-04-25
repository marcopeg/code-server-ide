# vscode-server-ide
Utilities to transform any Ubuntu machine into a VSCode cloud IDE where
you can run any `docker-compose` projects, with custom DNS.

- Edit with VSCode
- Run `docker-compose` projects
- Self configure DNS entry
- Automatic reverse proxy with SSL for any container

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
