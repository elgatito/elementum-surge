+++
title = "Providers, icons and translations"
description = "Where providers, provider icons, translations and default settings live, and how they get into Elementum"
weight = 1
+++

Elementum runs on its own, without the Kodi add-on or Burst next to it, so its binary contains a few files of those repositories:
the torrent providers and their icons from Burst, and the translations and default settings from the add-on.
Each of them is maintained in **one place only**, its own repository. Elementum's repository has no copy of them:
every build of Elementum fetches them.

| What | The one place (edit here) | Where the build puts it in Elementum |
|---|---|---|
| Providers | [script.elementum.burst](https://github.com/elgatito/script.elementum.burst) `burst/providers/providers.json` | `providers/burst/providers.json` |
| Provider icons | script.elementum.burst `burst/providers/icons/<id>.png` | `providers/burst/icons/<id>.png` |
| Translations | [plugin.video.elementum](https://github.com/elgatito/plugin.video.elementum) `resources/language/*/strings.po` | `ui/strings/<language>.po.gz` |
| Default settings | plugin.video.elementum `resources/settings.xml` | `config/default_settings.xml` |

## Building

`make bundle` (the script `scripts/bundle.sh`) fetches them all. Where from:

| | Takes |
|---|---|
| CI, and releases (`release.sh`) | The `master` branch of the add-on and Burst on GitHub. |
| `make bundle`, `make all` on your machine | Checkouts next to the Elementum one (`../plugin.video.elementum`, `../script.elementum.burst`), or the paths in `ELEMENTUM_ADDON_PATH` and `ELEMENTUM_BURST_PATH`; GitHub when there are none. So you can try a change of the add-on or Burst in Elementum before it is merged. |

`BUNDLE_SOURCE=github make bundle` always takes GitHub's `master`; `ADDON_REF` and `BURST_REF` pick another branch or tag.
The build log names the commit of each source, and says when a local checkout had uncommitted changes.

- `make all` fetches anew before building. A single platform (`make linux-x64`) and `make test` fetch only when the files are missing.
- `go build` and `go test` use what was fetched last. On a fresh checkout they fail with `pattern ...: no matching files found`
  until you run `make bundle` once.

So a change merged into the add-on or Burst reaches Elementum's users with the next Elementum release, with nothing to copy or commit in Elementum.

## Providers

One `providers.json` serves both searches: the Burst add-on and Elementum's [built-in search]({{% relref "/burst/builtin.md" %}}).

1. **Change the provider in Burst.** Edit `burst/providers/providers.json` as described in [How to add a provider]({{% relref "/burst/create.md" %}}).
2. **Write the `builtin` part.** Run `make builtin` in Burst. It turns the provider's Python expressions into the JSON that Elementum reads,
   under `builtin` (see [The `builtin` part]({{% relref "/burst/definition.md#the-builtin-part" %}})). Burst's CI fails when you forget it.
3. **Release Burst** for the users of the Burst add-on.
4. **Merge it.** The next Elementum release takes it from Burst's `master`; there is nothing to do in Elementum.

At run time Elementum takes the providers built into it, or the user's own `providers.json` instead, and merges the user's additions over them
(see [Built-in search → Files]({{% relref "/burst/builtin.md#files" %}})). It writes the built-in set to `providers/providers.default.json`
in its profile on every start, so users can copy from it.

## Provider icons

- **Source:** one PNG per provider in Burst's `burst/providers/icons/`, named after the provider ID (`yts.png`), 256×256.
- **Build:** `make bundle` takes the icons of the providers in `providers.json` and scales them down to 96×96, so 78 icons take about 0.7 MB
  in the binary. Scaling needs Python's Pillow; without it they are taken as they are, 256×256.
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

**Build:** `make bundle` puts every `strings.po` into the binary (gzipped, about 440 KB for 22 languages).

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
3. Run `make bundle` in Elementum to try it. Nothing to commit there: the next build takes it from the add-on.

Fixing a translation needs only step 1; until Elementum is released, the add-on's newer file is used where it is installed.

## Default settings

When Elementum runs [without Kodi]({{% relref "/configuration/elementum/command-line.md#settings-file" %}}) and creates its settings file,
it takes the default of every setting from the add-on's `resources/settings.xml`: from the add-on's folder with `-addonPath`,
else from the one built into it, taken from the add-on by the build.
