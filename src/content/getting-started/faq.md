+++
title = "F.A.Q."
description = "Frequently asked questions"
weight = 5
+++

<!--more-->

### "watched" status from Trakt does not show, "resume N seconds earlier" does not work, etc

Enable these options in elementum (you don't need to set up library in Kodi, unless you want to):
* "Enable library integration with Kodi"
* "Enable Kodi library synchronization"
* "Enable synchronization while playback"

### How to use "files" storage in Android

"Download path" have to be inside Kodi data directory, e.g. `Android/data/org.xbmc.kodi/files/downloads`.

### Slow speed on download start in Android with files storage

If you use external HDD - you need to format it as internal storage.
With NTFS it will take decent amount of time to create new big file, that's why you will see slow speed in the beggining.

### What exactly all these limits mean

* https://www.libtorrent.org/reference-Settings.html#share_ratio_limit
* https://www.libtorrent.org/reference-Settings.html#seed_time_ratio_limit
* https://www.libtorrent.org/reference-Settings.html#seed_time_limit

### Slow download speed

* Read this guide: https://help.bittorrent.com/support/solutions/articles/29000033439-optimizing-your-internet-connection-connection-guide-

* Check UPNP table on your router to see if elementum ports are there (deafault range is 6891-6899)

* Play with settings on "BitTorrent" tab

### How to use Elementum integration with Kodi library

* Enable these options in elementum:
  * "Enable library integration with Kodi"
  * "Enable Kodi library synchronization"
  * "Enable synchronization while playback"
* Add `elementum_library/Movies/` as a Movies source in the library
* Add `elementum_library/Shows/` as a Shows source in the library
* You might find ["context.elementum"]({{%relref "platforms-page.md#context-helper-downloads"%}}) useful as well

### How to use elementum on Android 4.4

You have to use old version [0.1.41](https://github.com/elgatito/plugin.video.elementum/releases/tag/v0.1.41). More details [here](https://github.com/elgatito/plugin.video.elementum/issues/576).
