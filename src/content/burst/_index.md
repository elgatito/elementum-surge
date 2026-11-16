+++
title = "Torrent search"
description = "The built-in search, the Burst add-on, providers and private trackers"
weight = 3
menuPre = "<i class='fas fa-fw fa-magnifying-glass'></i> "
+++

When you play a movie or an episode, Elementum searches torrent sites (trackers, called **providers**) for it.
There are two ways it can search, and both use the same providers:

- **The built-in search** (Elementum 0.1.120 and later). Elementum searches the providers itself, with no Kodi and no other add-on.
  It works in every [way to run Elementum]({{% relref "/getting-started/ways-to-run.md" %}}), including on a server and for the TV app.
  See [Built-in search]({{% relref "builtin.md" %}}).
- **The Burst add-on** (`script.elementum.burst`), a Kodi add-on that searches for Elementum when Kodi asks it.
  Choose providers in _Add-ons → Program add-ons → Elementum Burst → Configure_; all its settings are in [Configuration → Burst]({{% relref "/configuration/burst.md" %}}).
  Other Kodi add-ons named `script.elementum.*` work the same way.

Both know the same providers: Burst's `providers.json` is shipped with Elementum too, so a provider fixed in Burst is fixed in both.
Private trackers need a login, a passkey, or browser cookies through [cookie sync]({{% relref "cookie-sync.md" %}}).

## Which search is used

_Elementum → Configure → Providers → Search torrents with_ (`providers_source`):

| Value | Searches with |
|---|---|
| **Automatic** (default) | Kodi provider add-ons while Kodi is connected, the built-in search otherwise. Existing setups keep using Burst. |
| **Built-in search** | Only the built-in search. Elementum then stops installing Burst on its own. |
| **Provider add-ons** | Only Kodi provider add-ons, as before 0.1.120. |
| **Both** | Both; their results are merged. |

During the move from Burst to the built-in search both are kept up to date. When everybody uses the built-in search, Burst will be retired.

Burst is a fork of Quasar Burst.

{{% pages description="true" display="cards" %}}
