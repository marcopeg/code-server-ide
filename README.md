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

You should also consider this desired skills:

- You should feel comfortable creating EC2 instances
- You should feel comfortable accessing EC2 instances via SSH
- You should feel comfortable creating `A` DNS entries for your domain name
- You should setup your [Sendgrid][sendgrid] account and retrieve a valid `API KEY`
- You may want to proxy your domain name through [CloudFlare][cloudflare] and retrieve an `API KEY` and `ZONE ID`

## What will I get out of this?

You will get a virtual machine that is ready for **any kind of development** you can possibly do on a Linux machine. 

You can **link your machine to a custom DNS** like `dev.yourname.com` and **expose any service you are working on** as `service.dev.yourname.com` with both `http` and `https` interfaces. You can access your IDE from different browsers on different devices and everything will stay in sync, this way you will be able to enjoy **endless multiple screens**.

You can stop your virtual machine when you don't need it, and you can change its power at any time. This means **you will use money wisely**, when you need it, for the task at hand.

You will be able to:

- Edit files using [Code Server][code-server] on a browser
- Run [Docker][docker] containers
- Run [Docker Compose][docker-compose] projects
- Use [CTOP][ctop] to monitor and control your running containers
- Install and switch between different versions of Nodejs using [NVM][nvm]
- Code in [NodeJS][nodejs]
- Interact with AWS using [AWS CLI v2][aws-cli]
- Proxy Code Server through ports `80` and `443` using [NGiNX][nginx] _(via Docker)_
- Automagically setup secure DNS using [Traefik][traefik] and [Letsencrypt][letsencrypt] _(via Docker)_
- Push to private repos using SSH authentication

## Step By Step Tutorial

### Security Group

Cloud Server IDE uses ports `80` and `443` that should be accessible from anywhere for the [Letsencrypt][letsencrypt] integration to take place smoothly.

You should also open up port `22` in case you need to access your machine via _ssh_.  
<small>(This is needed in case you configure your _DNS_ manually)</small>

### EC2 Instance

Create a new EC2 Instance based on `Ubuntu 20.04 LTS`, a `t2.micro` is more than enough to try this out.  
<small>(Later on you will be able to create a bigger machine for real development)</small>

Be careful during the step **Step 3: Configure Instance Details** as you need to paste and fix up one of the following configurations. This is actually the script that will install all the needed software and setup your system so to use it properly.

**User Data - With AWS' default DNS:**

👉 Use this configuration just for test, as `https` will not be available.

```bash
#!/bin/bash

export CODE_SERVER_EMAIL="welcome@yourname.com"
export SENDGRID_API_KEY="xxx"

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}
${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}/src/setup.sh
```

**User Data - With CloudFlare DNS Management:**

👉 Use this configuration if you proxy your DNS through [CloudFlare][cloudflare].  

```bash
#!/bin/bash

export CODE_SERVER_DNS="dev.yourname.com"
export CODE_SERVER_EMAIL="welcome@yourname.com"

export CLOUDFLARE_ZONE_ID="xxx"
export CLOUDFLARE_API_KEY="yyy"
export SENDGRID_API_KEY="zzz"

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}
${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}/src/setup.sh
```

**User Data - Without CloudFlare DNS Management:**

👉 Use this configuration in case you will configure your DNS manually.

```bash
#!/bin/bash

export CODE_SERVER_AUTO_START="no" # <- this is very important
export CODE_SERVER_DNS="dev.yourname.com"
export CODE_SERVER_EMAIL="welcome@yourname.com"
export SENDGRID_API_KEY="xxx"

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}
${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}/src/setup.sh
```

Please be careful setting `CODE_SERVER_AUTO_START="no"` so that you need to start your IDE manually.

### First Boot & Confirmation Email

To get your machine ready requires time. Please wait up to 5 minutes before you start worry. If you really freak out and want to know what's going on, _ssh_ into that machine and run:

```bash
tail -f ~/code-server-ide/data/logs/setup.log
```

Once the machine is ready, you should receive a confirmation email (given you set up the `SENDGRID_API_KEY`) with the machine's IP. 

If you used the [Cloudflare][cloudflare] integration, you can simply click on the link from the email and use the password to access your new IDE. Else, you need to setup your DNS as explained in the next paragraph.

### Manual DNS Setup

Open up your _DNS_ management tool and add 2 `A`records towards the machine's `IP` (that is available via the AWS Panel, and it is also provided in the confirmation email):

```
Type   Name   Target
-------------------------
A      dev    11.22.33.44
A      *.dev  11.22.33.44
```

Then you should _ssh_ into your machine and run the project:

```bash
cs start
```

In a few minutes your system should be up and running, and a new _SSL_ certificate should be created via [Letsencrypt][letsencrypt]. Try to access your new IDE, maybe do it via _incognito_ the first time.

> **👉 RE-ENABLE AUTO START:**  
> When everything works, you should change the value of `CODE_SERVER_AUTO_START` to `yes` (or simply remove the variable) from `~/code-server-ide/.env` so that your IDE will start automatically in case you restart the EC2 machine.

## Run a simple website with NGiNX on Docker

[[ TO BE COMPLETED ]]

## Protect your services with Simple Auth

[[ TO BE COMPLETED ]]

## Add Letsencrypt SSL to your Services

[[ TO BE COMPLETED ]]




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
[ctop]: https://github.com/bcicen/ctop