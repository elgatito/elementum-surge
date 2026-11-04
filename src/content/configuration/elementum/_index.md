+++
title = "Elementum"
description = "Kodi add-on settings and the daemon's command-line options"
weight = 1
+++

## Two parts, two ways to configure

Elementum consists of two parts:

- **plugin.video.elementum** — the Kodi add-on (Python). It shows menus in Kodi and starts the daemon.
- **elementum** — the daemon (Go binary, shipped inside the add-on zip). It does the torrent streaming, library sync, Trakt/Simkl/MDBList sync and so on.

The daemon gets its configuration in one of two ways:

1. **From Kodi** (default). The add-on starts the daemon, and the daemon reads all add-on settings from Kodi over JSON-RPC.
   You change them in Kodi: _Add-ons → Elementum → Configure_.
   See [Kodi add-on settings]({{%relref "kodi-settings.md"%}}).
2. **From the command line and a config file** (server mode). You start the daemon yourself (Linux daemon, Windows service, Docker),
   pass options as command-line flags, and optionally load settings from a YAML/JSON file instead of asking Kodi.
   See [Command-line options]({{%relref "command-line.md"%}}).

Command-line flags are not Kodi settings: they control where the daemon listens, which paths it uses and how it finds Kodi.
Everything else (storage, BitTorrent, library, tracking, ...) is a Kodi setting, which in server mode can come from the config file.

{{% pages description="true" display="cards" %}}
