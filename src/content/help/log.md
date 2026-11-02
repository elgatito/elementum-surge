+++
title = "Making a log file"
description = "Collect a log file for a bug report"
weight = 2
aliases = ["/contribute/log/"]
+++

## About

Kodi writes its log to the _kodi.log_ file in its temporary directory.
The location of that directory depends on the platform, and can differ even on the same platform.
See [where to find it](https://kodi.wiki/view/Log_file/Advanced#Location).

## Preparation

By default, the log contains only errors and a few notable events. To find the cause of an issue, we need the full log,
so enable debug logging in Kodi and in Elementum:

- Open Kodi _System_ settings.
    ![Kodi System settings](/screenshots/log4.png)
- Switch the settings level to _Expert_.
    ![Expert settings level](/screenshots/log6.png)
- Enable debug logging.
    ![Enable debug logging](/screenshots/log5.png)
- That's it for Kodi! Debug logging also shows CPU usage and other information on screen.
  To hide it, create an _advancedsettings.xml_ file in [Kodi's userdata folder](https://kodi.wiki/view/Userdata) with this content:
  ```xml
  <?xml version="1.0" ?>
  <advancedsettings>
      <loglevel>2</loglevel>
      <debug>
          <extralogging>true</extralogging>
          <showloginfo>false</showloginfo>
      </debug>
  </advancedsettings>
  ```
  It enables debug logging and hides the on-screen information.
- In Elementum: open the add-on settings, go to the _Advanced_ tab and set _Log level_ to _Debug_.
    ![Enable debug logging in Elementum](/screenshots/log7.png)

Kodi now writes everything to the log file.

## Debug pages

Elementum has a few HTTP pages with information about torrents, the system, and timings of common operations (very useful for developers):

- _/debug/bundle_ has all the debug information and the _kodi.log_ file. It is the most complete log, and what we need to find a problem.
- _/debug/all_ has all the debug information **without** _kodi.log_: the system and the torrent engine, but not Kodi.

To find the address of these pages:

- Open the Elementum add-on and choose _Status_.
    ![Elementum Status](/screenshots/log1.png)
- The table shows the address, which can also be opened from other devices (if Kodi runs on another device in your network).
    ![Status output](/screenshots/log2.png)

## Two ways to get a log file

### The easy way

Use this if Elementum starts and you can browse it. Otherwise, see the [manual way](#the-manual-way).

Elementum can upload the _/debug/bundle_ or _/debug/all_ log to a pastebin service:

- Open the Elementum settings, go to the _Advanced_ tab and find the _Logging_ section with the upload options.
    ![Elementum settings, Advanced tab](/screenshots/log3.png)
- Elementum shows the URL of the uploaded log. Add it to your issue.

### The manual way

It takes a few more steps, at least the first time. Follow [Kodi's guide](https://kodi.wiki/view/Log_file/Easy):
install the log uploader add-on and run it to get a link to the uploaded log.
Or [find the log file](https://kodi.wiki/view/Log_file/Advanced#Location) yourself and attach it to the issue.
