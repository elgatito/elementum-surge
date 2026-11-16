+++
title = "Ways to run Elementum"
description = "Kodi add-on, server for Kodi, standalone, Docker, and server for other apps"
weight = 2
+++

Elementum is an application with an HTTP server, a torrent engine, a library and its own torrent search.
Running inside Kodi is one way to use it, not the only one.

| Mode | How it starts | Settings come from | Typical use |
|---|---|---|---|
| **Kodi add-on** (default) | The add-on starts the `elementum` binary next to Kodi, and stops it with Kodi. | Kodi's add-on settings, also written to a [settings file]({{% relref "/configuration/elementum/command-line.md#settings-file" %}}). | A normal Kodi setup. |
| **Server for Kodi** (client mode) | You start the binary on another machine, Kodi's add-on only talks to it. | Kodi's add-on settings, read over the network. | A weak Kodi box, or a platform without an Elementum binary (Xbox, iOS, tvOS). |
| **Standalone** | You start the binary with `-configPath`. No Kodi and no parent process needed. | A [settings file]({{% relref "/configuration/elementum/command-line.md#settings-file" %}}) (JSON or YAML). | A NAS or a server, used by [other apps]({{% relref "/integrations/_index.md" %}}). |
| **Docker** | The [elementum-docker](https://github.com/ElementumOrg/elementum-docker) image, in any of the modes above. | As the mode it runs in. | A server, or Windows and macOS hosts. See [Docker and servers]({{% relref "/integrations/servers.md" %}}). |
| **Server for other apps** | Any of the above. | As the mode it runs in. | The Samsung TV app, scripts and your own tools, through the [JSON API]({{% relref "/integrations/json-api.md" %}}). |

Everything is served on one port (`65220` by default, `-localPort`): the [JSON API]({{% relref "/integrations/json-api.md" %}}) under `/api`,
the routes the Kodi add-on uses, the torrent [Web UI]({{% relref "/integrations/_index.md#web-ui" %}}) under `/web`, and the files being streamed.

## What needs Kodi

Most of Elementum works without Kodi:

- browsing and searching movies and shows, people, genres and lists;
- **torrent search**, with the [built-in search]({{% relref "/burst/builtin.md" %}}) (Elementum 0.1.120 and later);
- tracker lists and linking a Trakt, Simkl, MDBList or Scrob account;
- the Elementum library, watched state, torrents, and playback in a client app.

These need a Kodi:

- **Kodi provider add-ons** such as Burst, if you prefer them to the built-in search ([which search is used]({{% relref "/burst/_index.md#which-search-is-used" %}}));
- **the Kodi library**: scanning, cleaning, and syncing watched state with Kodi's database;
- **playback inside Kodi**.

A standalone Elementum picks up a Kodi that starts later on the same machine, and runs the Kodi part of its start-up then.
