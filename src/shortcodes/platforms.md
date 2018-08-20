+++
title = "platforms"
description = "Lists available platforms"
+++

{{ range $.Site.Data.platforms }}
   <li>{{ . }}</li>
{{ end }}
