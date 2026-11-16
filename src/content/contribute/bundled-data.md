+++
title = "Providers, icons and translations"
description = "Where providers, provider icons, translations and default settings live, and how they get into Elementum"
weight = 1
+++

Elementum runs on its own, without the Kodi add-on or Burst next to it, so it carries copies of a few files from those repositories:
the torrent providers and their icons from Burst, and the translations and default settings from the add-on.
Each copy has one source. Changes are made there, and copied into Elementum with `go generate`.

| What | Source (edit here) | Copy in Elementum | Copied by |
|---|---|---|---|
| Providers | [script.elementum.burst](https://github.com/elgatito/script.elementum.burst) `burst/providers/providers.json` | `providers/burst/providers.json` | `go generate ./providers/burst` |
| Provider icons | script.elementum.burst `burst/providers/icons/<id>.png` | `providers/burst/icons/<id>.png` | the same |
| Translations | [plugin.video.elementum](https://github.com/elgatito/plugin.video.elementum) `resources/language/*/strings.po` | `ui/strings/<language>.po.gz` | `go generate ./ui` |
| Default settings | plugin.video.elementum `resources/settings.xml` | `config/default_settings.xml` | `go generate ./config` |

The copies are built into the `elementum` binary. Elementum's CI fails when one of them differs from the `master` branch of its source,
except the icons (they are scaled, see below).

The `go generate` steps look for the other repositories next to the Elementum checkout (`../script.elementum.burst`, `../plugin.video.elementum`).
Set `ELEMENTUM_BURST_PATH` or `ELEMENTUM_ADDON_PATH` to use another place.

## Providers

One `providers.json` serves both searches: the Burst add-on and Elementum's [built-in search]({{% relref "/burst/builtin.md" %}}).

1. **Change the provider in Burst.** Edit `burst/providers/providers.json` as described in [How to add a provider]({{% relref "/burst/create.md" %}}).
2. **Write the `builtin` part.** Run `make builtin` in Burst. It turns the provider's Python expressions into the JSON that Elementum reads,
   under `builtin` (see [The `builtin` part]({{% relref "/burst/definition.md#the-builtin-part" %}})). Burst's CI fails when you forget it.
3. **Release Burst** for the users of the Burst add-on.
4. **Copy it into Elementum.** In the Elementum checkout run `go generate ./providers/burst`. It copies the file as it is, and the icons.
   Commit both; the change reaches users of the built-in search with the next Elementum release.

At run time Elementum takes the providers built into it, or the user's own `providers.json` instead, and merges the user's additions over them
(see [Built-in search → Files]({{% relref "/burst/builtin.md#files" %}})). It writes the built-in set to `providers/providers.default.json`
in its profile on every start, so users can copy from it.

## Provider icons

- **Source:** one PNG per provider in Burst's `burst/providers/icons/`, named after the provider ID (`yts.png`), 256×256.
- **Copy:** `go generate ./providers/burst` scales them down to 96×96 (it needs Python's Pillow; without it the icons are left as they are)
  and copies only the icons of providers in `providers.json`. 78 icons take about 0.7 MB in the binary.
  The scaled files differ slightly between Pillow versions, which is why CI does not compare them.
- **At run time** Elementum writes them to `providers/icons/` in its profile and gives each search result the icon of its provider.
  Kodi gets the path as Kodi sees it: when Elementum runs in WSL next to a Kodi on Windows, `/mnt/c/...` becomes `C:\...`.
  Browsers (the Web UI) get it through Elementum's HTTP server. The JSON API does not return provider icons.
- **Icons of your own providers:** put `<id>.png` into `providers/icons/` yourself. Icons of built-in providers there are replaced on start.

## Translations

All of Elementum's texts are translated in the add-on's `resources/language/`: `messages.pot` has the English texts with their ids,
and `resource.language.<code>/strings.po` the translation of each language. They are translated there, for the add-on and for Elementum.

Elementum's code refers to a text in two ways:

- `LOCALIZE[30xxx]` with the string id, optionally with arguments: `LOCALIZE[30287];;Matrix` fills `%s` with `Matrix`.
- For the built-in search, the English text itself: `ui/texts.go` maps it to its id.

**Copy:** `go generate ./ui` copies every `strings.po` into the binary (gzipped, about 440 KB for 22 languages).

**Which file is used:**

1. The add-on's own files, when Elementum knows the add-on's folder (it runs from Kodi, or with `-addonPath`). They may be newer than the binary.
2. The copy in the binary, for every text the add-on's files lack, and for everything when there is no add-on folder.
3. English, when a language does not have the text; the text as it was given, when nobody has it.

**Which language:**

| Texts for | Language |
|---|---|
| Kodi | The language Kodi shows: the add-on sends it with every request (`X-Kodi-Language`), else Kodi's language from the settings (`InterfaceLanguage`). Elementum translates before sending, so Kodi gets finished texts. |
| Apps (JSON API) | The `lang` parameter of the request, else Elementum's language. |

Elementum's language setting (`language`) is the language of movie and show information, which can differ from Kodi's.

### Adding a text

1. In the add-on, give it the next free id in `resources/language/messages.pot`, add it to every `resource.language.*/strings.po`
   (with an empty `msgstr` in `en_gb`), and translate it. `./scripts/xgettext.sh` checks the files.
2. In Elementum, use `LOCALIZE[<id>]`, or for the built-in search add the English text and its id to `ui/texts.go` and use `ui.Text`.
3. Run `go generate ./ui` in Elementum and commit the copy.

Fixing a translation needs only steps 1 and 3; until Elementum is released, the add-on's newer file is used where it is installed.

## Default settings

When Elementum runs [without Kodi]({{% relref "/configuration/elementum/command-line.md#settings-file" %}}) and creates its settings file,
it takes the default of every setting from the add-on's `resources/settings.xml`: from the add-on's folder with `-addonPath`,
else from the copy built into it. After a change of the add-on's settings, run `go generate ./config` in Elementum and commit the copy.
