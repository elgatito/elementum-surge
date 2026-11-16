+++
title = "Command-line options"
description = "Running Elementum yourself: flags, the settings file, client-server mode"
weight = 2
aliases = ["/configuration/command-line/"]
+++

Normally the Kodi add-on starts the `elementum` binary itself, and you don't need any of this.
You need it when you run Elementum **yourself**: on its own, on a NAS, in [Docker]({{% relref "/integrations/servers.md" %}}),
as a Linux daemon or Windows service, or for a platform that has no Elementum binary. See [Ways to run Elementum]({{% relref "/getting-started/ways-to-run.md" %}}).

The binary is inside the add-on zip, in `resources/bin/<platform>/elementum` (`elementum.exe` on Windows).

## Flags

Flags use one dash and `name=value` form, e.g. `-remoteHost=192.168.1.10`. Run `elementum -h` to see the list for your version.
Flags with a list type can be repeated, e.g. `-listenInterfaces=eth0 -listenInterfaces=wlan0`.

The list below is generated from the source of the latest release.

{{< cliflags >}}

Elementum keeps running when the program that started it ends (**server mode**) when `-configPath` or `-disableParentProcessWatcher` is set.

## Settings file

With `-configPath=<file>` Elementum reads its settings from a file instead of asking Kodi, so it runs without Kodi.
When `-configPath` is empty, the `ELEMENTUM_CONFIG_PATH` environment variable is used.

- **Kodi does this for you.** Since 0.1.120 the add-on writes all its settings to `settings.json` in Elementum's profile,
  starts the binary with `-configPath` pointing at it, and rewrites the file whenever you change a setting.
  `GET /api/system/info` says `"settings_source": "file"` then.
- **On your own**, point `-configPath` at a file that does not exist yet: Elementum creates it with default settings
  (taken from the add-on's `settings.xml` when `-addonPath` is set) and logs a warning. Then edit it.
- Elementum checks the file every 2 seconds. A valid change is applied at once; a broken file is logged and the previous settings stay.
  `GET /reload` reads it at once.
- Tokens and other values Elementum changes itself (Trakt, Simkl, MDBList, Scrob and OpenSubtitles tokens) are written back into the file (JSON only),
  and into Kodi when it is connected. A change of only these does not restart anything.
- The file holds tokens and passwords: keep it private. Elementum creates it readable by its owner only.

A JSON file looks like this (YAML works too, with lowercase keys):

```json
{
    "Version": 1,
    "Info": { "ID": "plugin.video.elementum", "Path": "/opt/elementum/", "Profile": "/var/lib/elementum/", "TempPath": "/tmp/elementum" },
    "Platform": { "OS": "linux", "Arch": "x64" },
    "Language": "en",
    "SecondLanguage": "",
    "Region": "US",
    "InterfaceLanguage": "en",
    "Settings": {
        "download_storage": 0,
        "download_path": "/srv/downloads",
        "library_path": "/srv/library",
        "buffer_size": 20,
        "providers_source": 1
    }
}
```

- `Info.ID`, `Info.Profile`, `Platform` and `Settings` are required.
- `Version` is the format of the file; Elementum refuses a newer one than it knows.
- `Language` is the metadata language, `InterfaceLanguage` the language of texts Elementum shows in Kodi.
- Keys in `Settings` are the IDs from [Kodi add-on settings]({{%relref "kodi-settings.md"%}}).
- Flags win over the file: `-downloadsPath` overrides `download_path`.

`-exportConfig=<file>` still writes the settings of a running Kodi setup to a file, as a starting point.

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
