+++
title = "Command-line options"
description = "Running lt2http yourself: options and the JSON config file"
weight = 2
+++

`lt2http` is a single binary, take it for your platform from [lt2http-binaries](https://github.com/ElementumOrg/lt2http-binaries).
Without options it listens on port `65225` on all interfaces and keeps torrent data in memory.

```sh
lt2http --help                                   # every option with its default value
lt2http --web_port=8080 --download_storage=file --download_path=/data/downloads
lt2http --config=lt2http.json --update           # create or update lt2http.json with all settings, then run with it
lt2http --config=lt2http.json                    # run with settings from lt2http.json
lt2http --write=lt2http.json                     # write the current settings to a file and exit
```

## Options

Options use two dashes and `name=value` (or `name value`) form. Booleans take `true` / `false` (or `1` / `0`), e.g. `--disable_dht=true`.
The list below is generated from the source of the latest release.
**In config file** tells whether the option can be set in the JSON file too.

{{< lt2httpoptions >}}

## Config file

With `--config` the settings are read from a JSON file. The keys are the option names, for example:

```json
{
  "web_port": 65225,
  "download_storage": "memory",
  "memory_size": 200,
  "auto_memory_size": false,
  "download_path": "/data/downloads",
  "buffer_size": 20,
  "proxy_enabled": false
}
```

- Keys missing in the file keep their defaults, so the file can contain only what you change.
- The easiest way to get a complete file is `--config=lt2http.json --update`: it writes every setting with its current value to the file.
- When the same setting is both in the file and on the command line, the file wins for most options, so change it in the file.
- `web_login` and `web_password` are not read from the file, pass them on the command line.

Set `web_login` and `web_password` when lt2http listens on a network interface, to protect the [API]({{% relref "/lt2http/_index.md#http-api" %}}).

Settings can also be read and changed at runtime with `GET /settings/get` and `POST /settings/set`.
