+++
title = "Docker and servers"
description = "Run Elementum in Docker, as a Linux daemon or a Windows service, for Kodi or on its own"
weight = 2
+++

Elementum does not need to run on the Kodi device. It can run on a NAS, a server or in Docker, and serve Kodi
devices, the TV app and other [apps]({{% relref "json-api.md" %}}) from there.

## Docker

The [elementum-docker](https://github.com/ElementumOrg/elementum-docker) repository has a Dockerfile and a Docker Compose service.
The image is built from an Elementum release zip, and keeps its data and downloads in two volumes.

```sh
git clone https://github.com/ElementumOrg/elementum-docker.git
cd elementum-docker
cp example.env .env      # set at least REMOTE_IP, ELEMENTUM_DOWNLOADS and ELEMENTUM_DATA
docker compose build
docker compose up -d
```

`ELEMENTUM_VERSION` in `.env` is the release that is built. The JSON API and the built-in search need **0.1.120** or later.

### As a server for Kodi

This is what the repository sets up: Kodi runs the add-on in client mode, and Elementum in the container reads its settings from that Kodi.

1. In Kodi, allow remote control (_Settings → Services → Control_, both _Application control_ options).
2. In _Elementum → Configure → Addon Startup_, turn on _Do not start binary (client mode)_ and set _Remote host_ to the address of the Docker host.
   See [Client-server mode]({{% relref "/configuration/elementum/command-line.md#client-server-mode" %}}).
3. In `.env`, set `REMOTE_IP` to the address of the Kodi device.

### On its own, without Kodi

To serve only apps (for example the TV app), let Elementum keep its settings in a file instead of asking a Kodi.
In `docker-compose.yml`, replace `-remoteHost` with a settings file in the data volume:

```yaml
    command:
      - -configPath=/home/ubuntu/elementum_data/settings.json
      - -localLogin=${ELEMENTUM_LOGIN}
      - -localPassword=${ELEMENTUM_PASSWORD}
```

On the first start Elementum creates the file with default settings; edit it and Elementum applies the change within a few seconds.
See [Settings file]({{% relref "/configuration/elementum/command-line.md#settings-file" %}}).
Torrent search then uses the [built-in search]({{% relref "/burst/builtin.md" %}}), whose settings are in the same volume, under `elementum_addon_data/providers/`.

### Networks

- **Linux** (Docker Engine): use `network_mode: host`. Several Kodi devices can use one server.
- **Windows and macOS** (Docker Desktop): containers sit behind NAT, so Elementum sees the gateway's address instead of the Kodi device's.
  Add `-serverExternalIp=<address of the Docker host>`; Elementum then uses `-remoteHost` as the Kodi address and that address in its replies.
  Only one Kodi device can use the server. On macOS use `network_mode: bridge` and publish port `65220`.
- Open the BitTorrent ports too, if your network needs it (Elementum's _Listen port_ settings, 6891–6899 by default).

### Library

To use the Kodi library, share the server's `elementum_data/elementum_library/` with Kodi (SMB or NFS) and add its `Movies` and `Shows`
folders as sources in Kodi, or share a Kodi folder with the server. Set `DISABLE_LIBRARY_SYNC=false`, and a
substitution of the Kodi path for the server path, `LIBRARY_SUBSTITUTION1=C:\Kodi\Library|/home/ubuntu/elementum_data/elementum_library`.

### Troubleshooting

- The log is `elementum.log` in the `ELEMENTUM_DATA` volume.
- `docker compose exec elementum bash` opens a shell in the running container; `nc -vz <kodi address> 65221` checks that it reaches Kodi.

## Linux daemon and Windows service

Run the `elementum` binary from the add-on zip (`resources/bin/<platform>/`) with the same options as the Docker image.
A systemd unit for a standalone Elementum:

```ini
[Unit]
Description=Elementum
After=network-online.target

[Service]
User=elementum
ExecStart=/opt/elementum/resources/bin/linux_x64/elementum \
    -addonPath=/opt/elementum/ \
    -configPath=/var/lib/elementum/settings.json \
    -profilePath=/var/lib/elementum/ \
    -downloadsPath=/srv/downloads/ \
    -logPath=/var/lib/elementum/elementum.log \
    -localLogin=user -localPassword=secret
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

`-addonPath` points at the unpacked add-on zip: Elementum takes its translations, default settings and the Web UI from there.
On Windows, a service manager such as NSSM can run `elementum.exe` with the same options.
All options are listed in [Command-line options]({{% relref "/configuration/elementum/command-line.md" %}}).
