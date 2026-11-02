+++
title = "Updating"
description = "How updates work and how to fix a broken update"
weight = 4
+++

## How it works

Updates come from the **ElementumOrg repository** add-on:

- Elementum installs and enables the repository on its first start, if it isn't installed yet.
  If the repository is installed but disabled, enable it like any other add-on.
- The repository is a small service that serves the latest GitHub releases of Elementum, Burst and Context to Kodi,
  so Kodi updates them like add-ons from any other repository.
- The repository installs the small _client_ zip of Elementum. On its next start, Elementum downloads the binary for your platform only.

> [!WARNING]
> Don't use third-party repositories to install or update Elementum, unless you know they provide the _all platforms_ package, which contains every binary.

If Elementum works fine, update it as usual, or let Kodi do it automatically.
If it doesn't start after an update, download the Elementum zip from [Downloads]({{% relref "platforms-page.md" %}}) and install it from the zip.
There's no need to uninstall the add-on first.
