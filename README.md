# Surge website for Elementum addon

How do test changes
------------

1. Install Hugo **0.92.x extended** (https://github.com/gohugoio/hugo/releases/tag/v0.92.2). Newer versions don't work with the docdock theme.
2. Install `go`, `jq` and `curl`, and run `scripts/fetch_upstream.sh` to get data of the latest releases (see below).
3. From `src/` directory run `hugo server -d dist/`

Once you change any page, it will be automatically regenerated.

To run the same checks as CI (`.github/workflows/build.yml`), from `src/` run `hugo -d /tmp/site && python3 ../scripts/check_site.py /tmp/site`.

Release
-------

Release is done by running `release.sh` script, that generates static files and then pushes them to surge and github.

Generated pages
---------------

Docs are always built from the latest releases of all addons. `scripts/fetch_upstream.sh` (run by `generate.sh` and by CI) fetches:

- download links of every addon → `src/data/<addon>/platforms.json` (`generator.go`, `platforms` shortcode);
- `addon.xml` and release tag → `static/packages/<repo>/`, served to Kodi by the Elementum repository;
- `whatsnew.txt` (release tag) / `changelog.txt` (default branch) → "Release notes" pages (`kodinotes` shortcode);
- `settings.xml` + English `strings.po` of plugin.video.elementum → "Kodi addon settings" page (`kodisettings` shortcode);
- `config/config.go` of elementum, at the addon's release tag → flags on "Command-line options" page (`cliflags` shortcode).

`src/upstream/` is not committed. The script fails if anything is missing, so a release never goes out with stale data.
Set `GH_TOKEN` to avoid GitHub API rate limits.
