# Variable Help

This document explains every variable you need to set before running the playbook.

Variables live in three files (see `group_vars/all/vars.yml.example` for the full
template):

- `group_vars/all/vars.yml` (committed) holds shared, non-secret config. You
  usually do not need to edit it.
- `group_vars/all/local.yml` (gitignored) holds your host-specific, non-secret
  values.
- `group_vars/all/vault.yml` (gitignored, encrypted with ansible-vault) holds all
  secrets. Create it with `ansible-vault create group_vars/all/vault.yml`.

Copy the keys from `vars.yml.example` into the appropriate file and replace the
`<...>` placeholders with your own values. Keep the values inside the quotes.

## Host-specific values (put in `local.yml`)

`username`: Your Ubuntu username you chose at setup.

`puid`: Run the `id` command on your server and use the value in the `uid` field.

`pgid`: Run the `id` command on your server and use the value in the `gid` field.

`ip_address`: Your server IP address. Run `ip a` on your server to see it.

`timezone`: Your timezone. Run `timedatectl list-timezones` to see valid values.

`domain`: Your domain name.

`local_network`: Your local network in CIDR notation. Example: `192.168.0.0/16`.

`cloudflare_email`: The email you used to sign up for Cloudflare.

`authelia_admin_mail`: The admin email used in Authelia.

`vpn_provider`: The VPN provider you have an account with. See
[supported VPN clients](https://haugene.github.io/docker-transmission-openvpn/supported-providers/).

`vpn_config`: The VPN server you want Transmission to connect to. Example: `nl_all`.

`minecraft_ops`: Your Minecraft username(s), comma-separated, granted server op.

## Secrets (put in the encrypted `vault.yml`)

`user_password`: Your sudo password on the server.

`cloudflare_dns_api_token`: A Cloudflare API token scoped to your zone with
`Zone:DNS:Edit` and `Zone:Zone:Read` permissions. Create one under
[API Tokens](https://dash.cloudflare.com/profile/api-tokens). Use a scoped token,
not your global API key.

`traefik_basic_auth_hash`: Generate hashed login credentials with:

```bash
echo $(htpasswd -nb "<USER>" "<PASSWORD>") | sed -e s/\\$/\\$\\$/g
```

Replace `<USER>` and `<PASSWORD>` with your chosen values.

`jwt_secret`: A random alphanumeric string. Generate one with:

```bash
docker run authelia/authelia:latest authelia crypto rand --length 64 --charset alphanumeric
```

`authelia_session_secret`: Another random alphanumeric string. Use the command
above to generate one. Do not reuse other secrets.

`authelia_sqlite_encryption_key`: A random alphanumeric string with at least 20
characters. Use the command above to generate one. Do not reuse keys.

`authelia_admin_argon2id_pass`: A password hashed with the
[Argon2 algorithm](https://www.authelia.com/reference/guides/passwords/):

```bash
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password '<PASSWORD>'
```

`vaultwarden_admin_argon2id_pass`: Use the command above to generate a hashed
password. Do not reuse passwords.

`wg_password`: The password to log in to your WireGuard client.

`codeserver_password`: The password to log in to your code-server client.

`pihole_password`: The password to log in to your Pi-hole client.

`mysql_password`: The password for the MariaDB database.

`vpn_username`: The username for your VPN service.

`vpn_password`: The password for your VPN service.

`diun_ntfy_topic`: A hard-to-guess ntfy topic name for Diun image-update alerts.
On public ntfy.sh the topic name is the only access control, so treat it as a
secret. Subscribe to it in the ntfy app to receive notifications.

`homarr_encryption_key`: A 32-byte hex key for Homarr's at-rest encryption.
Generate one with `openssl rand -hex 32`.
