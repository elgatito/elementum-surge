+++
title = "Elementum"
description = "Kodi add-on settings, the settings file and command-line options"
weight = 1
+++

## Two parts

Elementum consists of two parts:

- **plugin.video.elementum** — the Kodi add-on (Python). It shows menus in Kodi and starts the application.
- **elementum** — the application (a Go binary, shipped inside the add-on zip). It does the torrent search and streaming, the library,
  Trakt/Simkl/MDBList/Scrob sync, and serves the [JSON API]({{% relref "/integrations/json-api.md" %}}). It also runs on its own, see [Ways to run Elementum]({{% relref "/getting-started/ways-to-run.md" %}}).

## Where settings come from

1. **From Kodi.** You change settings in Kodi, _Add-ons → Elementum → Configure_, see [Kodi add-on settings]({{%relref "kodi-settings.md"%}}).
   Since 0.1.120 the add-on also writes them to a settings file and starts the binary with it; older versions let the binary read them from Kodi.
2. **From a settings file**, when you run the binary yourself with `-configPath`. See [Settings file]({{%relref "command-line.md#settings-file"%}}).

Command-line flags are not settings: they control where Elementum listens, which paths it uses, its login, and how it finds Kodi.
Everything else (storage, BitTorrent, library, tracking, providers, ...) is a setting.
The built-in search keeps its own settings, see [Built-in search]({{% relref "/burst/builtin.md" %}}).

{{% pages description="true" display="cards" %}}
