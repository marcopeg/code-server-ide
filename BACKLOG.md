# Backlog

- [x] Create DNS Entry at boot time
- [x] Send welcome email via Sendgrid API
- [x] Add reset password CLI script
- [ ] Add up/down/reboot script CLI script
- [ ] Add script to change machine layer (is it even feasible?)
- [ ] Collect the machine IP in the running environment at boot time
- [ ] Collect the machine EC2 in the running environment at boot time
- [ ] Provide `cs get ip` to get the public IP
- [ ] Provide `cs get id` to get the EC2 ID
- [ ] Install NodeJS via NVM
- [ ] Install AWS CLI
- [ ] Use automatic hostname from EC2
- [ ] Apply custom hostname to the machine
      https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html

# Known Issues

- [ ] Basic auth prevents the IDE from running on iPad
      (to make it run it's just a matter of disabling the Simple Auth and enable the Code Server auth)


## Add script to change machine layer

Is it possible to launch a AWS CLI command to reboot and change the machine tier?
