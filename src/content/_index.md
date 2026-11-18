+++
title = "Elementum"
type = "home"
description = "Elementum, the torrent streaming application for Kodi, servers and apps, and the LT2http streaming engine: installation, configuration, integrations, help and release notes."
+++

**Stream torrents in Kodi, on a server, or in your own app.** Documentation of the ElementumOrg projects: Elementum and the LT2http streaming engine.

## Elementum

Elementum finds movies and TV shows on torrent sites with its own [built-in search](burst/builtin/) or the [Burst](burst/) add-on,
starts playing while the torrent downloads, keeps a virtual library in Kodi and syncs your watch history with Trakt, Simkl, MDBList or Scrob.
It runs as a Kodi add-on, or on its own on a server or in Docker, and other apps — like the [TV app](integrations/tv-app/) for Samsung and LG TVs — use it through its [JSON API](integrations/json-api/).
Latest releases: Elementum **{{< version "plugin.video.elementum" >}}** · Burst **{{< version "script.elementum.burst" >}}** · Context **{{< version "context.elementum" >}}**.

{{< cards >}}
{{% card title="Install" icon="download" href="getting-started/installation/" %}}
Set up Elementum in Kodi in a few steps.
{{% /card %}}
{{% card title="Configure" icon="sliders" href="configuration/" %}}
Every add-on setting, and running the daemon on a server.
{{% /card %}}
{{% card title="Torrent search" icon="magnifying-glass" href="burst/" %}}
Built-in search and Burst: providers, private trackers, your own definitions.
{{% /card %}}
{{% card title="Use from outside" icon="plug" href="integrations/" %}}
JSON API, Web UI, Docker and servers.
{{% /card %}}
{{% card title="Context" icon="list" href="context/" %}}
Play any movie or episode in Kodi with Elementum.
{{% /card %}}
{{% card title="Get help" icon="life-ring" href="help/" %}}
FAQ, log files and reporting problems.
{{% /card %}}
{{% card title="What's new" icon="bullhorn" href="release-notes/elementum/" %}}
Changes in every release of Elementum.
{{% /card %}}
{{< /cards >}}

### Quick start

1. In Kodi, open _Settings → Services → Control_ and enable both **Application control** options (remote control).
2. Download the **ElementumOrg repository** zip from [Downloads](getting-started/platforms-page/) and install it with _Add-ons → Install from zip file_.
3. Open _Add-ons → Install from repository → ElementumOrg repository_ and install **Elementum**. It installs **Elementum Burst** for searching,
   or search with Elementum's own [built-in search](burst/builtin/).

More details and screenshots are in [Installation](getting-started/installation/).

## LT2http

Separate torrent download and streaming engine with an HTTP API, for your own add-ons, scripts and players.
Latest release: **{{< version "service.lt2http" >}}**.

{{< cards >}}
{{% card title="About LT2http" icon="server" href="lt2http/" %}}
What it is, the Kodi add-on, storage and running it yourself.
{{% /card %}}
{{% card title="HTTP API" icon="code" href="lt2http/#http-api" %}}
Add torrents, stream files and control the engine over HTTP.
{{% /card %}}
{{% card title="What's new" icon="bullhorn" href="release-notes/lt2http/" %}}
Changes in every release of LT2http.
{{% /card %}}
{{< /cards >}}

## All projects

{{< cards >}}
{{% card title="Downloads" icon="box-archive" href="getting-started/platforms-page/" %}}
Zip files of the repository and every add-on, for every platform.
{{% /card %}}
{{% card title="Release notes" icon="clock-rotate-left" href="release-notes/" %}}
Changes in Elementum, Burst, Context and LT2http.
{{% /card %}}
{{% card title="Contribute" icon="code-branch" href="contribute/" %}}
Source repositories, translations, docs and bug reports.
{{% /card %}}
{{< /cards >}}

> [!NOTE]
> Elementum is a community-driven open-source project: the source is open, you can fork it and [contribute back](contribute/).
> The authors do not take any responsibility for how users use this software.
