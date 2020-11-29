# Backlog

- [x] Create DNS Entry at boot time
- [x] Send welcome email via Sendgrid API
- [x] Add reset password CLI script
- [x] Add up/down/reboot script CLI script
- [ ] Add script to change machine layer (is it even feasible?)
- [ ] Collect the machine IP in the running environment at boot time
- [ ] Collect the machine EC2 in the running environment at boot time
- [x] Provide `cs get ip` to get the public IP
- [x] Provide `cs get id` to get the EC2 ID
- [x] Install NodeJS via NVM
- [x] Install AWS CLI
- [x] Use automatic hostname from EC2
- [ ] Apply custom hostname to the machine
      https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
- [x] Block auto start in case of manual DNS handling
- [x] Install CTOP
      https://github.com/bcicen/ctop

# Known Issues

- [ ] Basic auth prevents the IDE from running on iPad
      (to make it run it's just a matter of disabling the Simple Auth and enable the Code Server auth)


## Add script to change machine layer

Is it possible to launch a AWS CLI command to reboot and change the machine tier?
