#!/bin/bash

#  pack.*.bash - Bash script to help packaging samd core releases.
#  Copyright (c) 2015 Arduino LLC.  All right reserved.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

set -euo pipefail
IFS=$'\n\t'

# check if needed tools are installed
jq --version >/dev/null 2>&1 || { echo >&2 "This script requires jq but it's not installed.  Aborting."; exit 1; }
curl --version >/dev/null 2>&1 || { echo >&2 "This script requires curl but it's not installed.  Aborting."; exit 1; }
tar --version >/dev/null 2>&1 || { echo >&2 "This script requires tar but it's not installed.  Aborting."; exit 1; }

VERSION=$(grep version= platform.txt | sed 's/version=//g')

PWD=$(pwd)
FOLDERNAME=$(basename "$PWD")
FILENAME="arduino-senseBoxCore-$VERSION.tar.bz2"
OUTPUTNAME="packages/$FILENAME"
INPUTNAME=$(dirname "$PWD")

# These variables hold references to the original Arduino boards package we are
# based on
ARDUINOBOARDPACKAGEURL="https://downloads.arduino.cc/packages/package_index.json"
ARDUINOBOARDPACKAGENAME="Arduino SAMD Boards (32-bits ARM Cortex-M0+)"
ARDUINOBOARDPACKAGEVERSION="1.6.17"

# wrap in functions to ensure script can be loaded correctly before executing anything
createArchive () {
  if [ -f "$OUTPUTNAME" ]; then
    echo "Error:"
    echo "File $OUTPUTNAME already exists. Please update the version in platform.txt to create a new version."
    echo "Exiting ..."
    exit
  fi

  echo -n "Creating tar archive $OUTPUTNAME ... "

  tar -C "$INPUTNAME" --transform "s|$FOLDERNAME|$FOLDERNAME-$VERSION|g" --exclude=extras --exclude=.git* --exclude=packages --exclude package_sensebox_index.json --exclude-from=.gitignore -cjf "$OUTPUTNAME" "$FOLDERNAME"

  echo "done"
}

updatePackageJson () {
  echo "Updating package_sensebox_index.json ... "

  echo -en "\tGetting toolsDependencies from upstream package ... "

  TOOLSDEPENDENCIES=$(curl --silent -L "$ARDUINOBOARDPACKAGEURL" | jq -rMc --arg name "$ARDUINOBOARDPACKAGENAME" --arg version "$ARDUINOBOARDPACKAGEVERSION" -f extras/extract_toolsDependencies.jq)

  echo "done"

  echo -en "\tConstructing new platform ... "

  # get filesize
  FILESIZE=$(stat -c "%s" "$OUTPUTNAME")

  # calculate checksum
  CHECKSUM="SHA-256:$(shasum -a 256 "$OUTPUTNAME" | cut -d " " -f 1)"

  NEWPLATFORM=$(jq -rMc --argjson toolsDeps "$TOOLSDEPENDENCIES" --arg version "$VERSION" --arg checksum "$CHECKSUM" --arg filesize "$FILESIZE" --arg filename "$FILENAME" -f extras/newPlatform.jq extras/platform.json.template)

  echo "done"

  echo -en "\tConstructing updated package_sensebox_index.json ... "

  jq -rM --argjson newPlatform "$NEWPLATFORM" -f extras/update_package.jq package_sensebox_index.json > new_package.json
  mv new_package.json package_sensebox_index.json

  echo "done"

  echo "done"
}

# call the functions
createArchive
updatePackageJson

