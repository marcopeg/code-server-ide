# Code Server IDE

Hello friend, and welcome to the **Code Server IDE** project.

> This repo contains tools and info to run your 
> **cloud based development environment** 
> with [VSCode][vscode] as main UI 😎.

## What do I get, if I keep reading?

You will get a virtual machine that is ready for **any kind of development** you can possibly do on a Linux machine. 

You can **link your machine to a custom DNS** like `dev.yourname.com` and **expose any service you are working on** as `service.dev.yourname.com` with both `http` and `https` interfaces thanks to the [Letsencrypt] integration. You can access your IDE from different browsers on different devices and everything will stay in sync, this way you will be able to enjoy **endless multiple screens**.

You can stop your virtual machine when you don't need it, and you can change its power at any time adjusting it to the task you're about to perform. This means **you will use money wisely**, when you need it, for the task at hand.

Here is what you get:

- Your fully dedicated Linux machine running [Ubuntu]
- [VSCode] running in a browser
- An automatic reverse proxy for [Docker] containers and local processes
- Real-time monitoring with [NetData]
- File system management FUI with [FileBrowser]
- Automatic DNS updates with [CloudFlare]
- A _CLI_ that helps performing lot of tasks:
  - Start/stop/restart services
  - Access logs
  - Get generic info such IP or machine's DNS
  - Create _https enabled_ proxies to your local processes
  - Kill a running process on a specific port
  - Change password
  - Update DNS
  - Update the IDE
- Lot of pre-installed software:
  - [Code-Server]
  - [Docker]
  - [Docker-Compose]
  - [Make]
  - [Ctop]
  - [NVM], [NodeJS], [NPM]
  - [dotNET] SDK & Framework
  - [AWS-CLI]
  - [NetData]
  - [FileBrowser]


## What do I need to try this out?

In order to follow this tutorial and get to the final result, I suggest you get prepared with:

- an AWS account where you can create a new virtual machine
- a domain name that you can use like `yourname.com`
- _[optional] [CloudFlare][cloudflare]'s `ZONE_ID` and an `API_KEY` for an automatic DNS setup_
- _[optional] A [Sendgrid][sendgrid] `API_KEY` to send yourself a welcome mail once the machine is ready_

You should also consider this desired skills:

- You should feel comfortable creating EC2 instances
- You should feel comfortable accessing EC2 instances via SSH
- You should feel comfortable creating `type A` DNS entries for your domain name
- You should setup your [Sendgrid][sendgrid] account and retrieve a valid `API KEY`
- You may want to proxy your domain name through [CloudFlare][cloudflare] and retrieve an `API KEY` and `ZONE ID`

## Step By Step Tutorial

### Security Group

Cloud Server IDE, uses ports `80` and `443` that should be accessible from anywhere for the [Letsencrypt][letsencrypt] integration to take place smoothly.

You should also open up port `22` in case you need to access your machine via _ssh_.  
<small>(This is needed in case you configure your _DNS_ manually)</small>

### EC2 Instance

Create a new EC2 Instance based on `Ubuntu 20.04 LTS`, a `t2.micro` is more than enough to try this out.  
<small>(Later on you will be able to create a bigger machine for real development)</small>

Be careful during the step **Step 3: Configure Instance Details** as you need to paste and customize one of the following configurations. This is actually the script that will install all the needed software and setup your system so to boot properly.

**User Data - With AWS' default DNS:**

👉 Use this configuration just for test, as `https` will not be available.

```bash
#!/bin/bash

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}
${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}/src/setup.sh
```

In order to follow what's going on, ssh into the machine and tail the setup logs file:

```bash
tail -f code-server-ide/data/logs/setup.log
```

**NOTE:** With this minimal configuration, you will be able to access the machine using EC2's default DNS which will NOT allow Letsencrypt to provide a valid SSL certificate as they are black-listed. 

Therefore, you will have to go through the security alert and accept the risks in accessing your machine via `http`. Don't use it for production purposes!

**User Data - With CloudFlare DNS Management:**

👉 Use this configuration if you proxy your DNS through [CloudFlare][cloudflare].  

```bash
#!/bin/bash

# This configuration will automaticall setup the DNS for you:
export CODE_SERVER_DNS="dev.yourname.com"
export CLOUDFLARE_ZONE_ID="xxx"
export CLOUDFLARE_API_KEY="yyy"

# This (optional) configuration is used to send a welcom email
# every time the machine boots up:
export CODE_SERVER_EMAIL="welcome@yourname.com"
export SENDGRID_API_KEY="zzz"

git clone https://github.com/marcopeg/code-server-ide.git ${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}
${CODE_SERVER_CWD:-/home/ubuntu/code-server-ide}/src/setup.sh
```

**User Data - Without CloudFlare DNS Management:**

👉 Use this configuration in case you will configure your DNS manually.

```bash
#!/bin/bash

# This configuration sets up the DNS inside the machine, but will
# NOT run the application.
# You should first manually configure your DNS, then ssh into the
# EC2 machien and run `cs start ide` to run the application.
#
# It is a good idea to give an ElasticIP to your machine.
export CODE_SERVER_AUTO_START="no" # <- this is very important
export CODE_SERVER_DNS="dev.yourname.com"

# This (optional) configuration is used to send a welcom email
# every time the machine boots up:
export CODE_SERVER_EMAIL="welcome@yourname.com"
export SENDGRID_API_KEY="zzz"

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

## Update Code-Server

You can find detailed information about [installing & upgrading `code-server` here](https://github.com/cdr/code-server/blob/v3.9.3/docs/install.md#upgrading), but the gist of it is:

```bash
curl -fsSL https://code-server.dev/install.sh | sh
sudo reboot
```

## Proxy any process throgh HTTPS

You can run any process on the host's machine (aka: NodeJS or anything else) and easily proxy it
so to get an _https_ enabled DNS automatically.

**Step 1:** start a NodeJS App:

```bash
npx create-react-app foobar
cd foobar
npm start
```

**Step 2:** proxy it:

```bash
cs proxy up -p 3000
```

The proxy will be available at:

```
https://p3000.your.website.com
```

When you want to remove the proxy, just type:

```bash
cs proxy down -p 3000
```

## Run Real Time Monitoring

If you are a little bit like me, you want to know what's going on in your machine. [Ctop] helps out a bit with [Docker] containers, but you may be running plenty more processes on the OS.

[NetData] is among the coolest data-collection tools I've found online. And it's easy to run it in Docker. With Cloud Server IDE, you have an even easier time:

```bash
cs start netdata
```

then go to:

```bash
# The trailing slash is important!
https://your.development.box/netdata/
```

and when you want to stop it:

```bash
cs stop netdata
```

Yes, it is that simple 😎.

## Run the File System GUI

It's often useful to have a _GUI_ to walk through files and folders, upload and download stuff.
[FileBrowser] is a very decent tool for that, and works fine in Docker.

Take advantage of the _CLI_ to run this service:

```bash
cs start filebrowser
```

then go to:

```bash
# The trailing slash is important!
https://your.development.box/filebrowser/
```

and when you want to stop it:

```bash
cs stop filebrowser
```

> **👉 NOTE:** This service has full access to your home folder.  
> 
> I strongly suggest you keep it running only while you need it and **then you stop it**.

## Run some examples to get acquainted

Take a look at the `examples` folders, where you can find a few apps that
run in Docker and get automatically proxied through Traefik.

## Troubleshooting

### Fix Cmd+Z or Ctrl+Z

The default configuration has an issue with that keyboard shortcut that could be easily fixed
by a change of configuration:

1. Open: `File > Preferences > Settings`
2. Search: `keyboard.dispatch`
3. Set: `keyCode`

Now, it should work fine.  
<small>[You can find the issue page here](https://github.com/cdr/code-server/issues/1477).</small>

### NodeJS - Nodemon fails to start

Using Nodemon caused the following error:

```
[nodemon] Internal watch failed: ENOSPC: System limit for number of file watchers reached, watch '/home/ubuntu/projects/tmp/auth-server'
```

Found the following solution [from this Stackoverflow](https://stackoverflow.com/questions/34662574/node-js-getting-error-nodemon-internal-watch-failed-watch-enospc):

```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```




[vscode]: https://code.visualstudio.com/ "Visual Studio Code"
[cloudflare]: https://www.cloudflare.com/ "DNS & Proxy service"
[code-server]: https://github.com/cdr/code-server "VSCode as a service"
[docker]: https://www.docker.com/
[docker-compose]: https://docs.docker.com/compose/
[nginx]: https://www.nginx.com/
[traefik]: https://traefik.io/
[nvm]: https://github.com/nvm-sh/nvm "Node Version Manager"
[nodejs]: https://nodejs.org/
[npm]: https://www.npmjs.com/
[aws-cli]: https://aws.amazon.com/cli/ "AWS Command Line Interface"
[sendgrid]: https://sendgrid.com/
[letsencrypt]: https://letsencrypt.org/
[ctop]: https://github.com/bcicen/ctop
[netdata]: https://www.netdata.cloud/
[ubuntu]: https://ubuntu.com/
[aws cli]: https://aws.amazon.com/cli/
[make]: https://en.wikipedia.org/wiki/Make_(software)
[filebrowser]: https://filebrowser.org/
[dotnet]: https://dotnet.microsoft.com/