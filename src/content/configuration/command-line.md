+++
title = "Command-line options"
description = "Running the Elementum daemon yourself: flags, config file, client-server mode"
weight = 2
+++

Normally the Kodi add-on starts the `elementum` binary itself, and you don't need any of this.
You need it when you run the daemon **separately from Kodi**: on a NAS, in [Docker](https://github.com/ElementumOrg/elementum-docker),
as a Linux daemon or Windows service, or on a platform that has no Elementum binary.

The binary is inside the add-on zip, in `resources/bin/<platform>/elementum` (`elementum.exe` on Windows).

## Flags

Flags use one dash and `name=value` form, e.g. `-remoteHost=192.168.1.10`. Run `elementum -h` to see the list for your version.
Flags with a list type can be repeated, e.g. `-listenInterfaces=eth0 -listenInterfaces=wlan0`.

The list below is generated from the source of the latest release.

{{< cliflags >}}

The daemon runs in **server mode** when `-configPath` or `-disableParentProcessWatcher` is set.

## Config file

With `-configPath` the daemon does not ask Kodi for settings at all, it reads them from a file.
The easiest way to get such a file is to export it from a working setup:

1. Configure Elementum in Kodi as usual.
2. Start the daemon once with `-exportConfig=/path/to/elementum.yml` (plus `-remoteHost` if Kodi is on another device). It reads the settings from Kodi, writes them to the file and keeps running; stop it afterwards.
3. Edit the file if needed and start the daemon with `-configPath=/path/to/elementum.yml`.

The file has the add-on info, the platform and a `settings` map. Keys in `settings` are the
IDs from [Kodi add-on settings]({{%relref "kodi-settings.md"%}}), for example:

```yaml
settings:
  download_storage: 0       # 0 = File, 1 = Memory
  download_path: /data/downloads
  library_path: /data/library
  buffer_size: 20
```

Flags still win over the file: e.g. `-downloadsPath` overrides `download_path`.

## Client-server mode

Kodi runs the add-on in **client mode** and talks to a daemon running elsewhere.

On the server (where the daemon runs):

```sh
./elementum \
  -disableParentProcessWatcher \
  -remoteHost=192.168.1.20 \
  -localPort=65220 \
  -localLogin=user -localPassword=secret
```

`192.168.1.20` is the Kodi device. Add `-configPath=...` to keep settings in a file instead of reading them from Kodi.

In Kodi, in _Elementum → Configure → Addon Startup_:

| Setting | Value |
|---------|-------|
| Do not start binary (client mode) | On |
| Remote host | IP of the server |
| Remote port | `65220` (the server's `-localPort`) |
| Local port | `65221` (the server's `-remotePort`) |
| Remote host login / password | the server's `-localLogin` / `-localPassword` |

Restart Kodi after changing these. Kodi must allow remote control
(_Settings → Services → Control_, both "Allow remote control" options), so the daemon can reach Kodi's JSON-RPC.
