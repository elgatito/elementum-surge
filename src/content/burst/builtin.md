+++
title = "Built-in search"
description = "Elementum's own torrent search: providers, logins, filters, your own providers"
weight = 1
+++

Since 0.1.120 Elementum can search torrent sites itself, with the providers of Burst, without Kodi and without the Burst add-on.
It is what Elementum uses when it runs on its own or for the TV app, and in Kodi when you choose it in
_Elementum → Configure → Providers → Search torrents with_ (see [Which search is used]({{% relref "_index.md#which-search-is-used" %}})).

## Settings in Kodi

Open Elementum's main menu and choose **Built-in search settings**. Every line shows its current state under it:

| Entry | What it does |
|---|---|
| **Public providers** | Switch public trackers on and off. Burst's defaults are on: 1337x, BT4G, Knaben, The Pirate Bay, Torrentio and YTS. |
| **Private providers (need an account)** | The same for private trackers. One that is on without a login is marked _no login yet_ and is not searched. |
| **Logins, mirrors and cookies** | Per provider: username, password, passkey, a mirror (_Domain alias_: another domain or address of the same site), whether it is used for movies, shows or both, and browser cookies with the browser's User-Agent. |
| **General**, **Filtering**, **Resolution**, **Release type**, **Languages**, **Keywords**, **For Developers** | Burst's own settings, with Burst's defaults: results per provider and their order, size range, which resolutions and release types are kept, language priority, keyword filters, and parser debugging. |
| **Cookie sync** | Browser cookies through a GitHub Gist, both ways. See [Cookie sync]({{% relref "cookie-sync.md" %}}). |
| **Import settings from the Burst add-on** | Takes over Burst's settings (shown when Burst is installed). |

### Coming from Burst

On the first search from Kodi, or when you open the settings, Elementum offers to import the settings of the Burst add-on:
enabled providers, logins, mirrors, filters and cookie sync. It asks once. You can import again any time from the menu:
what Burst has replaces the same settings, everything else you set in Elementum stays.

Burst keeps its own settings, and keeps working when _Search torrents with_ uses provider add-ons.

### Filters

The filters are Burst's, with Burst's defaults. Out of the box they drop CAM, TeleSync, 3D, VHSRip, trailers, workprints and 240p,
and also names that have no resolution or release type at all. Change it in **Release type** and **Resolution**,
or turn off the check in **Filtering**. The season and episode check (**Filtering → Season and episode**) is off by default.

## Files

Everything of the built-in search is in `providers/` in Elementum's profile
(in Kodi: `userdata/addon_data/plugin.video.elementum/providers/`):

| File | What |
|---|---|
| `providers.json` | Optional. Your own **complete** set of providers, used **in place of** the one shipped with Elementum. |
| any other `*.json` | Optional. **Additions**: merged over the set key by key, in file name order. |
| `providers.default.json` | The set shipped with Elementum, written on every start. Copy from it, don't edit it. |
| `settings.json` | What you set: general options, each provider's settings, and whether Burst was imported. Holds passwords: keep it private. |
| `cookies.json` | Cookies the sites set, kept for the next searches. |
| `icons/` | Provider icons. Add `<id>.png` for a provider of your own. |

Changes to the definition files are read on the next start of Elementum; changes made in the settings dialog or the API apply at once.
How the shipped providers and icons get into Elementum is described in [Providers, icons and translations]({{% relref "/contribute/bundled-data.md" %}}).

## Your own providers

### Change a provider

An additions file needs only what changes. For example, `my.json` with a new address for YTS and a different name for 1337x:

```json
{
  "yts": { "base_url": "https://yts.example/api/v2/list_movies.json?query_term=QUERY&sort_by=seeds&order_by=desc" },
  "1337x": { "name": "1337x (mirror)" }
}
```

Objects are merged too: `{"yts": {"api_format": {"name": "title_english"}}}` changes one field of `api_format` and keeps the others.
For a different domain of the same site, a mirror in **Logins, mirrors and cookies** is simpler.

### Add a provider

A provider of yours is switched on as soon as its file is there:

```json
{
  "mytracker": {
    "name": "My Tracker",
    "color": "FF00A0FF",
    "language": "en",
    "base_url": "https://mytracker.example/search/QUERY",
    "separator": "+",
    "movie_keywords": "{title} {year}",
    "tv_keywords": "{title} s{season:2}e{episode:2}",
    "season_keywords": "{title} s{season:2}",
    "parser": {
      "row": [{ "css": "table.results > tbody > tr" }],
      "name": { "css": "td.name a" },
      "torrent": { "css": "td.name a", "attr": "href" },
      "size": { "css": "td:nth-child(3)" },
      "seeds": { "css": "td:nth-child(4)" },
      "peers": { "css": "td:nth-child(5)" }
    }
  }
}
```

Everything except `parser` and the login fields works as in Burst; see [Provider definition reference]({{% relref "definition.md" %}}):
search URLs and keywords, `api_format` for JSON APIs, `subpage`, `private` and the login keys, `language`, `filter_title`, and so on.

To find the right selectors, turn on **For Developers → Log debug messages for parsing**: the [log]({{% relref "/help/log.md" %}})
then has each page, how many rows `row` found, and what every field gave in each row.

### Parser fields

Burst's `parser` holds Python expressions; Elementum's holds JSON. A value is one of:

| Form | Example | Gives |
|---|---|---|
| CSS selector | `{"css": "td:nth-child(3) a", "attr": "href"}` | The first match inside the row (`"nth": 2` for the second, `0` for the last); its text, or the attribute in `attr`. |
| Burst's counting | `{"tag": "a", "nth": 2, "attr": "href"}` | The 2nd `<a>` of the row, counted the way Burst counts. `select` filters by attribute: `"select": [["class", ["seed", "seeders"]]]`. `divider` splits the value: `"divider": ["\|", 0]`. `in` looks inside the element its steps find first. |
| Text | `"https://example.org"` | The text itself. |
| An operation | `{"op": "format", "format": "https://mytracker.example%s", "arg": {"css": "a", "attr": "href"}}` | See below. |

`row` is a list of steps from the page to the rows: `{"css": "..."}` takes every match (or one with `nth`),
`{"tag": "tr", "all": true, "start": 2}` every `<tr>` from the second on, `{"tag": "table", "nth": 2}` one element.

Operations take their input from `arg`:

| `op` | Fields | Result |
|---|---|---|
| `format` | `format` | `format` with `%s` replaced by the value. |
| `concat` | `args` (list) | The values joined. |
| `replace` | `old`, `new` | The value with `old` replaced by `new`. |
| `split` | `sep`, `index`, `max` | One part of the value split at `sep`; negative `index` counts from the end. |
| `slice` | `from`, `to` | Characters from `from` to `to`; negative counts from the end. |
| `regex` | `pattern`, `group` | The group of the first match of a regular expression (Go syntax). |
| `resub` | `pattern`, `repl` | The value with every match replaced. |
| `unquote`, `upper` | | URL-decoded, or upper case. |
| `if` | `test`, `then`, `else` | `then` when `test` gives text, else `else`. `{"op": "exists", "in": [steps]}` tests that an element is there. |
| `key` | | The value of the page-wide `key` field. |

The login fields (`login_object`, `login_headers`, `post_data`, `headers`) are JSON objects instead of Python dicts:
`{"username": "USERNAME", "password": "PASSWORD", "returnto": "/"}`.

### Providers in Burst's format

`providers.default.json` is Burst's own file: each provider has Burst's Python expressions, and the same things in JSON under `builtin`,
which Elementum reads. A provider with Python expressions and no `builtin` part is listed as not supported.
To bring your Burst custom providers over, convert their file with Burst's script and put the result in `providers/`:

```sh
git clone https://github.com/elgatito/script.elementum.burst.git
python3 script.elementum.burst/scripts/builtin.py ~/my-providers.json
```

Burst's `overrides.py` is not read; write the overrides as an additions file.

## Settings over the API

Apps change the same settings through the [JSON API]({{% relref "/integrations/json-api.md" %}}):

| Call | What |
|---|---|
| `GET /api/providers` | Every provider: name, languages, private, enabled, whether searches use it now and why not, login, mirror. Passwords, passkeys and cookies are never returned. |
| `PUT /api/providers/{id}` | `{"enabled": true, "username": "...", "password": "...", "passkey": "...", "alias": "...", "contains": "movies", "cookies": "...", "user_agent": "..."}`; fields left out keep their value. |
| `GET /api/providers/options?lang=de` | The general options with their current value, default, group and label in that language. |
| `PUT /api/providers/options/{id}` | `{"value": ...}`, of the type of the option's default. |
| `POST /api/providers/cookie-sync/login` | Starts the GitHub sign-in of the cookie sync and answers with the code to show. |
| `GET /api/providers/cookie-sync/gists` | The Gists with cookies of the connected account; choose one with `PUT /api/providers/options/cookie_sync_gist_id`. |

## Differences from Burst

- Elementum reads JSON specs instead of Python expressions; everything Burst's shipped providers use has a JSON form.
- Requests go through Elementum's own network settings (proxy, DNS, the internal proxy with browser impersonation), not Burst's.
- The cookie sync Gist is read at most every five minutes, not before every search.
- Providers that need a request token (`token`) are not supported.
