+++
title = "How to add a provider"
description = "Write a provider definition for Burst"
weight = 1
+++

## Preparation

Each provider consists of a definition in the _providers.json_ file in the _/burst/providers/_ folder, and an icon in the _/burst/providers/icons/_ folder.

The icon is optional, but very welcome: it is easier to find a relevant search result when providers look different.

To add a new provider:

- Fork the [script.elementum.burst](https://github.com/elgatito/script.elementum.burst) repository on GitHub.
- Clone your fork: `git clone git@github.com:yourusername/script.elementum.burst.git`
- Create a new branch, e.g. `git checkout -b my_provider`
- Make your changes to _providers.json_.
- Push them to GitHub with `git push origin my_provider`
- GitHub will offer to open a pull request, so your changes can be included in Burst.

> [!NOTE]
> Please try not to change the Python code of Burst.
> If you have no other option, run `flake8` before you commit: it does basic syntax and code checks and should finish without errors.

### Definition

Each provider is an entry in _providers.json_. Start from a similar existing provider, and see the
[Provider definition reference]({{% relref "definition.md" %}}) for every key, the search placeholders, the parser syntax and examples.

### Icon

Icon requirements are simple:

- 256x256 size
- Transparent background
- _PNG_ format

Name it `provider_id.png` and it will be used everywhere.

## Parsing rules

Burst uses the [ehp](https://github.com/iogf/ehp) parser. It is not an XPath parser, but it is fast and tolerant to broken HTML.
See [HTML parser]({{% relref "definition.md#html-parser" %}}) for the functions and their parameters.

## Debugging

See [where Kodi keeps its files](https://kodi.wiki/view/Log_file/Advanced#Location).

### Python code

Copy your cloned repository into Kodi's add-on folder and run a search from Kodi: it uses the new code without restarting Kodi,
so you can quickly try changes and check the results.

On Linux it's something like:

`cp -rf /path/to/your/repo/* ~/.kodi/addons/script.elementum.burst/`

### Parser

To debug the parser, enable verbose logging in _Burst settings → Advanced → Log debug messages for parsing_.
The log then shows which parser rules run and what they match.

### Enabling providers

A new provider is not enabled for searching by default, you have to enable it in Kodi settings.
Run `./scripts/generate_settings.py` to regenerate the _settings.xml_ file, copy it to Kodi and restart Kodi (Kodi reads _settings.xml_ only on start or when the add-on is installed).

Custom providers (not shipped with Burst) are always enabled, and can't be enabled or disabled in settings.
