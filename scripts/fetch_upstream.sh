#!/bin/bash
# Fetches data of the latest releases of all addons, used by the docs build:
#   src/data/<addon>/platforms.json             download links (generator.go)
#   src/upstream/<addon>/                       release notes, settings, daemon/lt2http options (shortcodes)
#   static/packages/<repo>/{addon.xml,release}  served to Kodi by the Elementum repository
# Fails on any missing file, so docs are never built from stale data.
# GH_TOKEN is optional, it raises GitHub API rate limits.

set -euo pipefail
cd "$(dirname "$0")/.."

AUTH=()
[[ -n "${GH_TOKEN:-}" ]] && AUTH=(-H "Authorization: token ${GH_TOKEN}")

fetch() { # <repo> <ref> <path> <output>
  curl -fsSL "${AUTH[@]}" "https://raw.githubusercontent.com/$1/$2/$3" -o "$4"
}

# Files rendered in docs, per repo
declare -A FILES=(
  [elgatito/plugin.video.elementum]="whatsnew.txt resources/settings.xml resources/language/resource.language.en_gb/strings.po"
  [elgatito/script.elementum.burst]="changelog.txt resources/settings.xml resources/language/resource.language.en_gb/strings.po"
  [elgatito/context.elementum]="changelog.txt"
  [vasilky3/script.elementum.jackett]=""
  [ElementumOrg/service.lt2http]="resources/settings.xml resources/language/resource.language.en_gb/strings.po"
  [ElementumOrg/repository.elementumorg]=""
)

rm -rf src/upstream

for repo in "${!FILES[@]}"; do
  name=${repo#*/}
  version=$(curl -fsSL "${AUTH[@]}" "https://api.github.com/repos/${repo}/releases/latest" | jq -er .tag_name)
  echo "${repo}: ${version}"

  out=$(go run generator.go "${repo}") || { echo "${out}"; exit 1; }

  pkg="static/packages/${repo}"
  rm -rf "${pkg}" && mkdir -p "${pkg}"
  fetch "${repo}" "${version}" addon.xml "${pkg}/addon.xml"
  echo -n "${version}" > "${pkg}/release"

  mkdir -p "src/upstream/${name}"
  echo -n "${version}" > "src/upstream/${name}/version"
  for f in ${FILES[${repo}]}; do
    ref=${version}
    # changelog.txt is curated on the default branch and can be fixed after a release
    [[ ${f} == changelog.txt ]] && ref=HEAD
    dst="src/upstream/${name}/${f##*/}"
    # shortcut: older releases keep strings in the pre-Kodi-17 "English" folder, drop once all addons are released with resource.language.en_gb
    fetch "${repo}" "${ref}" "${f}" "${dst}" || { [[ ${f} == */strings.po ]] && fetch "${repo}" "${ref}" resources/language/English/strings.po "${dst}"; }
  done

  if [[ ${name} == plugin.video.elementum ]]; then
    # The daemon has no releases of its own, it is tagged with the addon version
    mkdir -p src/upstream/elementum
    fetch elgatito/elementum "${version}" config/config.go src/upstream/elementum/config.go
  fi

  if [[ ${name} == service.lt2http ]]; then
    # The engine is tagged with the addon version, its changelog.md has "## version" headers, made Kodi-style for kodinotes
    fetch ElementumOrg/lt2http "${version}" changelog.md src/upstream/lt2http-changelog.md
    sed -E 's#^\#\# (.*)#[B]\1[/B]#' src/upstream/lt2http-changelog.md > "src/upstream/${name}/changelog.txt"
    rm src/upstream/lt2http-changelog.md
    # Options of the standalone binary
    mkdir -p src/upstream/lt2http
    fetch ElementumOrg/lt2http "${version}" src/app/config.h src/upstream/lt2http/config.h
    fetch ElementumOrg/lt2http "${version}" src/app/config.cpp src/upstream/lt2http/config.cpp
  fi
done

# Every addon served by the repository must be on the Downloads page
repo_version=$(cat src/upstream/repository.elementumorg/version)
ids=$(curl -fsSL "${AUTH[@]}" "https://raw.githubusercontent.com/ElementumOrg/repository.elementumorg/${repo_version}/resources/repository.json" | jq -er '.[].id')
missing=0
for id in ${ids}; do
  grep -qF "platforms \"${id}\"" src/content/getting-started/platforms-page.md || { echo "${id}: served by the repository, missing on Downloads page"; missing=1; }
done
exit ${missing}
