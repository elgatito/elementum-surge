+++
title = "LT2http"
description = "Kodi add-on settings and the options of the standalone lt2http binary"
weight = 3
+++

[LT2http]({{% relref "/lt2http/_index.md" %}}) can be configured in two ways:

1. **From Kodi**. The _LT2http_ add-on (`service.lt2http`) writes all its settings to `lt2http-config.json` in Kodi's temp folder
   and starts `lt2http --config=<that file>`. When you change settings, it sends them to the running engine (and restarts it when the port changes).
   See [Kodi add-on settings]({{% relref "kodi-settings.md" %}}).
2. **From the command line and a JSON config file**, when you run the `lt2http` binary yourself.
   See [Command-line options]({{% relref "command-line.md" %}}).

Both mostly use the same names: the setting ID in Kodi is also the command-line option and the key in the config file
(`buffer_size`, `download_storage`, `memory_size`, …).

{{% pages description="true" display="cards" %}}
