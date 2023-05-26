# Home Server Ansible Configuration

This repository contains Ansible files and configurations for managing and automating tasks on my home server. This playbook assumes a fresh install of Ubuntu Server 22.04.2 LTS.

## Setup

You will need to create an SSH key and copy it to the server. This can be done with the following commands:

```
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/homeserver -C <your_email>
ssh-copy-id -i ~/.ssh/homeserver <user>@<server>
```

Clone this repository to your local machine and run the following command to install the required roles:

```
git clone https://github.com/nickjg1/homeserver-ansible
ansible-galaxy install -r requirements.yml
```

Create a secret file in `group_vars/all/secret.yml` to store sensitive information such as passwords and API keys. Create a `secret_password` variable.

```
cd group_vars/all
ansible-vault create secret.yml
```

## Configuration

Make all the necessary changes to `group_vars/all/vars.yml` and `hosts` to match your environment. Extra packages and services can be added to `group_vars/all/vars.yml`.

## Running

Run this command and enter the vault and sudo password when prompted:

```
ansible-playbook run.yml --ask-vault-pass -K
```

## Credit

This uses [ansible-nas](https://github.com/davestephens/ansible-nas) to help with installation of services.
