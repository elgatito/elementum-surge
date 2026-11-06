+++
title = "Cloudflare-protected trackers"
description = "What to enable so searches pass Cloudflare checks, and what breaks them"
weight = 5
+++

<!--more-->

Many trackers are behind Cloudflare. It shows a check page ("Just a moment...", a captcha) to clients it does not trust,
and Burst cannot solve these checks by itself. Instead, you pass the check once in your browser, and Elementum and Burst
continue with your browser's cookies, looking like that same browser.

This needs Elementum 0.1.119 and Burst 0.0.102, or newer.

## How Cloudflare decides

After you pass the check, Cloudflare sets a `cf_clearance` cookie. The cookie is accepted only while the requests look like they come from the same browser:

- the same **User-Agent** (browser name, version and OS),
- the same **public IP address**,
- the same **TLS and HTTP/2 fingerprint**, the way the browser opens connections, which differs between browsers and HTTP libraries,
- **headers** a browser would send, and a request rate a person could make.

If any of these changes, the cookie is not accepted, and Cloudflare shows the check page again.

## How Elementum and Burst handle it

1. [Cookie sync]({{% relref "cookie-sync.md" %}}) brings the tracker cookies, and the browser User-Agent, from your browser to Burst.
2. Burst sends its requests with that User-Agent and the headers a browser sends when it opens a page.
3. Requests go through the Elementum **built-in HTTP proxy**. It opens connections to the tracker with the TLS and HTTP/2 fingerprint of the browser named in the User-Agent.
4. Torrent files from the search results are downloaded by Elementum through the same proxy, with the same cookies and User-Agent.

## What to set

| Where | Setting | Value |
|-------|---------|-------|
| Elementum → _Proxy_ | Enable built-in HTTP proxy | **On** |
| Burst → _General_ | Proxy http requests with Elementum | **On** (default) |
| Burst → _Cookie sync_ | Enable Cookie sync | **On**, and set up as described in [Cookie sync]({{% relref "cookie-sync.md" %}}) |
| Burst → _General_ | Use custom browser User Agent | **Off**: the User-Agent from cookie sync is used. If you set it, it must be exactly the User-Agent of the browser that pushes the cookies. |
| Burst → _Proxy_ | Enabled | Not used while the built-in proxy is on: Burst requests always go through the built-in proxy, which uses the proxy from Elementum settings (see below). |

Elementum → _Proxy_ → _Use built-in proxy for Elementum requests_ is not needed for this: torrent files from search results always go through the built-in proxy when it is enabled.

In the browser, keep **Auto Push** on for every tracker in SyncMyCookie, so Burst gets new cookies as soon as the browser gets them.

## Supported browsers

The built-in proxy can look like these browsers:

| Browser | Versions |
|---------|----------|
| Chrome, Edge, Brave, Opera and other Chromium-based browsers | 131 and newer (also 107–114 and 120–123) |
| Firefox | 157 and newer |
| Safari | 26 and newer |

SyncMyCookie works in Chromium-based browsers, so keep your browser up to date.
If the User-Agent belongs to another browser or version, requests are sent as Chrome on Linux instead, and Elementum logs
_"Cannot impersonate ..., sending as Chrome ... instead"_. Searches still work for sites without Cloudflare checks,
but the cookies from cookie sync are not accepted by Cloudflare.

## Things to take into account

**The same public IP.** Kodi and the browser must reach the tracker from the same public IP address. Check these:

- A VPN on the Kodi device, but not on the browser device (or the other way round), or a different VPN server.
- A proxy in Elementum → _Proxy_ with _Use Proxy for downloading .torrent files_ on, or _Use Antizapret proxy_: the built-in proxy sends requests through it,
  so the browser has to use the same proxy, or the proxy has to be turned off.
- IPv4 and IPv6: if the browser connects to the site over IPv6 and Elementum over IPv4, the IPs differ. Elementum → _Proxy_ → _Use built-in DNS resolver_ with _Skip IPv6 addresses resolving_ makes Elementum use IPv4, then use IPv4 in the browser too.

**Cookies expire.** Each site sets how long `cf_clearance` lives, from minutes to days.
When it is expired, Burst logs _"Cloudflare challenge for &lt;site&gt;: open the site in the browser ..."_. Open the site in the browser, pass the check, and SyncMyCookie pushes the new cookies.

**Browser updates.** After the browser updates, its User-Agent changes, and old cookies are bound to the old one.
Open the trackers in the browser after an update, so the cookies are pushed again together with the new User-Agent.

**Request rate.** Cloudflare also blocks clients that send too many requests. Burst does not retry rate limited or challenged requests
and opens at most 4 pages of one tracker at once, but running many searches in a row can still trigger the limits. Wait a few minutes then.

**Elementum on another device.** If Elementum runs on another device than Kodi, Burst connects to the built-in proxy on port `65222` of that device, so the port must be reachable from Kodi.
The proxy also does not start if another application already uses that port, Elementum then logs _"Could not start internal proxy"_.

**Checks Burst cannot pass.** Sites that show a check page to every visitor, or ask to solve a captcha on each search, cannot be searched this way.

## Troubleshooting

- Elementum → _Providers_ → _Test search providers_ runs a test search with every provider and shows what is wrong with its results.
- Elementum → _Proxy_ → _Log Internal proxy requests_ writes each request and response of the built-in proxy to the [log]({{% relref "/help/log.md" %}}). Look for status `403` or `503` from the tracker, and for the `cf-mitigated: challenge` header.
- Look in the log for _"Cannot impersonate"_ (browser not supported, see above) and _"Cloudflare challenge for"_ (cookies are missing, expired, or the IP or User-Agent changed).
- _Burst settings → Maintenance → Remove cookies_ clears cookies Burst has stored, the next search gets them from cookie sync again.
