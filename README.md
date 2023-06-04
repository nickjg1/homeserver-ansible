# Home Server Ansible Playbooks

## Ansible Playbooks to help you set up your own server at home

These playbooks will configure and update Ubuntu, install Docker, and deploy the containers.
It uses Traefik as it's reverse proxy manager and Authelia for Two Factor Authentication. See the services list [here](serviceslist.md).

## Acknowledgments

This project is based heavily on [Rishav Nandi's Ansible Homelab.](https://github.com/rishavnandi/ansible_homelab)

## Prerequisites

In order for you to use these playbooks, you'll need a couple things:

- Basic knowledge of internet protocols (SSH, TCP/UDP etc.), Ansible and Linux
- Router with ports 80 and 443 forwarded to your servers IP address
- Google Account
- Domain name
- Cloudflare account with your domain name [nameservers](https://www.youtube.com/watch?v=uqlo3lCqiy0) pointed to their DNS Servers
- A [supported VPN](https://haugene.github.io/docker-transmission-openvpn/supported-providers/) to use with Transmission
- A fresh install of Ubuntu Server LTS 22.04

## Setup

Once you've installed Ubuntu, you'll need an SSH Key for Ansible to use. You will need to create an one and copy it to the server. This can be done with the following commands:

```bash
ssh-keygen -o -a 100 -t ed25519 -f <path to ssh file> -C <your_email>
ssh-copy-id -i ~/.ssh/homeserver <user>@<server>
```

Note: I'd recommend storing the ssh file at `~/.ssh/homeserver`

Fork this repository, then clone it to your local machine and run the following command to install the required roles:

```bash
git clone https://github.com/nickjg1/homeserver-ansible
ansible-galaxy install -r requirements.yml
```

Change directories and create an ansible vault file with the following command and enter a password when prompted:

```bash
cd homeserver-ansible
ansible-vault create group_vars/all/vault.yml
```

Open the vault file with the following command:

```bash
ansible-vault edit group_vars/all/vault.yml
```

Paste the following into the vault file and replace the values with your own:

```yaml
user_password: "<your sudo password>"
```

## Configuration

Make all the necessary changes to the `group_vars/all/vars.yml` and `hosts/hosts` files to match your environment. Extra packages can be added to `group_vars/all/vars.yml`. Any unwanted services can be removed in the `services/tasks/main.yml` file. See [variable help](variablehelp.md) for more information.

## Notes and Disclaimers

This playbook opens your server up to the internet and potentially malicious attacks. Two factor authentication, Cloudflare and [Jeff Geerling's Security Role](https://github.com/geerlingguy/ansible-role-security) offer good layers of protection, but it's always good practice to be mindful of the risks. Further configuration in Cloudflare can strengthen your security.

This also changes the default listening port of SSH to 69. It can be changed in `group_vars/all/vars.yml`.

## Installation

Run this command and enter the sudo password when prompted:

```bash
ansible-playbook run.yml -K --ask-vault-pass
```

Enter the vault and sudo passwords when prompted.

## Post Installation and Troubleshooting

If you need help setting services up or have any issues with your installation, see [post installation help](postinstallation.md).

## Credit

- [Rishav Nandi](https://github.com/rishavnandi)
- [Jeff Geerling](https://github.com/geerlingguy)
