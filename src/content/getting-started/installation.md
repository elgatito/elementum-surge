+++
title = "Installation"
description = "Install Elementum in Kodi"
weight = 1
+++

## 1. Allow remote control in Kodi

Elementum talks to Kodi through its remote control interface (to update the library, add the repository and more).

Open _Settings → Services → Control_ and enable both **Application control** options.

![Kodi Services settings](/screenshots/install1.png)

![Both remote control options enabled](/screenshots/install2.png)

> [!NOTE]
> If one of the options was off, restart Kodi after enabling it.

## 2. Install the repository

Download the **ElementumOrg repository** zip from [Downloads]({{% relref "platforms-page.md" %}}),
then in Kodi open _Add-ons → Install from zip file_ and choose the downloaded file.

The repository works on any platform and keeps Elementum, Burst and Context up to date.

## 3. Install the add-ons

Open _Add-ons → Install from repository → ElementumOrg repository_ and install:

- **Elementum** (_Video add-ons_): the add-on itself.
- **Elementum Burst** (_Program add-ons_): searches torrent providers. Without it Elementum finds nothing.
- **Elementum Context** (_Context menus_, optional): adds "Elementum" items to the context menu of your Kodi library.

You can also install the Elementum zip from [Downloads]({{% relref "platforms-page.md" %}}) directly. Use the _all-in-one_ zip, it works on every platform.

Elementum is now in _Add-ons → Video add-ons_:

![Elementum main menu](/screenshots/install3.png)

## Next steps

- Go through the [settings]({{% relref "/configuration/kodi-settings.md" %}}), especially _General → Storage_ and the _Tracking_ service.
- If something doesn't work, check the [FAQ]({{% relref "/help/faq.md" %}}) or [get help]({{% relref "/help/_index.md" %}}).
