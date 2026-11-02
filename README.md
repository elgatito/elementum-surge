# Surge website for Elementum addon

How do test changes
------------

1. Install Hugo **0.169.0** or newer (https://gohugo.io/installation/). CI uses the version from `HUGO_VERSION` in `.github/workflows/build.yml`.
2. Install `go`, `jq` and `curl`, and run `scripts/fetch_upstream.sh` to get data of the latest releases (see below).
3. From `src/` directory run `hugo server -d dist/`

Once you change any page, it will be automatically regenerated.

To run the same checks as CI (`.github/workflows/build.yml`), from `src/` run `hugo -d /tmp/site && python3 ../scripts/check_site.py /tmp/site`.

Preview
-------

CI publishes a preview to this repository's GitHub Pages: https://elgatito.github.io/elementum-surge/ (not production).
It is updated on every push to `master`. To preview another branch, run the "Build" workflow manually on it
(Actions → Build → Run workflow); the preview always shows the last published run.

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
