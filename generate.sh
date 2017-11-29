#!/bin/bash

CWD=$(pwd)
mkdir -p static/packages

for plugin in "elgatito/plugin.video.elementum" "elgatito/script.elementum.burst"; do
  cd ${CWD}/static/packages
  mkdir -p ${plugin}
  cd ${plugin}

  rm -f *
  wget https://raw.githubusercontent.com/${plugin}/master/addon.xml
  VERSION=$(sed -ne "s/.*version=\"\([0-9a-z\.\-]*\)\"\sprovider.*/\1/p" addon.xml)
  VERSION="v${VERSION}"

  echo ${VERSION} >> release
done

surge -p ${CWD}/static/ -d elementum.surge.sh
