+++
title = "TV app"
description = "Elementum on Samsung and LG TVs: install, connect, use the remote"
weight = 3
+++

The Elementum TV app is a front-end you control with the TV remote. Browse movies and shows, search, pick a stream and play it on the TV.
It does not run Elementum itself: it talks to an Elementum on your network through the [JSON API]({{% relref "json-api.md" %}}).
The app is a separate project: [ElementumOrg/elementum-tizen](https://github.com/ElementumOrg/elementum-tizen).

{{% callout color="orange" %}}
**LG (webOS) support is experimental.** Nobody has tested it on a real LG TV yet. If you try it, please
[report how it went](https://github.com/ElementumOrg/elementum-tizen/issues/new/choose) (see [Reporting problems](#reporting-problems)).
{{% /callout %}}

## Requirements

- **Elementum 0.1.120 or newer** with its JSON API on port `65220`. Older releases have no API and the app cannot connect.
  Elementum can run as the Kodi add-on, on a server or in [Docker]({{% relref "servers.md" %}}), as long as the TV can reach it on the local network.
- **Kodi is optional.** Without it, Elementum uses its [built-in search]({{% relref "/burst/builtin.md" %}}), which you set up from the TV
  (_Settings → Built-in search settings_).
- A TV model of one of these:

| Platform | TV | Package |
|---|---|---|
| Samsung (Tizen) | Tizen 4.0 or newer (2018 models and later), in Developer Mode | `.wgt` |
| LG (webOS) | webOS 4.0 or newer (2018 models and later), in Developer Mode. **Experimental.** | `.ipk` |

Both packages are on [GitHub Releases](https://github.com/ElementumOrg/elementum-tizen/releases/latest).
Neither app is in a TV store, so you install it yourself ("sideload").

## Install

The step-by-step guide is [INSTALL.md](https://github.com/ElementumOrg/elementum-tizen/blob/main/INSTALL.md) in the app's repository. In short:

### Samsung

1. Turn on Developer Mode on the TV.
2. Install the `.wgt` with **Apps2Samsung** (recommended: it signs and installs the package for you), or with the Tizen CLI.

### LG

1. Install the **Developer Mode** app from the LG Content Store, sign in with an LG developer account, turn on Developer Mode and the key server, restart the TV.
2. Install the `.ipk` with one of:
   - [webOS Dev Manager](https://github.com/webosbrew/dev-manager-desktop) (recommended): add the TV and install the file.
   - The `ares-*` command line tools (`npm install -g @webos-tools/cli`).
   - Homebrew Channel, on rooted TVs.
3. The Developer Mode session **expires**, and when it does the TV removes sideloaded apps. Extend it in the Developer Mode app from time to time.
   Rooted TVs with Homebrew Channel have no expiry.

## First start

The app asks where Elementum is:

- **Address** and **port** of the machine that runs Elementum (`65220` by default).
- **Login** and **password**, if you set a login in Elementum. See [Logging in]({{% relref "_index.md#logging-in" %}}).

You can change them later in _Settings_.

## What it does

- Home rows (next up, trending, watchlist) and a library screen.
- Browse movies and shows, search, details, seasons and episodes.
- Posters show badges (library, collection, watchlist, watched) and progress.
- Trakt and other tracker lists, actor pages.
- A stream list with quality, codec, audio, size, seeds and provider.
- A player with seek and resume, and audio and subtitle switching.
- A torrents screen: progress, speed and peers, pause, resume, remove.
- Elementum's own notifications and questions appear on the TV.
- Settings for the server, the language and the [built-in search]({{% relref "/burst/builtin.md" %}}) (providers, logins of private trackers, filters, cookie sync).
- 22 languages. All but English are machine-drafted.

## Remote control

| Key | Action |
|---|---|
| Arrows | Move the focus |
| OK | Open or press |
| Long-press OK | Context menu of a movie or episode: add to or remove from the library, mark watched or unwatched |
| Back | Go back; at the home screen, asks to exit |
| Play, Pause, Stop | Control the player |
| Fast forward, Rewind | Seek 60 seconds (the player also seeks in 10 second steps) |
| Green | Next audio track |
| Yellow | Next subtitle track |
| Magic Remote pointer (LG) | Click presses. Hovering highlights buttons, sidebar entries and text fields. |

## Limitations

- **LG is untested on real TVs.** Whether subtitles and audio switching work on LG depends on what the TV makes available to the app. DTS audio may not play.
- **Samsung:** which video and audio codecs play depends on the TV model.
- The app is only a remote for Elementum: searching, downloading and storing happen on the Elementum machine.

## Security

- Elementum's login is **off by default**, so anyone on your network can use its API. [Set a login]({{% relref "_index.md#logging-in" %}}) and enter it in the app.
- The app stores the Elementum **password in plain text** on the TV.
- Logins of private trackers are sent to Elementum and stored there, not on the TV.
- Notifications on the TV can show file paths and error messages from the Elementum machine.
- Use it only on a network you trust and never expose the port to the internet. See [Security]({{% relref "_index.md#security" %}}).

## Updating

Install the newer release the same way as the first time. Settings are kept.
Update Elementum and the TV app together: a new app may need a newer Elementum.

## Troubleshooting

- **Cannot connect:** the TV and the Elementum machine must be on the same network. Check the address and port, that a firewall does not block the port,
  and that Elementum is 0.1.120 or newer. Opening `http://<address>:65220/api/docs` in a browser on your computer tells you if the API is reachable.
- **Login rejected:** enter the same login and password as in Elementum's settings.
- **No search results:** set up the [built-in search]({{% relref "/burst/builtin.md" %}}) in the app's settings, or choose it in Elementum.
- **The app vanished from an LG TV:** the Developer Mode session expired. Turn it on again, install the app again and extend the session.

## Reporting problems

Open an issue in [elementum-tizen](https://github.com/ElementumOrg/elementum-tizen/issues/new/choose).
LG users: use the **LG webOS report** template and say which TV model and webOS version you have and what worked. Reports are how LG support will leave "experimental".
