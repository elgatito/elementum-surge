+++
title = "How to override a provider"
description = "Change a provider or add your own, without changing Burst"
weight = 2
+++

There are a few ways to change a provider or add your own locally.
All files below go into Burst's data folder, _USERDATA/addon_data/script.elementum.burst/_.
See [where to find the USERDATA folder](https://kodi.wiki/view/Log_file/Advanced#Location).

### Add a custom provider with a JSON file

Put JSON files into _USERDATA/addon_data/script.elementum.burst/providers/_, each of them with provider definitions.
See [How to add a provider]({{% relref "create.md" %}}) for the definition format.

> [!NOTE]
> These providers are always _enabled_: Kodi add-on settings are static, so Burst can't add switches for them.

### Override a provider with a Python script

Create an _overrides.py_ file in _USERDATA/addon_data/script.elementum.burst/_, like this:

```python
overrides = {
    'torlock': {
        'name': 'MyTorLock'
    },
    'freshon.tv': {
        'tv_keywords': '{title} s{season:2}e{episode:2}'
    }
}
```

### Override a provider with a JSON file

The simplest way is a single _overrides.json_ file in _USERDATA/addon_data/script.elementum.burst/_, like this:

```json
{
    "rutor": {
        "name": "Bla-bla",
        "color": "red"
    },
    "yts": {
        "parser": {
            "name": "item('a', order=2)"
        }
    }
}
```

Open the [current definitions](https://raw.githubusercontent.com/elgatito/script.elementum.burst/master/burst/providers/providers.json),
copy the provider you need into _overrides.json_ and change it.
Or keep only the keys you change, so it's clear what you override.
