# vscode-server-ide
Utilities to transform an Ubuntu machine into a VSCode cloud IDE

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
