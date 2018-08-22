+++
title = "How to add provider"
description = ""
weight = 1
+++

<!--more-->

## Preparation

Each provider consists of a definition in _definitions.json_ file in _/burst/providers/_ folder and an icon in _/burst/providers/icons/_ folder.

Icon is optional, but very much desired. It is easier to quickly find relevant search result, when you visually differ providers.

If you want to try adding new provider, the workflow is about that:

- Fork Github repository from https://github.com/elgatito/script.elementum.burst
- Clone the Github repository: `git clone git@github.com:yourusername/script.elementum.burst.git`
- Change the branch from _master_ to anything else like `git checkout -b my_provider` 
- Do your changes to _definitions.json_ 
- Push changes to Github with `git push origin my_provider` 
- Github will give you a note that you can make a Pull Request, so your changes are included in the Burst code.
- Done!

> Please, try not to make changes in the Python code of Burst. 

> If you feel you have no other option - run `flake8` before you commit. 

> It will do basic syntax and code checks. Should run without errors.

### Definition

Definitions are a JSON list of a smaller parts, each of them describes separate providers. 
There are no inherited settings, or default settings, each provider's setting should be explicitly setted.

Example of provider definition:
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

Where columns mean:

- `enabled`: _boolean_, defines if provider is available (not selected to search, but available for selection).
- `predefined`: _boolean_, defines if provider is enabled by default upon installation of Burst (default providers).
- `private`: _boolean_, defines if provider is private, so login should be executed.
- `name`: _string_, name of provider, no special characters, name will be shown in Kodi settings and search results.
- `languages`: _string_, languages used on the tracker, 2-char codes list of languages (like `it, fr, en, es`), can be ommited.
- `anime_extra`: _string_, text, later replaced into EXTRA keyword in search url.
- `anime_keywords`: _string_, query for anime searches.
- `anime_query`: _string_, part of url, added to `base_url`.
- `base_url`: _string_, URL, used for further uses in searches.
- `color`: _string_, Kodi color code. Can be substituted with word representation. See: https://s3.amazonaws.com/f.cl.ly/items/1A3S2n0l103n460Y1I0e/chart.jpg .
- `general_extra`: _string_, text, later replaced into EXTRA keyword in search url.
- `general_keywords`: _string_, query for general searches (when you type the query).
- `general_query`: _string_, part of url, added to `base_url`.
- `language`: _string_, 2-char language definition, which language is used to searches.
- `login_failed`: _string_, text to search, to identify we failed with loggin (or better a unique text that indicates we are not logged in).
- `login_object`: _string_, object to use for logging in. _USERNAME_ and _PASSWORD_ are substituted.
- `login_path`: _string_, url, used to _POST_ login object to.
- `movie_extra`: _string_, text, later replaced into EXTRA keyword in search url.
- `movie_keywords`: _string_, query for movie searches.
- `movie_query`: _string_, part of url, added to `base_url`.
- `parser`: _array_, defines how to parse result page.
    - `row`: query searches for rows, each of them will be parsed for torrent information.
    - `name`: query for torrent name.
    - `seeds`: query for seeds count.
    - `peers`: query for peers count.
    - `size`: query for torrent size.
    - `torrent`: query for torrent file link or magnet link.
- `season_extra`: _string_, text, later replaced into EXTRA keyword in search url.
- `season_extra2`: _string_, text, later replaced into EXTRA keyword in search url.
- `season_keywords`: _string_, query for season searches.
- `season_keywords2`: _string_, query for season searches.
- `season_query`: _string_, part of url, added to `base_url`.
- `separator`: _string_, chars, used to separate words in the query (like `%20` or `-`).
- `show_query`: _string_, string that is added to the `base_url` for episodes searches.
- `subpage`: _boolean_, defines if provider needs a separate request to get _parser->torrent_ link and find magnet/torrent there.
- `tv_extra`: _string_, text, later replaced into EXTRA keyword in search url.
- `tv_extra2`: _string_, text, later replaced into EXTRA keyword in search url.
- `tv_keywords`: _string_, query for episode searches.
- `tv_keywords2`: _string_, query for episode searches.




### Icon

Icon requirements are pretty easy:

- 256x256 size
- Transparent  background
- _PNG_ format

Place it with `provider_id.png` file name and it will be used everywhere.

## Parsing rules

Our parser is `ehp.py`, it's not an XPath parser, but it gives you fine speed and is pretty fault-tolerant to broken html code.

Project code: https://github.com/iogf/ehp

You can see examples in existing definitions. Basically you will need:

* `find_once` if you need to fine one item;
* `find_all` if you need a list of results (like rows);
* `item` if you need something specific (like name or specific link).

## Debugging

Kodi Locations can be discovered here: https://kodi.wiki/view/Log_file/Advanced#Location

### Python Code 

You can copy your cloned git repository into Kodi path and just run search from Kodi, it will use the new code without need to restart Kodi. So you can easily run and track results.

In Linux it's something like:

`cp -rf /path/to/your/repo/* ~/.kodi/addons/script.elementum.burst/`

### Parser

Then, if you also want to debug the parser, you can enable excessive debugging:

`Burst Kodi settings -> Advanced -> Log debug messages for parsing`

You will see what parser rule we run, and what we match. 

### Enabling providers

Added provider is not enabled for searching by default, you have to enable it in Kodi settings.
So you can run `./scripts/generate_settings.py` to regenerate _settings.xml_ file, then copy it to Kodi and restart Kodi (_settings.xml_ are read on load or addon installation only).

Only custom providers (not provided with Burst) are enabled by default and you cannon enable or disable them.
