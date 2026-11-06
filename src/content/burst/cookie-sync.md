+++
title = "Cookie sync"
description = "Log in to trackers with cookies from your browser"
weight = 4
+++

<!--more-->

## What it is

Burst can't log in to some trackers by itself: they use captchas, Cloudflare checks or two-factor login.
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

1. Turn on **Enable Cookie sync** (on by default).
2. If you set an encryption key in the extension, enter the same key in **Encryption password**.
   Leave **File name** as `kevast-gist-default.json` (the extension's default), unless you changed it in the extension.
3. Click **Connect GitHub and select Gist**. Kodi shows a web address (`github.com/login/device`) and a code.
   Open that address on any device, like your phone or computer, sign in to **the same GitHub account** the extension uses, enter the code and authorize.
   Burst asks only for access to Gists. The code is valid for 15 minutes, Kodi waits until you authorize or click _Cancel_.
4. Select the Gist with your cookies. Every Gist with the cookies file is listed with its ID, the number of cookies and sites in it, and when it was updated.
   The most recently updated Gist is preselected.

The settings now show the **GitHub user** and the **Active Gist**. Click **Select another Gist** to change the Gist at any time.
If no Gist is found, push cookies from the extension first: until a Gist is selected, Burst uses the most recently updated Gist with the cookies file.

| Setting | Value |
|---------|-------|
| Enable Cookie sync | On (default) |
| Encryption password (optional) | The encryption key you set in the extension. |
| File name (optional) | `kevast-gist-default.json` (the extension's default). |
| Connect GitHub and select Gist | Authorizes Burst in GitHub and selects the Gist. Run it again to use another GitHub account. |
| GitHub user | The connected GitHub account, read only. |
| Select another Gist | Selects another Gist of the connected account. |
| Active Gist | The Gist Burst reads, with its ID and the number of cookies and sites, read only. |

## How it works

- Before each search, Burst reads the Gist and adds its cookies to its own cookie storage.
  It also uses the browser User-Agent saved in the Gist, and remembers it, so the cookies keep working when GitHub is not reachable.
- Cookie sync is used only by providers that support it (they have `login_cookie` in their definition, see [Login]({{% relref "definition.md#login-private-trackers" %}})).
  For such a provider, when the cookie is there, Burst skips the login form.
- Cookies that trackers change during a search are kept for the next searches, and pushed back to the Gist for the sites that came from the Gist.
  Turn on **Auto Merge** for these sites in the extension on your other browsers, to get them there too.

For trackers behind Cloudflare checks, see [Cloudflare-protected trackers]({{% relref "cloudflare.md" %}}).

## Troubleshooting

- **No Gists with ... file found**: the extension has not pushed any cookies yet, or Burst is connected to another GitHub account than the extension, or **File name** differs from the extension's file name.
- **Device code expired**: the code was not entered in 15 minutes, click **Connect GitHub and select Gist** again.
- Cookies are not used, and the log has _"Failed parsing cookies"_: **Encryption password** differs from the extension's encryption key.
- Expired cookies are skipped. Burst then logs _"Skipping expired cookie ..., re-sync cookies in the browser"_, and falls back to the login form if the provider has one. Log in in the browser again and push.
- Cookie sync and provider login errors are shown in the search notification and written to the [log]({{% relref "/help/log.md" %}}).
- _Burst settings → Maintenance → Remove cookies_ clears all cookies Burst has stored, the next search gets them from the Gist again.
- To disconnect Burst from GitHub, revoke its access in GitHub → _Settings → Applications → Authorized OAuth Apps_.
