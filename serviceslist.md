# Services List

These playbooks deploy the services below. Unless noted otherwise, each one is
served over HTTPS through Traefik at `https://<subdomain>.<yourdomain>` and sits
behind Authelia for authentication.

You don't have to run everything. Remove any service you don't want from
`roles/services/tasks/main.yml` before running the playbook.

## Reverse proxy and authentication

| Service | URL | Description |
| --- | --- | --- |
| Traefik | `traefik.<yourdomain>` | Reverse proxy and automatic TLS. Routes every other service and obtains Let's Encrypt certs via the Cloudflare DNS challenge. |
| Authelia | `auth.<yourdomain>` | Single sign-on and two-factor authentication that guards the other services. |

## Media

| Service | URL | Description |
| --- | --- | --- |
| Jellyfin | `jellyfin.<yourdomain>` | Media server for your movies, shows, and music. |
| Sonarr | `sonarr.<yourdomain>` | Manages and downloads TV shows. |
| Radarr | `radarr.<yourdomain>` | Manages and downloads movies. |
| Prowlarr | `prowlarr.<yourdomain>` | Indexer manager that feeds Sonarr and Radarr. |
| Seerr | `seerr.<yourdomain>` | Request portal for users to ask for new media. |
| Requestrr | `requestrr.<yourdomain>` | Chatbot for requesting media from Discord/Telegram. |
| Transmission | `transmission.<yourdomain>` | BitTorrent client, routed through a VPN. |
| Unmanic | `unmanic.<yourdomain>` | Optimises and re-encodes your media library. |

## Files, cloud, and productivity

| Service | URL | Description |
| --- | --- | --- |
| Nextcloud | `nextcloud.<yourdomain>` | Self-hosted file sync, calendar, and contacts. |
| Syncthing | `sync.<yourdomain>` | Peer-to-peer file synchronisation. Also uses ports `22000/tcp+udp` and `21027/udp` for sync traffic. |
| Filebrowser | `files.<yourdomain>` | Web file manager for browsing the server. |
| n8n | `n8n.<yourdomain>` | Workflow automation and integrations. |
| Code Server | `code.<yourdomain>` | VS Code in the browser. |
| Sure | `sure.<yourdomain>` | Self-hosted personal finance and budgeting app. Runs its own PostgreSQL and Redis. |

## Infrastructure and monitoring

| Service | URL | Description |
| --- | --- | --- |
| Portainer | `portainer.<yourdomain>` | Web UI for managing Docker containers. |
| Dashdot | `dash.<yourdomain>` | Live server resource dashboard (CPU, RAM, disk). |
| Monitoring | `grafana.<yourdomain>` | Grafana dashboards backed by Prometheus metrics. |
| Uptime Kuma | `uptime.<yourdomain>` | Uptime and status-page monitoring. |
| Diun | (notifications only) | Watches your Docker images and notifies you when updates are available. |
| Duplicati | `duplicati.<yourdomain>` | Scheduled, encrypted backups. |

## Network

| Service | URL | Description |
| --- | --- | --- |
| Pi-hole + Unbound | `pihole.<yourdomain>` | Network-wide ad blocking and a recursive DNS resolver. Serves DNS on port `53`. |
| WireGuard | `wg.<yourdomain>` | VPN server (wg-easy) for secure remote access to your network. Tunnel listens on `51820/udp`. |

## Security

| Service | URL | Description |
| --- | --- | --- |
| Vaultwarden | `vault.<yourdomain>` | Lightweight, self-hosted Bitwarden-compatible password manager. |

## Home and dashboard

| Service | URL | Description |
| --- | --- | --- |
| Home Assistant | `homeassistant.<yourdomain>` | Home automation hub. |
| Homarr | `homarr.<yourdomain>` | Customisable dashboard and launcher for all your services. |
| Guacamole | `guac.<yourdomain>` | Clientless remote desktop gateway (RDP/VNC/SSH in the browser). |

## Games

| Service | Ports | Description |
| --- | --- | --- |
| Minecraft | `25565/tcp`, `19132/udp` | Paper Minecraft server. Java players connect on `25565`; Bedrock players join through Geyser/Floodgate on `19132/udp` for crossplay. Not behind Traefik. |
