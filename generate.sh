#!/bin/bash

CWD=$(pwd)
GIT_VERSION=$(git rev-parse HEAD)

# Data of the latest releases of all addons
./scripts/fetch_upstream.sh || exit 1

cd "${CWD}/src/" || exit 1
hugo --cleanDestinationDir -d dist/ && python3 ../scripts/check_site.py dist/ || exit 1
cp -Rf dist/* ../static/

# Upload to Surge
surge -p ${CWD}/static/ -d elementum.surge.sh

# Upload to Github
rm -rf remote
git config --global push.default simple
git clone --depth=1 https://github.com/ElementumOrg/elementumorg.github.io remote
cp -Rf ${CWD}/static/* remote/
cd remote && \
  git add * && git commit -m "Update to ${GIT_VERSION}"
  git remote add static https://$GH_USER:$GH_TOKEN@github.com/ElementumOrg/elementumorg.github.io && \
  git push static master && \
  cd .. && \
  rm -rf remote
