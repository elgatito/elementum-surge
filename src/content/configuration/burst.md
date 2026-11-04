+++
title = "Burst"
description = "Every setting in Add-ons → Elementum Burst → Configure"
weight = 2
+++

These are the settings of [Elementum Burst]({{% relref "/burst/_index.md" %}}), in _Add-ons → Program add-ons → Elementum Burst → Configure_.
Burst runs only inside Kodi, so they are set only there.
The values are stored in Kodi's `userdata/addon_data/script.elementum.burst/settings.xml`.

- **Setting** is the name shown in Kodi (English), **ID** is the key in `settings.xml`.
- **Default** and **Values** show the default and the allowed values (for sliders, the range).
- Rows in _italics_ are hints Kodi shows inside the settings dialog.

Each provider on the _Public trackers_ and _Private trackers_ tabs has a toggle `use_<provider>` (listed below, with the provider's language) and two settings shown when it is enabled,
not listed here to keep the page short:

- `<provider>_alias`: another domain to use for the provider, when the main one is blocked.
- `<provider>_contains`: use the provider only for movies, only for shows, or for all searches.

Provider definitions themselves can be changed with [overrides]({{% relref "/burst/override.md" %}}).

{{< kodisettings addon="script.elementum.burst" skip="_(alias|contains)$" >}}
