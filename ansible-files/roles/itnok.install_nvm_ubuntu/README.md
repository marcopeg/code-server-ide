install-nvm-ubuntu
===================

[![Build Status](https://travis-ci.org/itnok/ansible-role-install-nvm-ubuntu.svg?branch=master)](https://travis-ci.org/itnok/ansible-role-install-nvm-ubuntu) [![GitHub tag](https://img.shields.io/github/v/tag/itnok/ansible-role-install-nvm-ubuntu?sort=semver)](https://github.com/itnok/ansible-role-install-nvm-ubuntu/tags/) [![Ansible Role](https://img.shields.io/ansible/role/48278)](https://galaxy.ansible.com/itnok/install_nvm_ubuntu)

Install NVM & Node.js on an Ubuntu host.

Steps performed are:

  - Using role [itnok.manage_pkg_ubuntu](https://galaxy.ansible.com/itnok/manage_pkg_ubuntu):
    * Make sure git, curl, libssl-dev and build_essentials packages are installed
  - Find latest NVM release available
  - Prepare `~/.bashrc` for `install_nvm_user` to automagically source nvm.sh & bash auto-completion
  - Install NVM
  - Install Node.js
  - Set installed Node.js version as default _(if requested)_


## :exclamation: Requirements
-----------------------------

None.


## :abcd: Role Variables
------------------------

| Variable                        | Description                                         | Default Value       |
|---------------------------------|-----------------------------------------------------|---------------------|
| `install_nvm_node_set_default`  | Make installed Node.js version the current default  | `yes`               |
| `install_nvm_user`              | Install NVM for the specified user                  | `root`              |
| `install_nvm_node`              | Version of Node.js to install and set as default    | `node` _(latest)_   |
| `install_nvm`                   | Version of NVM to install                           | `latest`            |


## :link: Dependencies
----------------------

- [itnok.manage_pkg_ubuntu](https://galaxy.ansible.com/itnok/manage_pkg_ubuntu) _(:octocat: [ansible-role-manage-pkg-ubuntu](https://github.com/itnok/ansible-role-manage-pkg-ubuntu))_

To install dependencies use:
```
    $ ansible-galaxy install <dependecy.name>
```

Installation of the required Ansible Roles can also be simply addressed with:
```
    $ ansible-galaxy install -r requirements.yml
```


## :notebook: Example Playbook
------------------------------

Here an example of how to use this role in your playbooks:

```
---
- hosts: servers
  remote_user: ubuntu   # optional (your remote user)
  gather_facts: yes     # optional
  become: yes

  roles:
    - { role: itnok.install_nvm_ubuntu }

  vars:
    install_nvm_user: "ubuntu"
    install_nvm_node: "v12.16.2"
    install_nvm: "latest"
```

## :guardsman: License
----------------------

MIT _([read more](LICENSE.md))_
