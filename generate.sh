#!/bin/bash

CWD=$(pwd)
GIT_VERSION=$(git rev-parse HEAD)

mkdir -p static/packages

for plugin in "elgatito/plugin.video.elementum" "elgatito/script.elementum.burst" "elgatito/context.elementum"; do
  cd ${CWD}
  go run generator.go ${plugin}

  cd ${CWD}/static/packages
  mkdir -p ${plugin}
  cd ${plugin}

  rm -f *

  VERSION=$(curl https://api.github.com/repos/${plugin}/releases/latest -s | jq .name -r)
  VERSION="v${VERSION}"

  wget https://raw.githubusercontent.com/${plugin}/${VERSION}/addon.xml
  echo -n ${VERSION} >> release
done

cd ${CWD}/src/
hugo -d dist/ && cp -Rf dist/* ../static/

# Upload to Surge
surge -p ${CWD}/static/ -d elementum.surge.sh

# Upload to Github
rm -rf remote
git config --global push.default simple
git clone --depth=1 https://github.com/ElementumOrg/elementumorg.github.io remote
cp -Rf ${CWD}/static/* remote/
cd remote && \
  git add * && git commit -m "Update to ${GIT_VERSION}"
  git remote add static https://$GH_TOKEN@github.com/ElementumOrg/elementumorg.github.io && \
  git push static master && \
  cd .. && \
  rm -rf remote
