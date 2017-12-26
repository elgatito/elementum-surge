#!/bin/bash

CWD=$(pwd)
mkdir -p static/packages

for plugin in "elgatito/plugin.video.elementum" "elgatito/script.elementum.burst"; do
  cd ${CWD}/static/packages
  mkdir -p ${plugin}
  cd ${plugin}

  rm -f *

  VERSION=$(curl https://api.github.com/repos/${plugin}/releases/latest -s | jq .name -r)
  VERSION="v${VERSION}"

  wget https://raw.githubusercontent.com/${plugin}/${VERSION}/addon.xml
  echo -n ${VERSION} >> release
done

# surge -p ${CWD}/static/ -d elementum.surge.sh
