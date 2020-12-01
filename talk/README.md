# CodeServer IDE Walkthrough Talk

- [x] Create an EC2 machine with security group 22, 80, 443, 8080
- [x] Install CodeServer & run it on 8080
- [ ] Run CodeServer as a Service
      (needed to offer direct ssh access to the machine)
- [ ] Install Docker, DockerCompose, HumbleCLI
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
http://ec2-xx-xx-xx-xx.eu-west-1.compute.amazonaws.com:8080
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

```bash
sudo systemctl enable --now code-server@$USER
```

