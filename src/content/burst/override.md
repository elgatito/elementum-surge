+++
title = "How to override provider"
description = ""
weight = 2
+++

<!--more-->

## Ways

There are few ways to override some provider or add one locally.

Locations can be discovered here: https://kodi.wiki/view/Log_file/Advanced#Location

### Adding custom provider from json file

You can add json files into *USERDATA/addon_data/script.elementum.burst/providers/*, each of them should contains provider description.

*USERDATA* directory can be discovered here: https://kodi.wiki/view/Log_file/Advanced#Location
Provider description syntax can be found here: [How to add provider]({{%relref "create.md"%}})

Be aware, that those providers are _enabled by default_! Kodi does not let making flexible addon settings, they are static.

### Overriding provider definition with Python script

Another way to override provider definition is the Python script.
It should be an _overrides.py_ file in your *USERDATA/addon_data/script.elementum.burst/* directory.

And it should look like this:
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

### Overriding provider definition with JSON file

The simpliest way to override provider definitions is the unified Json file.
It is the _overrides.json_ file in *USERDATA/addon_data/script.elementum.burst/* directory.

Should look like this:
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

You can open actual definitions, located here: https://raw.githubusercontent.com/elgatito/script.elementum.burst/master/burst/providers/providers.json

Find the one you need, copy into _overrides.json_ file, and make you modifications. 

Or leave only modified columns, to see what you change.

