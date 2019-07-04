#!/bin/bash

function command_exists {
  command -v "$1" > /dev/null;
}

echo "git \"file://$($(dirname $0); pwd)\"" >> Cartfile

# carthage
if ! command_exists brew ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew upgrade --all
  brew doctor
  brew -v
fi

if ! command_exists carthage ; then
  brew install carthage
fi

carthage update --platform iOS --no-use-binaries --cache-builds

# SwiftLint
if ! command_exists swiftlint ; then
  brew install swiftlint
fi

