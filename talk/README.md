# CodeServer IDE Walkthrough Talk

- [ ] Create an EC2 machine with security group 22, 80, 443, 8080
- [ ] Install CodeServer & run it on 8080
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