+++
title = "Updating"
description = ""
weight = 4
+++

Update instructions.
<!--more-->

## How it works

Elementum has a self-hosted virtual Kodi repository. 
What it means? 

- When installed, Elementum adds a repository to Kodi. In some cases it is added, but not enabled, so you can manually enable it like any other addon.
- Repository update address points to the Elementum addon, so it you Elementum cannot start - repository is not working.
- This was made in that way to be able to change repository source in the code, in case github in inaccessible, or something.
- Plugin knows which OS architecture it needs, so it's downloading only that architecture zip file.
- Repository contains the Addon itself, Burst addon, Context addon, you can install or update any of them.

> Please, don't use third-party repositories to install or update the addon, unless you know they are providing you with the universal package, which contains all the architectures.

So, if you addon works fine - you can simply update the addon as usually, or leave it to Kodi.
If not, then you should re-download addon from [Downloads]({{%relref "platforms-page.md"%}}) and re-install from zip. No need to remove the addon before installing.
