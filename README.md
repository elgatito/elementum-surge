# Surge website for Elementum addon

How do test changes
------------

1. Install Hugo (https://gohugo.io/).
2. From `src/` directory run `hugo server -d dist/`

Once you change any page, it will be automatically regenerated.

Release
-------

Release is done by running `release.sh` script, that generates static files and then pushes them to surge and github.
