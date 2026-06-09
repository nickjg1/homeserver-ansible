# Home Server Ansible Playbooks

Ansible playbooks to help you set up your own server at home.

These playbooks configure and update Ubuntu, install Docker, and deploy a full
stack of self-hosted services. They use Traefik as the reverse proxy and Authelia
for two-factor authentication. See the [services list](serviceslist.md) for
everything that's included. Every web service is reachable at
`https://<service>.<yourdomain>`.

> **Important:** set the SSL/TLS encryption mode to **Full** in Cloudflare.

## Contents

- [Quick start](#quick-start)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Configuration](#configuration)
- [Installation](#installation)
- [Notes and disclaimers](#notes-and-disclaimers)
- [Post-installation and troubleshooting](#post-installation-and-troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Credits and acknowledgments](#credits-and-acknowledgments)

## Quick start

For those already familiar with Ansible, the short version is:

```bash
# 1. Fork and clone, then install the required roles
git clone https://github.com/nickjg1/homeserver-ansible
cd homeserver-ansible
ansible-galaxy install -r requirements.yml

# 2. Fill in your config (see Configuration below)
$EDITOR group_vars/all/local.yml                 # host-specific, non-secret
ansible-vault create group_vars/all/vault.yml    # secrets
cp hosts/hosts.example hosts/hosts && $EDITOR hosts/hosts

# 3. Remove any services you don't want from roles/services/tasks/main.yml

# 4. Run it
ansible-playbook run.yml -K --ask-vault-pass
```

The rest of this README explains each step in detail.

## Prerequisites

To use these playbooks, you'll need a few things:

- Basic knowledge of internet protocols (SSH, TCP/UDP, etc.), Ansible, and Linux
- A fresh install of Ubuntu Server LTS 22.04 on the target machine
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) installed on the machine you'll run the playbooks from (your control node)
- A domain name
- A Cloudflare account with your domain's [nameservers](https://www.youtube.com/watch?v=uqlo3lCqiy0) pointed at Cloudflare's DNS servers
- A router with ports 80 and 443 forwarded to your server's IP address
- _(Optional)_ A [supported VPN](https://haugene.github.io/docker-transmission-openvpn/supported-providers/) — only needed if you keep the Transmission service

## Setup

Once Ubuntu is installed, you'll need an SSH key for Ansible to use. Create one
and copy it to the server with:

```bash
ssh-keygen -o -a 100 -t ed25519 -f <path to ssh file> -C <your_email>
ssh-copy-id -i ~/.ssh/homeserver <user>@<server>
```

Note: storing the SSH key at `~/.ssh/homeserver` is recommended.

Then fork this repository, clone it to your local machine, and install the
required roles:

```bash
git clone https://github.com/nickjg1/homeserver-ansible
ansible-galaxy install -r requirements.yml
```

## Configuration

All the variables you need to set are listed in
`group_vars/all/vars.yml.example`. They are split across three files:

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

Extra packages can be added in `group_vars/all/vars.yml`, and any unwanted
services can be removed from `roles/services/tasks/main.yml`. See
[variable help](variablehelp.md) for a description of every variable and how to
generate the secrets.

## Installation

Run this command, then enter your sudo password and vault password when prompted:

```bash
ansible-playbook run.yml -K --ask-vault-pass
```

## Notes and disclaimers

This playbook opens your server up to the internet and potentially malicious
attacks. Two-factor authentication, Cloudflare, and
[Jeff Geerling's security role](https://github.com/geerlingguy/ansible-role-security)
offer good layers of protection, but it's always good practice to be mindful of
the risks. Further configuration in Cloudflare can strengthen your security.

This also changes the default SSH listening port to 69. It can be changed in
`group_vars/all/vars.yml`.

The included Minecraft server runs Paper with Geyser and Floodgate, so Bedrock
players (console, mobile, Windows) can join the same world as Java players. See
the [services list](serviceslist.md) for ports.

## Post-installation and troubleshooting

If you need help setting services up or run into any issues with your
installation, see the [post-installation help](postinstallation.md).

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for how to file
issues and open pull requests.

## License

Released under the [MIT License](LICENSE).

## Credits and acknowledgments

This project is based heavily on
[Rishav Nandi's Ansible Homelab](https://github.com/rishavnandi/ansible_homelab).

- [Rishav Nandi](https://github.com/rishavnandi)
- [Jeff Geerling](https://github.com/geerlingguy)

---

_A note on history: the git history was reset to a single base commit to clean up
the repository. If you have a clone or fork from before this reset, please
re-clone (or reset your fork) to stay in sync with the current history._

_A note on AI: the original version of this repository was built and configured
in 2023 without the use of AI. The history reset and the cleanup and documentation
work that followed were done with AI assistance._
