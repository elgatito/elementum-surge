+++
title = "Use Elementum from outside"
description = "The JSON API, the Web UI, servers and Docker, and how to keep it safe"
weight = 4
menuPre = "<i class='fas fa-fw fa-plug'></i> "
+++

Elementum is a server: everything it does can be used over HTTP, by Kodi and by anything else on your network.
This section is for people who want to control Elementum from another app, a script, a TV, or run it on a server.

## One port, several interfaces

Elementum listens on one port, `65220` by default (`-localPort`, and `-localHost` to pick the address).
On it:

| Path | What | For |
|---|---|---|
| `/api` | The [JSON API]({{% relref "json-api.md" %}}), with an OpenAPI contract and Swagger UI at `/api/docs`. | Apps, scripts and integrations. **Use this.** |
| `/web` | The torrent [Web UI](#web-ui). | A browser on your network. |
| `/api/stream/...`, `/files/...` | The files being played, with HTTP Range. | Players. |
| Everything else | Routes of the Kodi add-on: they answer with Kodi list items and open Kodi dialogs. | The Kodi add-on only. They change with the add-on, don't build on them. |

## Web UI

Open `http://<elementum address>:65220/web/` in a browser to see and manage the torrents: add a magnet or a `.torrent` file,
pause, resume, remove, and play on a Kodi. It is served when Elementum has its add-on files (the Kodi add-on, or `-addonPath`).

## Logging in

Elementum has one optional login, `-localLogin` and `-localPassword`. In Kodi it is _Elementum → Configure → Addon Startup → Authorization → Remote host login / password_.

- Without a login, everyone who can reach the port can use everything.
- With a login, every interface asks for it with HTTP Basic auth: the JSON API, the Web UI and the Kodi routes.
  The JSON API answers a missing or wrong login with a JSON `401` and no `WWW-Authenticate` header, so browsers show no login popup.
- Playback links of the JSON API (`/api/stream/...`) need no login: they are signed and expire, see [Playback]({{% relref "json-api.md#playback" %}}).

## Security

Elementum is made for a network you trust, like your home network.

- **Set a login** on any network you do not fully trust, and never expose the port to the internet. Use a VPN to reach it from outside.
- A web page you visit cannot use Elementum's Kodi routes or the Web UI through your browser: Elementum refuses requests a browser makes
  for another site. The JSON API is open to every origin (CORS), as apps need it, so a login is what protects it.
- `/files/` has no login, so that players can open the files Elementum serves.
- Notifications sent to API clients can contain file paths or addresses from error messages.
- The [settings file]({{% relref "/configuration/elementum/command-line.md#settings-file" %}}) and the built-in search's `providers/settings.json` hold tokens and passwords: keep them private.

{{% pages description="true" display="cards" %}}
