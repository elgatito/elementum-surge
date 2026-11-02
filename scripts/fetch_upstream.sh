#!/bin/bash
# Fetches data of the latest releases of all addons, used by the docs build:
#   src/data/<addon>/platforms.json             download links (generator.go)
#   src/upstream/<addon>/                       release notes, settings, daemon flags (shortcodes)
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
  [elgatito/script.elementum.burst]="changelog.txt"
  [elgatito/context.elementum]="changelog.txt"
  [vasilky3/script.elementum.jackett]=""
  [ElementumOrg/service.lt2http]=""
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
    fetch "${repo}" "${ref}" "${f}" "src/upstream/${name}/${f##*/}"
  done

  if [[ ${name} == plugin.video.elementum ]]; then
    # The daemon has no releases of its own, it is tagged with the addon version
    mkdir -p src/upstream/elementum
    fetch elgatito/elementum "${version}" config/config.go src/upstream/elementum/config.go
  fi

  if [[ ${name} == service.lt2http ]]; then
    # The engine is tagged with the addon version, its changelog is a C++ string with <b>version:</b> headers
    fetch ElementumOrg/lt2http "${version}" src/app/changelog.h src/upstream/lt2http-changelog.h
    sed -n '/R""""(/,/)"""";/p' src/upstream/lt2http-changelog.h | sed -e '1d;$d' -E -e 's#^<b>(.*):</b>#[B]\1[/B]#' \
      > "src/upstream/${name}/changelog.txt"
    rm src/upstream/lt2http-changelog.h
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
