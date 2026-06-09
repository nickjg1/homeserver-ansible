# Post Installation Help

This guide covers accessing your services after the playbook finishes, the
first-time setup a few services need, and how to troubleshoot common problems.

## Accessing your services

Every web service is reachable at `https://<service>.<yourdomain>` (see the
[services list](serviceslist.md) for the subdomain of each one). The first time
you open a protected service you will be redirected to the Authelia login page.

Log in with the admin account that was created from your variables:

- **Username:** `admin`
- **Password:** the password you hashed into `authelia_admin_argon2id_pass`

Authelia will then send you back to the service you requested. You only need to
log in once per session.

## First-time setup per service

Most services work straight away. These few need a little setup the first time.

### Authelia

The playbook seeds a single `admin` user. To add more users, edit the Authelia
users database on the server at
`<docker_dir>/authelia/config/users_database.yml` and restart the container:

```bash
docker restart authelia
```

Generate password hashes for new users with:

```bash
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password '<password>'
```

### Vaultwarden

Open `https://vault.<yourdomain>` and create your account. Once your account
exists, lock the instance down so no one else can register: open the admin page
at `https://vault.<yourdomain>/admin` (log in with the token you set in
`vaultwarden_admin_argon2id_pass`) and disable new signups under **Settings**.

### Nextcloud

On first load, create the admin account when prompted. If you see a "trusted
domain" warning, add `nextcloud.<yourdomain>` to the trusted domains list in
`<docker_dir>/nextcloud/config/config.php`, then reload.

### Pi-hole

Log in at `https://pihole.<yourdomain>/admin` with the password from
`pihole_password`. To actually block ads network-wide, point your router's (or
clients') DNS at the server's IP address.

### Jellyfin

Open `https://jellyfin.<yourdomain>` and complete the setup wizard: create your
user, then add libraries pointing at your media folders under `<docker_dir>`.

### The *arr stack (Sonarr / Radarr / Prowlarr)

1. In **Prowlarr**, add your indexers, then add Sonarr and Radarr as
   applications so indexers sync automatically.
2. In **Sonarr** and **Radarr**, add **Transmission** as the download client
   (host `transmission`, port `9091`).
3. Set your root media folders in each.

### Guacamole

The image ships with the default login `guacadmin` / `guacadmin`. **Change this
password immediately** after your first login, then add your RDP/VNC/SSH
connections.

### WireGuard

Open `https://wg.<yourdomain>` (wg-easy) and log in with `wg_password`. Add a
client to generate a config or QR code. For remote access to work, forward
`51820/udp` on your router to the server.

### Minecraft

Java players connect to `<yourdomain>` (or your server IP) on port `25565`.
Bedrock players (console, mobile, Windows 10/11) connect on port `19132` thanks
to Geyser and Floodgate, which are installed automatically. Make sure both ports
are forwarded on your router, or expose them through a tunnel. Operators are set
from the `minecraft_ops` variable.

If you can't (or don't want to) forward ports on your router, [playit.gg](https://playit.gg)
is a free tunnelling service that gives your server a public address. Create a
tunnel for the Java port (`25565/tcp`) and another for the Bedrock port
(`19132/udp`), then share the addresses it gives you with your players.

### Home Assistant

Open `https://homeassistant.<yourdomain>` and complete the onboarding wizard to
create your account and add integrations.

## Services behind Authelia

Every service is protected by Authelia, but each one's policy is set in the
`access_control` rules in `roles/services/tasks/authelia.yml`. Most services are
set to `two_factor` (you log in through Authelia), and a few are set to `bypass`
because they have their own login or are used by apps that can't pass through
Authelia.

This matters because Authelia's interactive login can't be completed by native
apps, API clients, or incoming webhooks. Those requests just get bounced to the
login page. The following services are already set to `bypass` for that reason:

- **Vaultwarden** — browser extensions and mobile apps use its API.
- **Nextcloud** — desktop/mobile sync, WebDAV, and CalDAV/CardDAV use app passwords.
- **Seerr** — has its own Jellyfin-based login.

If you access any of these through a non-browser client, expect to set its policy
to `bypass` too:

| Service | What breaks behind Authelia |
| --- | --- |
| Jellyfin | Native apps (TV, console, mobile) — only the web player works through Authelia. |
| Home Assistant | The companion mobile app and webhooks/API. |
| n8n | Incoming webhooks from external services. |
| Uptime Kuma | Push-type monitors that external services ping. |
| Sonarr / Radarr / Prowlarr / Transmission | External API or mobile apps (e.g. LunaSea, nzb360). Internal communication between these containers is unaffected — it uses the Docker network by container name and never passes through Traefik. |

Services like Syncthing and WireGuard are unaffected even though their web UI is
gated: their actual traffic (Syncthing on `22000`, WireGuard on `51820/udp`) goes
directly to the container and never touches Authelia.

To relax a service, change its rule in the `access_control` block from
`policy: two_factor` to `policy: bypass`. The service keeps its own login. To gate
the UI but allow API/webhook traffic, add a path-scoped `bypass` rule (for example
for `/api` or `/webhook`) above the domain's main rule.

## Troubleshooting

### Services show an invalid or "Traefik default" certificate

Traefik obtains certificates through Cloudflare's DNS challenge. If you get the
default self-signed cert:

- Confirm `cloudflare_dns_api_token` is a scoped token with `Zone:DNS:Edit` and
  `Zone:Zone:Read` on your domain.
- Check `<docker_dir>/traefik/data/acme.json` is mode `0600`. Traefik silently
  refuses to use it if the permissions are more open than that.
- Check the Traefik logs: `docker logs traefik`.

### Pages load with a redirect loop or "too many redirects"

Set the SSL/TLS encryption mode to **Full** in your Cloudflare dashboard. Flexible
mode conflicts with the HTTPS redirect Traefik performs.

### A service returns 502 Bad Gateway

The container is probably still starting or unhealthy. Check it with:

```bash
docker ps
docker logs <container_name>
```

Some containers (like Guacamole) have a slow health check and only appear once
they report healthy.

### You can't SSH into the server

These playbooks change the SSH port to **69** as part of hardening. Connect with:

```bash
ssh -p 69 <user>@<server>
```

The port is set by the `ssh_port` variable in `group_vars/all/vars.yml` if you
want to change it.

### Transmission won't connect / no downloads

Transmission runs through a VPN. Double-check `vpn_provider`, `vpn_config`,
`vpn_username`, and `vpn_password`. If the VPN can't connect, the container will
restart in a loop. Check `docker logs transmission`.

### Re-running the playbook

The playbook is idempotent, so it's safe to run again after fixing a variable or
adding a service:

```bash
ansible-playbook run.yml -K --ask-vault-pass
```
