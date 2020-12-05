# CodeServer IDE Walkthrough Talk

- [x] Create an EC2 machine with security group 22, 80, 443, 8080
- [x] Install CodeServer & run it on 8080
- [x] Run CodeServer as a Service
      (needed to offer direct ssh access to the machine)
- [x] Install Docker, DockerCompose, HumbleCLI
- [ ] Run a simple Traefik instance on port 80 (via DockerCompose)
- [ ] Proxy an NGiNX instance through Traefik (via DockerCompose)
- [ ] Proxy CodeServer via NGiNX and Traefik (via DockerCompose)
- [ ] Aim a DNS towards the machine using CloudFlare
      (let’s just do it via REST call using Postmand and cURL)
- [ ] Configure Traefik to generate Letsencrypt certificates (via DockerCompose)

## Create an EC2 machine

![EC2 Dashboard](./ec2-dashboard.png)

### Step 1: Choose an Amazon Machine Image (AMI)

![EC2 Choose Image](./ec2-choose-image.png)

### Step 2: Choose an Instance Type

![EC2 Choose Instance Type](./ec2-choose-instance-type.png)

### Step 3: Configure Instance Details

![EC2 Configure Instance Details](./ec2-configure-instance-details.png)

### Step 4: Add Storage

![EC2 Add Storage](./ec2-add-storage.png)

### Step 5: Add Tags

![EC2 Add Tags](./ec2-add-tags.png)

### Step 6: Configure Security Group

![EC2 Configure Security Group](./ec2-configure-security-group.png)

### Step 7: Review Instance Launch

![EC2 Review Instance Launch](./ec2-review-instance-launch.png)

![EC2 Download key file](./ec2-key-file.png)

### Check the machine status

![EC2 Launch status](./ec2-launch-status.png)

![EC2 Instance Details](./ec2-instance-details.png)

### Connect via SSH

Before attempting your first connection, you need to set the proper permissions to the _PEM KEY_ that you downloaded previously. AWS checks on this very detail as mandatory security requirement.

```bash
chmod 400 ~/Downloads/code-server-ide.pem
```

From now on, you can use the following command to get _SSH_ access to your newly created EC2 instance:

```bash
ssh -i ~/Downloads/code-server-ide.pem ubuntu@xx.xx.xx.xx
```

> 👉 The first time you connect, you will be prompted to
> accept the host's fingerprint. That 
> [increases security](https://www.phcomp.co.uk/Tutorials/Unix-And-Linux/ssh-check-server-fingerprint.html).

> 👉 It is important to point out that we choose "My IP" as origin for
> any SSH connections in _Step 6: Configure Security Group_. If you are
> attempting to connect from a different IP (maybe your phone or you
> went to meed you grandmother), you need to update that setting in the
> _Security Group_ configuration.
  
![EC2 SSH Prompt](./ec2-ssh-prompt.png)

## Install CodeServer

To install CodeServer we follow the steps from their [official documentation](https://github.com/cdr/code-server/blob/v3.7.3/doc/install.md):

```bash
curl -fsSL https://code-server.dev/install.sh | sh -s
```

All the necessary files will be installed under your home directory (`/home/ubuntu`), therefore, there is no need for `sudo` while installing CodeServer.

The next step is to perfor a first run of CodeServer and try to reach it via browser:

```bash
code-server --host 0.0.0.0
```

> 👉 The parameter `--host` is necessary to bind the 
> service to the machine's port. It is also important that
> such port is properly set up in the machine's
> _Security Group_ so **to be reachable from your IP**.

Then copy your EC2 Instance's _Public IPv4 DNS_ (see the step "check the machine statu") and paste it in your browser aiming to port `8080`:

```
# Run this in your machine's terminal:
echo "http://$(curl -s -m 0.1 http://169.254.169.254/latest/meta-data/public-hostname):8080"

# You should get something like:
# http://ec2-xx-xx-xx-xx.eu-west-1.compute.amazonaws.com:8080
```

> 👉 It is important that you use `http` (NOT `https`) as
> we don't have an SSL certificate yet installed.
> We'll do that later on.

If everything works fine, you should see the login screen:

![CodeServer Login](./cs-login.png)

In order to retrieve the auto-generated password you can run:

```bash
echo $(grep "password:" ~/.config/code-server/config.yaml | tail -1 | cut -c10-100)
```

> 👉 You need to stop the running process:
> 1. Use `Ctrl+c` to stop the running CodeServer
> 2. run the password command and copy it
> 3. start CodeServer again to be able to login

In order to change the default password, you can edit the file `~/.config/code-server/config.yaml`, then restart CodeServer.

When everything works, you should be able to login and verify that your CodeServer works fine:

![CodeServer Login](./cs-welcome.png)

## Run CodeServer as a Service

Looking at the [ufficial documentation](https://github.com/cdr/code-server/blob/v3.7.4/doc/install.md),
to run CodeServer as a resident service (resilient to the machine reboot) looks quite a trivial task:

```bash
sudo systemctl enable --now code-server@$USER
```

Nevertheless, if you just run it this way, your CodeServer won't be exposed to the Internet, because
the default configuration (`~/.config/code-server/config.yaml`) binds it to the localhost (`127.0.01`).

The following command will set CodeServer to any incoming traffic on port `8080` and restart the 
background process so to apply the changes,

```bash
sed -i 's/127.0.0.1:8080/0.0.0.0:8080/g' ~/.config/code-server/config.yaml
sudo systemctl restart code-server@$USER
```

You can check the contents that we applied to the configuration file with:

```bash
cat ~/.config/code-server/config.yaml
```

And, of course, you can revert the binding at any time, so to avoid exposing unnecessary surface for
attackers, by running the opposite `sed` instruction (we will do this later anyway):

```bash
sed -i 's/0.0.0.0:8080/127.0.0.1:8080/g' ~/.config/code-server/config.yaml
sudo systemctl restart code-server@$USER
```

> 👉 The next step would be to proxy Internet traffic to our CodeServer
> instance without exposing it directly. Hopefully this is an easy task
> with [Docker][docker] and [Traefik][traefik].

## Install Docker, DockerCompose, HumbleCLI

Installing [Docker][docker] is not a big deal any longer thanks to these
wonderful tutorials by [Digitalocean]:

- [How To Install and Use Docker on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- [How To Install and Use Docker on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)

Nevertheless, this is my compact recipe:

```bash
# Install Docker
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl enable --now docker

# Enable Docker for the "ubuntu" user
# (so that we don't have to run "sudo" with Docker)
sudo usermod -aG docker ubuntu

# You need to logout/login into your machine to apply
# the change to the user's rights:
exit
```

[Docker Compose][docker-compose] is much simpler than that and doesn't
require any kind of logout/login:

```bash
# Download the latest version from GitHub
sudo apt install -y jq
sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)/docker-compose-$(uname -s)-$(uname -m)"

# Make it executable:
chmod +x /usr/local/bin/docker-compose
```

Optionally, you may want to install [HumbleCLI][humble] which is a small
wrapper around DockerCompose and may facilitate the running of local projects:

```bash
git clone https://github.com/marcopeg/humble-cli.git /home/ubuntu/.humble-cli
sudo ln -s /home/ubuntu/.humble-cli/bin/humble.sh /usr/local/bin/humble
 ```

> 👉 The next step would be to leverage Docker so to proxy CodeServer
> to the standard port `80`...



## Notes

```bash
sudo systemctl status code-server@$USER
sudo systemctl stop code-server@$USER
sudo systemctl restart code-server@$USER
sudo systemctl disable code-server@$USER
systemctl list-units --type=service
lsof -i :8080
```

[docker]: https://www.docker.com/
[traefik]: https://traefik.io/
[digitalocean]: https://m.do.co/c/0a72735ae62e
[docker-compose]: https://docs.docker.com/compose/
[humble]: https://github.com/marcopeg/humble-cli
