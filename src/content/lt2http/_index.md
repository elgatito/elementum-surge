+++
title = "LT2http"
description = "LibTorrent-to-HTTP: torrent download and streaming engine with a REST API"
weight = 6
menuPre = "<i class='fas fa-fw fa-server'></i> "
+++

**LT2http** ([lt2http](https://github.com/ElementumOrg/lt2http)) is a torrent download and streaming engine with an HTTP API.
It downloads torrents with [libtorrent](https://www.libtorrent.org/), can keep the data in memory instead of on disk,
and streams any file of a torrent over HTTP while it downloads, to Kodi, a browser or any media player.

It's a separate project from Elementum: Elementum has its own engine and does not need LT2http.
Use LT2http when you want a lightweight torrent streaming backend for your own scripts, add-ons or players.
Latest release: **{{< version "service.lt2http" >}}**.

## Parts

| Project | What it is |
|---|---|
| [lt2http](https://github.com/ElementumOrg/lt2http) | The engine: a C++ web server built on libtorrent, Boost and Oat++. |
| [lt2http-binaries](https://github.com/ElementumOrg/lt2http-binaries) | Prebuilt `lt2http` binaries for every platform. |
| [service.lt2http](https://github.com/ElementumOrg/service.lt2http) | Kodi add-on that runs the binary as a Kodi service and passes your Kodi settings to it. |

## In Kodi

Install **LT2http** from the ElementumOrg repository, or download the zip from [Downloads]({{% relref "/getting-started/platforms-page.md#lt2http-downloads" %}}).
As with Elementum, enable both _Application control_ options in _Settings → Services → Control_ first.

The add-on has no browsing interface yet: it starts `lt2http` when Kodi starts, stops it when Kodi exits,
downloads the right binary for your platform after an update, and restarts the engine when you change settings.
Other add-ons use it through the API at `http://127.0.0.1:65225`.

Settings are in _Add-ons → Services → LT2http → Configure_, every one of them is listed in
[Configuration → LT2http]({{% relref "/configuration/lt2http/kodi-settings.md" %}}).

## Storage

- **Memory**: only the part around the playback position is kept in memory, the disk stores just the `.torrent` file.
  That's what makes LT2http work on devices with little or slow storage. 100 MB is enough on devices with 1 GB of RAM, 200-250 MB on bigger ones.
  By default the size is chosen from the physical memory and grows for heavy torrents.
- **File**: usual files on disk, the selected file's full size must be free.

## Running it yourself

`lt2http` is a single static binary, take it for your platform from [lt2http-binaries](https://github.com/ElementumOrg/lt2http-binaries).
By default it listens on port `65225` on all interfaces.

Every setting is a command-line option and a key in the JSON config file, see
[Command-line options]({{% relref "/configuration/lt2http/command-line.md" %}}).
Set `web_login` and `web_password` to protect the API when it listens on a network interface.

## HTTP API

The API answers in JSON, except the browser pages. Interactive docs (Swagger) are on `http://localhost:65225/swagger/ui`
and the OpenAPI spec on `/api-docs/oas-3.0.0.json`. The main endpoints:

| Endpoint | What it does |
|---|---|
| `GET /status` | Session status: speeds and torrents. |
| `GET /info` | Status page for a browser: torrents, files, trackers and pieces. |
| `GET /service/add/uri?uri=…` | Add a torrent by magnet link, `.torrent` URL or local path. |
| `POST /service/add/file` | Add a `.torrent` file. |
| `GET /torrents` | List torrents. |
| `GET /torrents/{infoHash}/files` | List files of a torrent. |
| `GET /torrents/{infoHash}/files/{index}/status` | Download and buffering progress of a file. |
| `GET /torrents/{infoHash}/files/{index}/stream/{file_name}` | Stream a file, with range requests for seeking. Give this URL to the player. |
| `GET /torrents/{infoHash}/pause`, `/resume`, `/remove` | Control a torrent. |
| `GET /settings/get`, `POST /settings/set` | Read or change settings at runtime. |
| `GET /changelog` | Changes in each release. |
| `GET /shutdown` | Stop the engine. |

## Source and building

LT2http is open source. Build instructions, dependencies and Docker cross-compilation are in the
[lt2http README](https://github.com/ElementumOrg/lt2http#readme). Report problems with the engine in
[lt2http issues](https://github.com/ElementumOrg/lt2http/issues) and with the Kodi add-on in
[service.lt2http issues](https://github.com/ElementumOrg/service.lt2http/issues).
