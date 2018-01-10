#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

VERSION=$(grep version= platform.txt | sed 's/version=//g')

FILENAME="arduino-senseBoxCore-$VERSION.tar.bz2"
OUTPUTFOLDER="packages"
OUTPUTNAME="$OUTPUTFOLDER/$FILENAME"

JSON_FILENAME="package_sensebox_index.json"
JSON_FILENAME_BCKP="package_sensebox_index.json_original"
SENSEBOXCORE_URL="file:///${TRAVIS_BUILD_DIR}/${JSON_FILENAME}"
BOARD_TO_INSTALL="senseBox:samd:${VERSION}"

BOARD="senseBox:samd:sb"

testRelease () {
  echo "Creating testing package_sensebox_index.json ... "
  mv "${JSON_FILENAME}" "${JSON_FILENAME_BCKP}"
  # modify the package_sensebox_index.json to use local url for the package
  jq -rM --arg version "$VERSION" --arg url "file://${TRAVIS_BUILD_DIR}/${OUTPUTNAME}" -f extras/replace_local_url.jq "${JSON_FILENAME_BCKP}" > "${JSON_FILENAME}"
  echo "done"

  echo "Installing the core ... "
  arduino --pref "boardsmanager.additional.urls=${SENSEBOXCORE_URL}" --install-boards "${BOARD_TO_INSTALL}"
  echo "done"

  # Build the Blink example
  echo "Compiling test sketch ... "
  arduino --verbose-build --verify --board "${BOARD}" "${TRAVIS_BUILD_DIR}/libraries/senseBox/examples/Blink/Blink.ino"
  echo "done"

}

testRelease
