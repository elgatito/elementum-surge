+++
title = "Cookie sync"
description = "Log in to trackers with cookies from your browser"
weight = 3
+++

<!--more-->

## What it is

Some trackers can't be logged in from Kodi: they use captchas, Cloudflare checks or two-factor login.
With cookie sync you log in to the tracker in your browser, and Burst uses the same cookies (and the same browser User-Agent) for searches and torrent downloads.

Cookies travel through a private GitHub Gist:

1. The [SyncMyCookie v3](https://github.com/ElementumOrg/sync-my-cookie) browser extension pushes cookies of the sites you choose into a Gist, encrypted with your password.
2. Burst reads that Gist before each search and adds the cookies to its own cookie storage.

## Browser

1. Install SyncMyCookie v3 from the [Chrome Web Store](https://chromewebstore.google.com/detail/syncmycookie-v3/nbjjnnaeffojibdlfkbafbjnknafefac)
   or from [releases](https://github.com/ElementumOrg/sync-my-cookie/releases) (Chrome or another Chromium-based browser, version 130 or newer).
2. Open the extension options, click **Sign in with GitHub**, set an **encryption key** and click **Set**.
3. Log in to the tracker in the browser, open the extension on that site and click **Push**.
   Turn on **Auto Push** for the site, so cookies are pushed again when they change.

## Kodi

In _Burst settings → Cookie sync_:

| Setting | Value |
|---------|-------|
| Enable Cookie sync | On (default) |
| Github Token | A GitHub [personal access token](https://github.com/settings/tokens) with the `gist` scope, from the same GitHub account. |
| Encryption password (optional) | The encryption key you set in the extension. |
| Gist ID (optional) | Leave empty: Burst finds the Gist and fills it in. Set it if you have several sync Gists. |
| File name (optional) | `kevast-gist-default.json` (the extension's default). |
| File url (optional) | Leave empty, Burst fills it in. |

Cookie sync is used only by providers that support it (they have `login_cookie` in their definition, see [How to add provider]({{%relref "create.md#other-keys"%}})).
For such a provider, when the cookie is there, Burst skips the login form.

## Troubleshooting

- Expired cookies are skipped. Burst then logs _"Skipping expired cookie ..., re-sync cookies in the browser"_, and falls back to the login form if the provider has one. Log in in the browser again and push.
- Errors of cookie sync and provider logins are shown in the search notification and written to the log.
- _Burst settings → Maintenance → Remove cookies_ clears all cookies Burst has stored.
