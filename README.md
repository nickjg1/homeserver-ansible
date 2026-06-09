# Home Server Ansible Playbooks

## Ansible Playbooks to help you set up your own server at home

These playbooks will configure and update Ubuntu, install Docker, and deploy the containers.
It uses Traefik as it's reverse proxy manager and Authelia for Two Factor Authentication. See the services list [here](serviceslist.md). All of the services will be accessible at https://\<service>.\<yourdomain>

**Important**: Make sure you set SSL/TLS encryption mode to **full** in Cloudflare.

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

## Configuration

All the variables you need to set are listed in `group_vars/all/vars.yml.example`. They are split across three files:

- `group_vars/all/vars.yml` (committed) holds shared, non-secret config. You usually do not need to edit it.
- `group_vars/all/local.yml` (gitignored) holds your host-specific, non-secret values.
- `group_vars/all/vault.yml` (gitignored, encrypted) holds your secrets.

Set up your configuration:

```bash
cd homeserver-ansible

# 1. Host-specific values: create local.yml and fill in the host section of vars.yml.example
$EDITOR group_vars/all/local.yml

# 2. Secrets: create the encrypted vault and fill in the secret section of vars.yml.example
ansible-vault create group_vars/all/vault.yml

# 3. Inventory: copy the example and set your server's address
cp hosts/hosts.example hosts/hosts
$EDITOR hosts/hosts
```

Extra packages can be added in `group_vars/all/vars.yml`. Any unwanted services can be removed from `roles/services/tasks/main.yml`. See [variable help](variablehelp.md) for a description of every variable and how to generate the secrets.

## Notes and Disclaimers

This playbook opens your server up to the internet and potentially malicious attacks. Two factor authentication, Cloudflare and [Jeff Geerling's Security Role](https://github.com/geerlingguy/ansible-role-security) offer good layers of protection, but it's always good practice to be mindful of the risks. Further configuration in Cloudflare can strengthen your security.

This also changes the default listening port of SSH to 69. It can be changed in `group_vars/all/vars.yml`.

## Installation

Run this command, enter your sudo password and vault password when prompted:

```bash
ansible-playbook run.yml -K --ask-vault-pass
```

## Post Installation and Troubleshooting

If you need help setting services up or have any issues with your installation, see [post installation help](postinstallation.md).

## Credit

- [Rishav Nandi](https://github.com/rishavnandi)
- [Jeff Geerling](https://github.com/geerlingguy)
