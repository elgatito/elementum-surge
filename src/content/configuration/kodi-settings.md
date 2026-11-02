+++
title = "Kodi add-on settings"
description = "Every setting in Add-ons → Elementum → Configure"
weight = 1
+++

These are the settings you see in Kodi, in _Add-ons → Elementum → Configure_.
The list is generated from the add-on's `settings.xml` of the latest release, so it is always in sync with the add-on.

- **Setting** is the name shown in Kodi (English).
- **ID** is the key used in `settings.xml`, in [exported config files]({{%relref "command-line.md#config-file"%}}) and in Kodi's `userdata/addon_data/plugin.video.elementum/settings.xml`.
- **Default** and **Values** show the default and the allowed values (for sliders, the range).
- Rows in _italics_ are hints Kodi shows inside the settings dialog.

Some settings are only visible when another one is enabled (for example, memory size only for the Memory storage).

{{< kodisettings >}}
