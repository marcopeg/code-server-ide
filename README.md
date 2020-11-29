# Code Server IDE

Hello friend, and welcome to the **Code Server IDE** project.

> This repo contains tools and info to run your 
> **cloud based development environment** 
> with [VSCode][vscode] as main UI 😎.

## What do I need to try this out?

In order to follow this tutorial and get to the final result, I suggest you get prepared with:

- an AWS account where you can create a new virtual machine
- a domain name that you can use like `yourname.com`
- _[optional] [CloudFlare][cloudflare]'s `ZONE_ID` and an `API_KEY` for an automatic DNS setup_
- _[optional] A [Sendgrid][sendgrid] `API_KEY` to send yourself a welcome mail once the machine is ready_

## What will I get out of this?

You will get a virtual machine that is ready for **any kind of development** you can possibly do on a Linux machine. 

You can **link your machine to a custom DNS** like `dev.yourname.com` and **expose any service you are working on** as `service.dev.yourname.com` with both `http` and `https` interfaces. You can access your IDE from different browsers on different devices and everything will stay in sync, this way you will be able to enjoy **endless multiple screens**.

You can stop your virtual machine when you don't need it, and you can change its power at any time. This means **you will use money wisely**, when you need it, for the task at hand.

You will be able to:

- Edit files using [Code Server][code-server] on a browser
- Run [Docker][docker] containers
- Run [Docker Compose][docker-compose] projects
- Install and switch between different versions of Nodejs using [NVM][nvm]
- Code in [NodeJS][nodejs]
- Interact with AWS using [AWS CLI v2][aws-cli]
- Proxy Code Server through ports `80` and `443` using [NGiNX][nginx] _(via Docker)_
- Automagically setup secure DNS using [Traefik][traefik] and [Letsencrypt][letsencrypt] _(via Docker)_
- Push to private repos using SSH authentication



[vscode]: https://code.visualstudio.com/ "Visual Studio Code"
[cloudflare]: https://www.cloudflare.com/ "DNS & Proxy service"
[code-server]: https://github.com/cdr/code-server "VSCode as a service"
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[nginx]: https://www.nginx.com/
[traefik]: https://traefik.io/
[nvm]: https://github.com/nvm-sh/nvm "Node Version Manager"
[nodejs]: https://nodejs.org/
[aws-cli]: https://aws.amazon.com/cli/ "AWS Command Line Interface"
[sendgrid]: https://sendgrid.com/
[letsencrypt]: https://letsencrypt.org/