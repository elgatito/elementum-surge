+++
title = "Provider definition reference"
description = "Syntax of provider definitions in JSON, every key with its values and examples"
weight = 2
+++

A provider definition tells Burst how to search a site and how to read the results.
This page describes every key Burst understands. To create and test a provider, see [How to add a provider]({{% relref "create.md" %}}).

## File format

Definitions are a JSON object. Each key is the **provider ID**, and its value is the provider definition:

```json
{
    "my_tracker": {
        "name": "My Tracker",
        "base_url": "https://my-tracker.example/search?q=QUERYEXTRA",
        "...": "..."
    }
}
```

The provider ID is used in Kodi setting IDs (`use_my_tracker`, `my_tracker_username`, ...) and in the icon file name (`my_tracker.png`).
Use lowercase letters, digits, `-` and `_`.

Definitions are read from these places, in this order. Later files are merged into earlier ones key by key, so an override only needs the keys it changes:

| File | Purpose |
|------|---------|
| `burst/providers/providers.json` in the add-on | Providers shipped with Burst. |
| `USERDATA/addon_data/script.elementum.burst/providers/*.json` | Your own providers, always enabled. |
| `USERDATA/addon_data/script.elementum.burst/overrides.py` | Overrides in Python, see [How to override a provider]({{% relref "override.md" %}}). |
| `USERDATA/addon_data/script.elementum.burst/overrides.json` | Overrides in JSON. |

> [!NOTE]
> There are no inherited settings: apart from the few defaults listed below, a key that is missing is simply not used.

## How a search works

1. Elementum asks Burst for a **movie**, **episode**, **season**, **anime** episode, or a **general** (typed) search.
2. For each enabled provider, Burst takes `base_url` and appends the query part for that search type (for example `movie_query`).
3. It builds one or more queries from the keywords for that type (for example `movie_keywords`), filling in [placeholders](#keyword-placeholders) like `{title}` and `{year}`.
4. `QUERY` in the URL is replaced with the query, and `EXTRA` with the extra text for that type (for example `movie_extra`). Spaces become `separator`.
5. Burst logs in if needed, opens the URL and reads the results with the [`parser`](#html-parser) rules, or with [`api_format`](#api-providers) for JSON APIs.
6. Results go through Burst's filters (resolution, size, release type) and are sent to Elementum.

## General keys

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `name` | string | `""` | Name shown in Kodi settings and search results. No special characters. |
| `enabled` | boolean | `false` | `false` hides the provider completely: no setting and no searches. |
| `predefined` | boolean | `false` | Whether the provider is switched on by default after Burst is installed. |
| `private` | boolean | `false` | Whether the site needs a login, see [Login](#login-private-trackers). |
| `color` | string | | Color of the provider name in results: Kodi `AARRGGBB` hex (e.g. `FFF14E13`) or a color name (e.g. `red`). |
| `language` | string or `null` | `null` | 2-letter language of the site, e.g. `ru`. Used for `{title}` (see [keyword placeholders](#keyword-placeholders)) and as the language of results (`en` if not set). |
| `languages` | string | `""` | Comma-separated 2-letter languages of the site, e.g. `it, fr, en`. Titles in other languages get their accents removed. |

## Search URL

| Key | Type | Description |
|-----|------|-------------|
| `base_url` | string | Search URL with the `QUERY` and `EXTRA` [URL placeholders](#url-placeholders). Its scheme and host become `root_url`. |
| `movie_query` | string | Appended to `base_url` for movie searches. |
| `show_query` | string | Appended to `base_url` for episode searches. |
| `season_query` | string | Appended to `base_url` for season searches. |
| `anime_query` | string | Appended to `base_url` for anime searches. |
| `general_query` | string | Appended to `base_url` for general searches. |
| `separator` | string | Replaces spaces in the URL. Common values: `+`, `%20`, `-`, `_`. |
| `post_data` | string | Python dict: send the search as a POST request with these fields. `QUERY` and `EXTRA` in values are replaced, e.g. `"{'story': 'QUERY', 'do': 'search'}"`. |
| `headers` | string | Python dict of extra HTTP headers for search requests, e.g. `"{'upgrade-insecure-requests': '1'}"`. |
| `initial_url` | string | Page opened once before searching, to get cookies. Relative paths are added to `root_url`. |
| `filter_title` | boolean | Drop results whose name doesn't contain every word of the query. |

`root_url` is always set by Burst from `base_url`, so don't set it yourself. You can use it in other values, for example in `login_headers`.

### URL placeholders

Replaced in `base_url`, the `*_query` keys and `post_data`:

| Placeholder | Replaced with |
|-------------|---------------|
| `QUERY` | The search query, URL-encoded (in `charset` if it isn't UTF-8). |
| `EXTRA` | The extra text for the search type (`movie_extra`, `tv_extra`, ...), URL-encoded. |
| `FIRSTLETTER` | First letter of the query. |
| `TOKEN` | API token, see [`token`](#network-and-encoding). |
| `USERNAME` | Username from Burst settings (private trackers). |
| `PASSKEY` | Passkey from Burst settings (private trackers). Also replaced in torrent links. |

## Search queries

Each search type has its own set of keys. Replace `<type>` with:

| Search | `<type>` | Query part of the URL |
|--------|----------|----------------|
| Movie | `movie` | `movie_query` |
| Episode | `tv` | `show_query` |
| Season | `season` | `season_query` |
| Anime episode | `anime` | `anime_query` |
| General (typed text) | `general` | `general_query` |

| Key | Description |
|-----|-------------|
| `<type>_keywords` | Query, with [keyword placeholders](#keyword-placeholders). An empty or missing value means the provider isn't searched for this type. |
| `<type>_keywords2` … `<type>_keywords4` | More queries. All of them are searched. |
| `<type>_extra`, `<type>_extra2` … `<type>_extra4` | Text for `EXTRA` in the URL, for the query with the same number. |
| `<type>_keywords_fallback` … `<type>_keywords_fallback4` | Fallback queries, searched one by one, **only while there are no results yet**. |
| `<type>_extra_fallback` … `<type>_extra_fallback4` | `EXTRA` text for the fallback query with the same number. |
| `remove_special_characters` | Characters removed from titles, e.g. `"'"` turns `Grey's Anatomy` into `Greys Anatomy`. |

Identical queries are searched only once, and Burst stops starting new queries 3 seconds before the search timeout.

Example from 1337x: an episode is searched as `s01e02`, then, without results, as the whole season:

```json
"tv_keywords": "{title:original:en} s{season:2}e{episode:2}",
"tv_keywords_fallback": "{title:original:en} s{season:2}"
```

### Keyword placeholders

| Placeholder | Value |
|-------------|-------|
| `{title}` | The title. If _Use language preference from Kodi_ is on in Burst settings, the title in Kodi's language; otherwise in the provider's `language`; otherwise the original title. In general searches it's the typed text. |
| `{title:xx}` | The title in language or country `xx`: a 2-letter language (`en`, `ru`, `fr`, ...), a country code, `original`, or `jp` (romaji, for anime). Falls back to the original title. |
| `{title:xx:yy:...}` | One query for each listed language, plus one with `{title}`. E.g. `{title:en:ru:original}`. |
| `{year}` | Release year. If countries have different release years, the query is searched with each of them. |
| `{year:xx}` | Release year in country `xx`, or `original`. |
| `{season}`, `{episode}` | Season and episode number. |
| `{season:N}`, `{episode:N}` | Number padded to N digits: `{season:2}` → `01`. |
| `{season+N}`, `{episode+N}` | Number plus N: `{season+1}`. |
| `{absolute_episode}` | Absolute episode number (anime), also with `:N` and `+N`. Queries are skipped when it is unknown. |
| `{imdb_id}`, `{tmdb_id}`, `{tvdb_id}`, `{show_tmdb_id}` | IDs of the item, e.g. `tt0111161`. |

## HTML parser

For sites returning HTML, `parser` describes where to find the results.
Each value is a Python expression for the [ehp](https://github.com/iogf/ehp) HTML parser:

| Key | Required | Description |
|-----|----------|-------------|
| `row` | yes | Finds the result rows on the page. Starts from the page (`dom`), e.g. `find_once(tag='tbody').find_all('tr')`. |
| `name` | yes | Torrent name. |
| `torrent` | yes | Magnet link, torrent file link, or the link to a [subpage](#subpages). Relative links get `root_url` added. |
| `size` | | Size, e.g. `1.4 GB`. |
| `seeds` | | Seeds count. Thousand separators are fine. |
| `peers` | | Peers count. |
| `infohash` | | Info hash of the torrent. |
| `description` | | Extra text, added to the name as `name (description)`. |
| `referer` | | Referer header for the subpage request. |
| `key` | | Evaluated once per page, starting from `dom`. Its value is available as `key` in the other expressions. |

In all keys except `row` and `key`, `item` is the current row. `re` (Python regular expressions) is also available.

### Parser functions

| Function | Returns |
|----------|---------|
| `item(tag, order=1, select=None, attribute='text', divider=('', 1))` | Text or attribute of a tag inside the row. |
| `find_once(tag, select=None, order=1)` | One tag. Call it on `dom`, `item` or another tag. |
| `find_all(tag, select=None, every=1, start=1)` | List of tags. |

Parameters:

- `tag`: tag name, e.g. `'td'`, `'a'`.
- `order`: which match to take, counting from `1`. `0` is the last match, `-1` the one before last.
- `select`: attribute filter as a tuple, e.g. `('class', 'seedmed')`. The value matches one of the space-separated words of the attribute. A list matches any of its values: `('class', ['torrent', 'name'])`.
- `attribute`: `'text'` (the default) for the text, or an attribute name like `'href'` or `'title'`.
- `divider`: `(separator, index)` splits the value and takes one part, e.g. `('&', 0)` keeps everything before the first `&`.
- `start`: first match to return, e.g. `start=2` skips a header row.
- `every`: return every Nth match.

Since values are Python, you can combine and transform them:

```json
"torrent": "'https://www.1337x.to%s' % item(tag='a', attribute='href', order=2)",
"name": "item(tag='a', order=2) + ' [' + item(tag='img', attribute='title', order=1) + ']'",
"size": "re.search(r'Size: (.*?)\\n', item(tag='td', select=('class', 'descr'))).group(1)",
"infohash": "item(tag='a', attribute='href', order=3, divider=('&', 0)).replace('magnet:?xt=urn:btih:', '')"
```

### Subpages

Some sites only list links to torrent pages, with the magnet or download link on the page itself.

| Key | Type | Description |
|-----|------|-------------|
| `subpage` | boolean | `torrent` points to a page. Burst opens it and finds a magnet link, a `.torrent` link, an info hash or a known download link on it. |
| `subpage_mode` | string | `xhr`: request subpages like a browser script does (`X-Requested-With` header). |

Subpages are opened in parallel and cached during the search.

## API providers

For sites with a JSON API, set `is_api` and describe the response with `api_format` instead of `parser`:

| Key | Type | Description |
|-----|------|-------------|
| `is_api` | boolean | `true` for JSON APIs. |
| `api_format` | object | Where to find the values in the response, see below. |
| `download_path` | string | Added in front of the `torrent` value, e.g. `magnet:?xt=urn:btih:` when the API returns only info hashes. |

`api_format` keys:

| Key | Description |
|-----|-------------|
| `results` | Dotted path to the list of results, e.g. `data.movies`. Empty if the response itself is the list. |
| `subresults` | Key of a nested list in each result, e.g. several torrents of one movie. Each item becomes a result, with the fields of its parent. |
| `name` | Name. Dotted paths are supported. |
| `description` | Added to the name. Dotted paths are supported. |
| `quality` | Added to the name as `name - quality`. Dotted paths are supported. |
| `torrent` | Key of the magnet or torrent link. |
| `info_hash` | Key of the info hash. |
| `size` | Key of the size. Numbers are taken as bytes. |
| `seeds`, `peers` | Keys of the counters. |

Example, YTS:

```json
"yts": {
    "name": "YTS",
    "enabled": true,
    "predefined": true,
    "private": false,
    "color": "FF6AC045",
    "language": "en",
    "languages": "en",
    "is_api": true,
    "base_url": "https://movies-api.accel.li/api/v2/list_movies.json?query_term=QUERY&sort_by=seeds&order_by=desc",
    "movie_keywords": "{title:en:original}",
    "general_keywords": "{title}",
    "api_format": {
        "results": "data.movies",
        "subresults": "torrents",
        "name": "title_long",
        "description": "type",
        "quality": "quality",
        "torrent": "url",
        "info_hash": "hash",
        "size": "size",
        "seeds": "seeds",
        "peers": "peers"
    }
}
```

## Login (private trackers)

With `"private": true`, Burst shows _username_ and _password_ settings for the provider (for providers shipped with Burst), and logs in before searching:

| Key | Type | Description |
|-----|------|-------------|
| `login_path` | string | Login form URL, relative to `root_url` or absolute. |
| `login_object` | string | Python dict with the form fields. `USERNAME` and `PASSWORD` are replaced with the credentials, **without quotes** around them: `"{'login_username': USERNAME, 'login_password': PASSWORD}"`. |
| `login_failed` | string | Regular expression found on the page only when **not** logged in, e.g. the registration link. |
| `login_headers` | string | Python dict of headers for the login request. Can use `definition`, e.g. `"{'Referer': definition['root_url']}"`. |
| `login_prerequest` | string | Page opened before logging in, to get session cookies. |
| `csrf_token` | boolean | Read `csrf_token` from the login page and use it for `CSRF_TOKEN` in `login_object`. |
| `login_passkey` | boolean | Settings show a _passkey_ field instead of _password_, for trackers that use passkeys. |
| `login_cookie` | string | Name of the session cookie. If [Cookie sync]({{% relref "cookie-sync.md" %}}) provides it, Burst skips the login form. |

If a passkey is set, Burst doesn't log in: it puts the passkey into `PASSKEY` in the search URL and torrent links instead.

The session cookies are saved and sent with torrent downloads, so Elementum can download the torrent files.

Example, RuTracker (with cookie sync):

```json
"private": true,
"login_path": "/forum/login.php",
"login_object": "{'login_username': USERNAME, 'login_password': PASSWORD, 'login': 'Login'}",
"login_failed": "Регистрация",
"login_cookie": "bb_session"
```

## Network and encoding

| Key | Type | Description |
|-----|------|-------------|
| `charset` | string | Encoding of the query in the URL, for sites that aren't UTF-8, e.g. `windows-1251`. Default `utf8`. |
| `response_charset` | string | Encoding of the site's pages, when it can't be detected. |
| `opennic_dns_alias` | string | Address used instead of the site's domain when _OpenNIC DNS_ is on in Burst settings, e.g. `http://rutor.lib`. |
| `tor_dns_alias` | string | `.onion` address used when _Tor DNS_ is on in Burst settings. |
| `token` | string | Path added to `base_url` to get an API token. The JSON response must have a `token` field, used for `TOKEN` in the URL. |

Users can also set an _alias_ (another domain) for each provider in Burst settings. Burst then replaces the domain in every value of the definition.

## Complete example

A public HTML tracker, 1337x (some fallback queries left out):

```json
{
    "1337x": {
        "name": "1337x",
        "enabled": true,
        "predefined": true,
        "private": false,
        "color": "FFF14E13",
        "language": null,
        "languages": "en",
        "base_url": "https://www.1337x.to/search/QUERYEXTRA/1/",
        "separator": "+",
        "general_query": "",
        "general_keywords": "{title}",
        "general_extra": "",
        "movie_query": "",
        "movie_keywords": "{title:original:en} {year}",
        "movie_extra": "",
        "show_query": "",
        "tv_keywords": "{title:original:en} s{season:2}e{episode:2}",
        "tv_keywords_fallback": "{title:original:en} s{season:2}",
        "tv_keywords_fallback2": "{title:original:en} season {season}",
        "tv_extra": "",
        "season_query": "",
        "season_keywords": "{title:original:en} s{season:2}",
        "season_keywords2": "{title:original:en} season {season}",
        "season_keywords_fallback": "{title:original:en} {season:2}x01",
        "season_extra": "",
        "anime_query": "",
        "anime_keywords": "{title:original:en} s{season:2}e{episode:2}",
        "anime_keywords_fallback": "{title:original:en} s{season:2}",
        "anime_extra": "",
        "subpage": true,
        "parser": {
            "row": "find_once(tag='tbody').find_all('tr')",
            "name": "item('a', order=2)",
            "torrent": "'https://www.1337x.to%s' % item(tag='a', attribute='href', order=2)",
            "size": "item(tag='td', order=5)",
            "seeds": "item(tag='td', order=2)",
            "peers": "item(tag='td', order=3)",
            "infohash": ""
        }
    }
}
```

A search for _The Matrix (1999)_ opens `https://www.1337x.to/search/The+Matrix+1999/1/`. Then Burst reads the rows and opens each result page (`subpage`) to find the magnet link.

See [`providers.json`](https://github.com/elgatito/script.elementum.burst/blob/master/burst/providers/providers.json) for many more examples.
