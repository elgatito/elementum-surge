+++
title = "Making a log file"
description = ""
weight = 3
+++

<!--more-->

## About

Log file in Kodi is a _kodi.log_ file, located in temporary directory. 
Location of that directory depends on the platform, and even on the same platform it can differ.
Locations can be discovered here: https://kodi.wiki/view/Log_file/Advanced#Location

## Preparation

First of all, log file, by default, contains only limited records, only errors or some notable actions, but, to understand the cause of an issue, we need full log. 
So we need to enable debugging in Kodi.

- Enter Kodi System settings
    ![Enter Kodi System settings](/screenshots/log4.png)
- Enable Expert level of settings
    ![Enable Expert level of settings](/screenshots/log6.png)
- Enable event logging
    ![Enable event logging](/screenshots/log5.png)
- That is it! But you probably won't like the onscreen information about CPU usage and so on. So you can create an _advancedsettings.xml_ file in Kodi's Userdata folder (https://kodi.wiki/view/Userdata), which this content:
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
    It will enable logging and hide onscreen information.

- Now your Kodi records everything into the log file!

## What we have

Elementum has few HTTP links which can give you more information about torrenting status, system information, some timers of common operations (which are way too useful for developers!):
- _/debug/bundle_ will give you all the debug information + _kodi.log_ file included. So it's the fullest log file, and is what we'd expect from you to find the problem.
- _/debug/all_ contains all the debug information, *without* _kodi.log_, so it's all about the system and torrent engine, but not Kodi.

To find proper link:
- Enter Elementum addon, open Status
    ![Enter Elementum addon, open Status](/screenshots/log1.png)
- In the table you can see the address, that can be opened from other devices (in case you Kodi runs on a separate device in the network)
    ![Status output](/screenshots/log2.png)


## Two ways of taking a log file:

### Easy one

If your Elementum starts fine, so you can enter it, browse for something, then you can try this way, if not, please, browse for the Hard one.

There is bundled functionality to upload your _/debug/bundle_ or _/debug/all_ logs to pastebin services. 
All you need is to enter settings and start an upload:

- Enter Elementum settings, open Advanced tab, browse to Logging section and you can see there are Upload options. 
    ![Enter Elementum settings, open Advanced](/screenshots/log3.png)
- Now you get an url of a paste. Write it down and share in your issues!

Easy enough?!

### Hard one

Still not so hard, but, sadly, more manual and needs some effords, at least, for the first time.
So you can follow the manual here: https://kodi.wiki/view/Log_file/Easy

Shortly, you can install log uploader plugin, and run it to get pastebin link of an uploaded log file.
Or you can find your log location here: https://kodi.wiki/view/Log_file/Advanced#Location and use it manually.