+++
title = "JSON API"
description = "Browse, search, play and manage Elementum from your own app or script"
weight = 1
+++

The JSON API is how apps talk to Elementum: the Samsung TV app uses it, and so can your scripts and tools.
It is part of Elementum 0.1.120 and later, on the same port as everything else (`65220` by default).

- **Base URL:** `http://<elementum address>:65220/api`
- **Contract:** `/api/openapi.yaml` (OpenAPI 3). Every request and response is described there, with examples.
- **Try it:** `/api/docs` is a Swagger UI on that contract, in your browser.

There is one contract, without versions in the URL. Clients are updated together with Elementum;
`GET /api/system/info` tells the version a client talks to.

## Requests

- **Login:** HTTP Basic, with Elementum's login, when one is set (see [Logging in]({{% relref "_index.md#logging-in" %}})).
  `GET /api/system/info` says whether one is needed (`auth_required`) and works as a "test connection" call.
- **Errors:** every error has the same body, `{"error": {"code": "...", "message": "..."}}`.
  Branch on `code`; `message` is for people. Codes: `bad_request`, `unauthorized`, `forbidden`, `not_found`,
  `tracker_not_authorized`, `tracker_unsupported`, `already_in_library`, `providers_unavailable`, `playback_failed`,
  `ui_request_expired`, `not_implemented`, `internal_error`.
- **Pages:** lists take `page` (from 1) and `limit` (1 to 100, Elementum's "results per page" by default),
  and answer `{"items": [...], "page", "limit", "total_pages", "total_results"}`.
- **Language:** `lang=de` or `lang=de-DE` gives titles, overviews, images and texts in that language; Elementum's language by default.
- **Browsers:** every origin may call the API (CORS), and `X-UI-Epoch` can be read from responses.

```sh
curl -u user:secret http://192.168.1.10:65220/api/system/info
```

```json
{"version": "0.1.120", "auth_required": true, "language": "en", "kodi_connected": false,
 "settings_source": "file", "tracker": {"id": "trakt", "name": "Trakt", "authorized": true, "logins": 0}}
```

## What it covers

| Group | Paths |
|---|---|
| System | `GET /system/info`: version, login, language, linked tracker, whether Kodi is connected, where settings come from. |
| Movies and shows | `/movies/lists/{list}` (`popular`, `trending`, `top_rated`, `now_playing`, `upcoming`, `by_genre`), `/movies/genres`, `/movies/{tmdb_id}`, the same under `/shows` (`on_the_air` instead of `now_playing`/`upcoming`), `/shows/{tmdb_id}/seasons/{season}`, `/search?query=&type=movie\|show`, `/people/{tmdb_id}`, `/people/{tmdb_id}/credits`. |
| Torrent search | `/movies/{tmdb_id}/streams`, `/shows/{tmdb_id}/seasons/{season}/episodes/{episode}/streams`. |
| Playback | `POST /playback`, `GET` and `DELETE /playback/{id}`, `POST /playback/{id}/progress`, `/stream/{id}/{file_index}`. |
| Library and watched | `/library/movies`, `/library/shows`, `POST` and `DELETE /library/{movies\|shows}/{tmdb_id}`, `POST` and `DELETE /watched/{movie\|show\|season\|episode}`. |
| Trackers | `/trakt/{media}/lists/{list}` (public Trakt charts), `/tracker/{media}/watchlist`, `/tracker/{media}/collection`, `/tracker/shows/progress`, `/tracker/lists`, `/tracker/lists/{list_id}/items`, `POST /tracker/authorize`. |
| Torrents | `/torrents`, `POST /torrents/{info_hash}/pause` and `/resume`, `DELETE /torrents/{info_hash}?delete_files=`. |
| Built-in search | `/providers`, `PUT /providers/{id}`, `/providers/options`, `PUT /providers/options/{id}`, `POST /providers/cookie-sync/login`, `/providers/cookie-sync/gists`. See [Built-in search]({{% relref "/burst/builtin.md#settings-over-the-api" %}}). |
| Dialogs | `/ui/events` and `POST /ui/requests/{id}`: Elementum's notifications and questions, see [below](#notifications-and-questions). |

Lists, details and search results carry the item's state where Elementum knows it: in the library, watched, in the watchlist or collection, and the resume point.

## Finding a torrent

```sh
curl -u user:secret http://192.168.1.10:65220/api/movies/603/streams
```

The answer is a list of streams, best first: `uri` (magnet or torrent link), `name`, `provider`, `seeds`, `peers`, `size_bytes`,
and what Elementum read from the name (`resolution`, `rip`, `codec`, `audio`, `language`).

- Elementum searches with its [built-in search]({{% relref "/burst/builtin.md" %}}), or with Kodi provider add-ons, as its settings say
  ([which search is used]({{% relref "/burst/_index.md#which-search-is-used" %}})).
  `502 providers_unavailable` means it has nothing to search with: the built-in search is off and no Kodi is reachable.
- A search takes up to the provider timeout (40 seconds, or _Custom provider timeout_ in the settings); give the request a longer timeout.
- Results are cached like Kodi's searches, so asking again is fast.

## Playback

Playback goes through a **session**: Elementum adds the torrent, buffers the file, and gives a link your player opens.
One session is active at a time; starting another one stops the previous one.

1. **Start:** `POST /api/playback` with the stream you chose:

   ```json
   {"uri": "magnet:?xt=urn:btih:...", "type": "episode", "tmdb_id": 1396, "season": 1, "episode": 1}
   ```

   `tmdb_id` is the movie's or the **show's** id. The `uri` must be one Elementum found (from the streams above), a magnet,
   or a `.torrent` Elementum saved; other links are refused. The answer is the session, with its `id`.
2. **Poll** `GET /api/playback/{id}` about once a second. Its `state` goes through:

   | State | Meaning |
   |---|---|
   | `resolving` | Getting the torrent's metadata. |
   | `buffering` | Downloading the start of the file; `buffer_progress` (0–100), `download_rate`, `seeds`, `peers` show how it goes. |
   | `choosing_file` | Elementum could not choose the file. `files` lists the candidates: start again with `"file_index"` set to one of them. |
   | `ready` | Play `stream_url`. `resume_s` is where to start, in seconds, when there is a resume point. |
   | `error` | The torrent could not be played; `error` says why. |
   | `stopped` | Stopped by you, by a new session, or because it was idle. |

   A session without a poll or a progress report for **60 seconds** is stopped.
3. **Play** `stream_url`. It is a signed link to `/api/stream/{id}/{file_index}`, valid for 12 hours, that needs no login and supports `HEAD` and Range requests.
4. **Report progress** while playing, every 10 seconds or so: `POST /api/playback/{id}/progress` with `{"position_s": 615, "duration_s": 7342, "paused": false}`.
   This keeps the session, stores the resume point and scrobbles to the linked tracker.
5. **Stop:** `DELETE /api/playback/{id}`. The torrent is removed or kept as Elementum's settings say.

## Notifications and questions

Elementum sometimes has something to say or to ask: a notification, "which file?", a confirmation, a progress bar.
In Kodi these are dialogs. An app gets them by long-polling:

```sh
curl -u user:secret "http://192.168.1.10:65220/api/ui/events?client_id=tv-livingroom&wait=25&lang=en"
```

- `client_id`: a name for your app instance (letters, digits, `-`, `_`). While a client polls, Elementum counts it as connected
  and asks it its questions; Kodi is asked only when no app is connected.
- The call returns as soon as there is an event, or with `204` after `wait` seconds (0–60). Pass the last `seq` you handled as `since`
  on the next call, and the `X-UI-Epoch` header as `epoch`: a different epoch means Elementum restarted.
- `kind` is `notify`, `confirm`, `select`, `input`, `text`, `progress`, or `cancelled` (close the dialog with that `id`: answered elsewhere or expired).
  Texts are already translated into `lang`.
- Answer with `POST /api/ui/requests/{id}` and `{"client_id": "...", "yes": true}`, `{"selected": [2]}`, `{"text": "..."}`, or `{"cancel": true}`.
  The first answer wins; later ones get `410 ui_request_expired`.

## Linking a tracker account

`POST /api/tracker/authorize` starts the login of the tracker selected in Elementum's settings (Trakt, Simkl, MDBList or Scrob)
and answers with `user_code` and `verification_url` to show to the user. Elementum waits for the approval itself;
`GET /api/system/info` shows the account as `authorized`, and `tracker.logins` goes up by one when a login has finished.
It needs a JSON settings file or Kodi to keep the token.
