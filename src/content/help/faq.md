+++
title = "FAQ"
description = "Frequently asked questions"
weight = 1
aliases = ["/getting-started/faq/"]
+++

### Watched status from Trakt is not shown, "resume N seconds earlier" doesn't work, etc.

Enable these options in Elementum (you don't need to set up the library in Kodi unless you want to):

* "Enable library integration with Kodi"
* "Enable Kodi library synchronization"
* "Enable synchronization while playback"

### How to use "files" storage on Android

The "Download path" has to be inside the Kodi data directory, e.g. `Android/data/org.xbmc.kodi/files/downloads`.

### Download is slow at the start on Android with "files" storage

If you use an external HDD, format it as internal storage.
With NTFS it takes a long time to create a new big file, which is why the download is slow at the beginning.

### What exactly do all these limits mean?

* [share_ratio_limit](https://www.libtorrent.org/reference-Settings.html#share_ratio_limit)
* [seed_time_ratio_limit](https://www.libtorrent.org/reference-Settings.html#seed_time_ratio_limit)
* [seed_time_limit](https://www.libtorrent.org/reference-Settings.html#seed_time_limit)

### Slow download speed

* Read this guide: [Optimizing your internet connection](https://help.bittorrent.com/support/solutions/articles/29000033439-optimizing-your-internet-connection-connection-guide-).
* Check the UPnP table on your router to see if Elementum's ports are there (the default range is 6891-6899).
* Try different settings on the "BitTorrent" tab.

### How to use Elementum integration with the Kodi library

* Enable these options in Elementum:
  * "Enable library integration with Kodi"
  * "Enable Kodi library synchronization"
  * "Enable synchronization while playback"
* Add `elementum_library/Movies/` as a Movies source in the library.
* Add `elementum_library/Shows/` as a TV Shows source in the library.
* You might find the [Context add-on]({{% relref "/context/_index.md" %}}) useful as well.

### How to use Elementum on Android 4.4

You have to use the old version [0.1.41](https://github.com/elgatito/plugin.video.elementum/releases/tag/v0.1.41). More details are [here](https://github.com/elgatito/plugin.video.elementum/issues/576).
