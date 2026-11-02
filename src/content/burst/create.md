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

Definitions are a JSON object, where each entry describes one provider.
There are no inherited or default settings: every setting of a provider has to be set explicitly.

Example of a provider definition:
```json
    "ilcorsaroblu": {
        "enabled": true,
        "predefined": false,
        "private": false,
        "name": "Il Corsaro Blu",
        "languages": "it",
        "anime_extra": "",
        "anime_keywords": "{title:original} {episode}",
        "anime_query": "",
        "base_url": "https://www.ilcorsaroblu.org/index.php?page=torrents&search=QUERYEXTRA&x=0&y=0",
        "color": "FFFFFFFF",
        "general_extra": "",
        "general_keywords": "{title:original}",
        "general_query": "0",
        "language": null,
        "login_failed": "",
        "login_object": "",
        "login_path": null,
        "movie_extra": "",
        "movie_keywords": "{title:original} {year}",
        "movie_query": "",
        "parser": {
            "row": "find_once(tag='table', select=('class', 'lista'), order=4).find_all('tr')",
            "name": "item(tag='td', order=2)",
            "seeds": "item(tag='td', order=7)",
            "peers": "item(tag='td', order=6)",
            "size": "item(tag='td', order=9)",
            "torrent": "'https://www.ilcorsaroblu.org/%s' % item(tag='a', attribute='href', order=3)"
        },
        "season_extra": "",
        "season_extra2": "",
        "season_keywords": "{title:original} Season_{season}",
        "season_keywords2": "{title:original} Season{season}",
        "season_query": "",
        "separator": "%20",
        "show_query": "",
        "subpage": true,
        "tv_extra": "",
        "tv_extra2": "",
        "tv_keywords": "{title:original} s{season:2}e{episode:2}",
        "tv_keywords2": "{title:original} s{season:2}"
    }
```

This part is very important:
```json
    "enabled": true,
    "predefined": false,
    "private": false,
    "name": "Il Corsaro Blu",
    "languages": "it",
```

The keys mean:

- `enabled`: _boolean_, whether the provider is available (available for selection, not necessarily selected for searching).
- `predefined`: _boolean_, whether the provider is enabled by default when Burst is installed (default providers).
- `private`: _boolean_, whether the provider is private, so Burst has to log in.
- `name`: _string_, name of the provider without special characters, shown in Kodi settings and search results.
- `languages`: _string_, languages used on the tracker, as a list of 2-letter codes (like `it, fr, en, es`). Can be omitted.
- `anime_extra`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `anime_keywords`: _string_, query for anime searches.
- `anime_query`: _string_, part of the URL, added to `base_url`.
- `base_url`: _string_, URL used for searches.
- `color`: _string_, Kodi color code, or a color name. See the [color chart](https://s3.amazonaws.com/f.cl.ly/items/1A3S2n0l103n460Y1I0e/chart.jpg).
- `general_extra`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `general_keywords`: _string_, query for general searches (when you type the query).
- `general_query`: _string_, part of the URL, added to `base_url`.
- `language`: _string_, 2-letter code of the language used for searches.
- `login_failed`: _string_, text that shows the login failed (best a unique text that only appears when not logged in).
- `login_object`: _string_, object used to log in. `USERNAME` and `PASSWORD` are replaced with the credentials.
- `login_path`: _string_, URL the login object is sent to with _POST_.
- `movie_extra`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `movie_keywords`: _string_, query for movie searches.
- `movie_query`: _string_, part of the URL, added to `base_url`.
- `parser`: _object_, defines how to parse the result page.
    - `row`: query for result rows, each of them is parsed for torrent information.
    - `name`: query for torrent name.
    - `seeds`: query for seeds count.
    - `peers`: query for peers count.
    - `size`: query for torrent size.
    - `torrent`: query for torrent file link or magnet link.
- `season_extra`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `season_extra2`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `season_keywords`: _string_, query for season searches.
- `season_keywords2`: _string_, query for season searches.
- `season_query`: _string_, part of the URL, added to `base_url`.
- `separator`: _string_, characters used to separate words in the query (like `%20` or `-`).
- `show_query`: _string_, string added to `base_url` for episode searches.
- `subpage`: _boolean_, whether the provider needs a separate request to open the _parser → torrent_ link and find the magnet or torrent link there.
- `tv_extra`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `tv_extra2`: _string_, text that replaces the `EXTRA` keyword in the search URL.
- `tv_keywords`: _string_, query for episode searches.
- `tv_keywords2`: _string_, query for episode searches.




### Search queries and fallbacks

Each search type (`movie`, `season`, `tv`, `anime`, `general`) can have several queries:

- `<type>_keywords`, `<type>_keywords2`, `<type>_keywords3`, `<type>_keywords4`: all of them are searched.
- `<type>_keywords_fallback`, `<type>_keywords_fallback2`, ... `_fallback4`: searched one by one, only while there are no results yet.
- `<type>_extra2`, `<type>_extra_fallback`, ... : the `EXTRA` text for the query with the same suffix.

Keywords such as `{title}`, `{title:original}`, `{title:en}`, `{year}`, `{season:2}`, `{episode:2}` are replaced with the item's data
(`:2` pads the number to two digits, `:en`/`:original` pick the title language).

### Other keys

Optional keys used by some providers:

- `root_url`: _string_, base address of the site, prepended to relative links and to `login_path`.
- `charset`: _string_, encoding of the query in the search URL, for sites that are not UTF-8 (e.g. `windows-1251`).
- `response_charset`: _string_, encoding of the site's pages, when it can't be detected.
- `post_data`: _string_, Python dict, sends the search as a POST request. `QUERY` in values is replaced with the query.
- `headers`: _string_, Python dict of extra HTTP headers for search requests.
- `login_headers`: _string_, Python dict of extra HTTP headers for the login request.
- `login_prerequest`: _string_, path to open before logging in (to get session cookies).
- `login_cookie`: _string_, name of the cookie that means "logged in". If it comes from [Cookie sync]({{%relref "cookie-sync.md"%}}), Burst skips the login form.
- `csrf_token`: _boolean_, take `csrf_token` from the login page and put it instead of `CSRF_TOKEN` in `login_object`.
- `filter_title`: _boolean_, drop results whose name doesn't match the searched title.
- `parser.infohash`: query for the info hash, lets Burst make a magnet link without opening the torrent.
- `parser.description`: query for extra text, added to the result name.
- `parser.referer`: query for the Referer header, used when opening the subpage.

### API providers

Some sites have a JSON API instead of HTML pages. For them set `"is_api": true`, and instead of `parser` describe the JSON with `api_format`:

```json
    "is_api": true,
    "base_url": "https://movies-api.example/api/v2/list_movies.json?query_term=QUERY",
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
```

- `results`: dotted path to the list of results in the response. Empty if the response itself is the list.
- `subresults`: key of a nested list inside each result (e.g. several torrents of one movie), each of them becomes a separate result.
- `name`, `description`, `quality`: name of the result, and texts added to the name. `name`, `description` and `quality` accept dotted paths.
- `torrent`, `info_hash`, `size`, `seeds`, `peers`: keys of the torrent link, hash, size and counters.

### Icon

Icon requirements are simple:

- 256x256 size
- Transparent background
- _PNG_ format

Name it `provider_id.png` and it will be used everywhere.

## Parsing rules

Burst uses the [ehp](https://github.com/iogf/ehp) parser. It is not an XPath parser, but it is fast and tolerant to broken HTML.

See existing definitions for examples. Usually you need:

* `find_once` to find one item;
* `find_all` to find a list of items (like rows);
* `item` to get something specific (like the name or a link).

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
